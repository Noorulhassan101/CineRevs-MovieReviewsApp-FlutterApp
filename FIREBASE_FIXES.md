# Firebase Issues Fixed & Cleanup Guide

## Issues Resolved ✅

### 1. **Chat Message DateTime Type Error** 
**Error:** `type 'DateTime' is not a subtype of type 'String' in type cast`

**Root Cause:** The Firestore Timestamp was being converted to DateTime, but the JSON serialization expected a String.

**Fix Applied:** Updated `messaging_repository.dart` to convert DateTime back to ISO8601 strings before passing to `ChatMessage.fromJson()`.

**File Modified:** `lib/features/reviews/data/messaging_repository.dart`
- Changed: `data['createdAt'] = (data['createdAt'] as Timestamp).toDate();`
- To: `data['createdAt'] = (data['createdAt'] as Timestamp).toDate().toIso8601String();`

---

### 2. **Profile Picture Upload Failed**
**Error:** Profile picture upload failing due to incorrect Firebase Storage rules path matching.

**Root Cause:** Storage rules didn't match the actual file upload path format (`profile_pics/{userId}.jpg`).

**Fix Applied:** Updated `storage.rules` to correctly validate the path format and user authentication.

**File Modified:** `storage.rules`
```dart
// OLD (Incorrect path matching):
match /profile_pics/{userId} {
  allow write: if request.auth != null && request.auth.uid == userId;
}

// NEW (Fixed):
match /profile_pics/{fileName} {
  allow read: if true;
  allow write: if request.auth != null && request.auth.uid == fileName.split('.')[0];
}
```

---

## Clear Firebase Database & Storage

A cleanup script has been created: `clear_firebase.py`

### Setup Instructions:

1. **Install Firebase Admin SDK:**
```bash
pip install firebase-admin
```

2. **Download Firebase Service Account Key:**
   - Go to [Firebase Console](https://console.firebase.google.com)
   - Select your project
   - Click ⚙️ Settings → Project Settings
   - Go to "Service Accounts" tab
   - Click "Generate New Private Key"
   - Save the JSON file to your project root as `serviceAccountKey.json`

3. **Update the script:**
   - Open `clear_firebase.py`
   - Update line: `SERVICE_ACCOUNT_KEY = 'serviceAccountKey.json'`
   - Update the storage bucket name in the Firebase initialization (usually `your-project.appspot.com`)

4. **Run the cleanup script:**
```bash
python clear_firebase.py
```

5. **Confirm when prompted** by typing `YES`

### What Gets Deleted:
- ✅ All users
- ✅ All reviews
- ✅ All likes
- ✅ All comments
- ✅ All communities
- ✅ All community messages
- ✅ All collections
- ✅ All favorites
- ✅ All watchlist items
- ✅ All notifications
- ✅ All profile pictures and files in Storage

---

## Testing the Fixes

After running the cleanup script, you can test:

### 1. **Chat Messages:**
- Create a community
- Send a message in the community chat
- Should now work without DateTime casting errors ✅

### 2. **Profile Picture Upload:**
- Go to Edit Profile
- Select and upload a profile picture
- Should now upload successfully ✅

---

## Files Modified

1. **`lib/features/reviews/data/messaging_repository.dart`**
   - Fixed DateTime/String casting in message deserialization

2. **`storage.rules`**
   - Fixed Firebase Storage path matching for profile pictures

---

## Additional Notes

- These fixes ensure proper type conversion between Firestore Timestamps and DateTime objects
- Storage rules now correctly validate file paths and user permissions
- The cleanup script uses Firebase Admin SDK which bypasses security rules for administrative tasks

If you encounter any issues after running the cleanup, please check:
- Firebase credentials are correct
- Service account key JSON is valid
- Storage bucket name matches your Firebase project
- You have sufficient permissions in your Firebase project
