# Cloudinary Profile Picture Setup Guide

## Step 1: Create Cloudinary Account

1. Go to **https://cloudinary.com/users/register/free**
2. Sign up with your email
3. Verify your email

---

## Step 2: Get Your Credentials

1. Go to your **Cloudinary Dashboard**: https://cloudinary.com/console
2. Find your **Cloud Name** (looks like `djxxxxx` or similar)
   - You'll see it at the top of the page
3. Go to **Settings** → **Upload**
4. Scroll to **Upload presets**
5. Click **Add upload preset**
6. Fill in:
   - **Preset Name:** `cinevault_profile` (or any name you like)
   - **Signing Mode:** Select "Unsigned" ✅
   - Click **Save**

---

## Step 3: Update Configuration

Open this file: `lib/core/constants/cloudinary_config.dart`

Replace these values:
```dart
static const String cloudName = 'YOUR_CLOUD_NAME';      // ← Replace with your cloud name
static const String uploadPreset = 'YOUR_UPLOAD_PRESET'; // ← Replace with your preset name
```

**Example:**
```dart
static const String cloudName = 'djf1h4k7s';
static const String uploadPreset = 'cinevault_profile';
```

---

## Step 4: Rebuild Your App

```bash
flutter clean
flutter pub get
flutter build apk --release
```

Then reinstall on your phone.

---

## Step 5: Test Profile Picture Upload

1. Open your app
2. Go to **Edit Profile**
3. Click the profile picture circle
4. Select a photo from your gallery
5. Click save

**Expected result:** Profile picture uploads successfully! ✅

---

## How It Works

- Your app uploads images directly to **Cloudinary** (not Firebase)
- Cloudinary stores the image URL in its CDN
- Your app saves the URL to Firestore
- Profile pictures display from Cloudinary CDN

---

## Benefits

✅ **Free:** Free tier includes 25GB/month  
✅ **Unlimited uploads** (within monthly limit)  
✅ **CDN:** Images load fast worldwide  
✅ **Easy setup:** No Firebase Storage needed  
✅ **Secure:** Unsigned uploads only for images  

---

## Free Tier Limits

- **25 GB/month** storage
- **25 GB/month** bandwidth
- Perfect for 1000s of profile pictures

If you exceed limits, you can:
1. Pay Cloudinary (~$9/month for more storage)
2. Upgrade Firebase to Blaze plan
3. Delete old profile pictures

---

## Troubleshooting

**"Upload failed" error:**
- Check Cloud Name is correct
- Check Upload Preset name is correct
- Make sure "Signing Mode" is "Unsigned"

**"Image not displaying" after upload:**
- Wait a few seconds - CDN propagation takes time
- Try restarting the app
- Check internet connection

---

Done! Your profile pictures now upload to **Cloudinary for free**! 🎉
