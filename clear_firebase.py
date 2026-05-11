#!/usr/bin/env python3
"""
Script to clear all Firestore data and Firebase Storage files.
This removes all users, reviews, likes, communities, messages, and profile pictures.

Requirements:
- Install firebase-admin: pip install firebase-admin
- Download your Firebase service account JSON file from Firebase Console
  (Project Settings -> Service Accounts -> Generate New Private Key)
"""

import firebase_admin
from firebase_admin import credentials, firestore, storage
import os
import sys

# Path to your Firebase service account JSON file
# Download from: Firebase Console -> Project Settings -> Service Accounts -> Generate Private Key
SERVICE_ACCOUNT_KEY = 'path/to/your/serviceAccountKey.json'  # REPLACE THIS

def clear_firestore(db):
    """Delete all documents from Firestore"""
    print("🔄 Clearing Firestore database...")
    
    collections = [
        'users',
        'reviews',
        'likes',
        'comments',
        'follows',
        'communities',
        'collections',
        'favorites',
        'watchlist',
        'notifications',
    ]
    
    for collection_name in collections:
        print(f"  ⏳ Clearing '{collection_name}' collection...")
        collection_ref = db.collection(collection_name)
        docs = collection_ref.stream()
        
        deleted_count = 0
        for doc in docs:
            doc.reference.delete()
            deleted_count += 1
        
        print(f"    ✅ Deleted {deleted_count} documents from '{collection_name}'")
    
    print("✅ Firestore database cleared!\n")

def clear_subcollections(db):
    """Delete all subcollections (like notifications under users, messages under communities, etc)"""
    print("🔄 Clearing subcollections...")
    
    # Delete all notifications under each user
    users = db.collection('users').stream()
    for user_doc in users:
        notifications = user_doc.reference.collection('notifications').stream()
        for notif_doc in notifications:
            notif_doc.reference.delete()
        print(f"  ✅ Cleared notifications for user {user_doc.id}")
    
    # Delete all messages under each community
    communities = db.collection('communities').stream()
    for community_doc in communities:
        messages = community_doc.reference.collection('messages').stream()
        for msg_doc in messages:
            msg_doc.reference.delete()
        print(f"  ✅ Cleared messages for community {community_doc.id}")
    
    print("✅ Subcollections cleared!\n")

def clear_storage(bucket):
    """Delete all files from Firebase Storage"""
    print("🔄 Clearing Firebase Storage...")
    
    blobs = bucket.list_blobs()
    deleted_count = 0
    
    for blob in blobs:
        blob.delete()
        deleted_count += 1
        print(f"  🗑️  Deleted: {blob.name}")
    
    print(f"✅ Deleted {deleted_count} files from Storage!\n")

def main():
    # Check if service account key exists
    if not os.path.exists(SERVICE_ACCOUNT_KEY):
        print(f"❌ ERROR: Service account key not found at: {SERVICE_ACCOUNT_KEY}")
        print("\nTo use this script:")
        print("1. Go to Firebase Console -> Your Project")
        print("2. Click Settings ⚙️ -> Project Settings")
        print("3. Go to 'Service Accounts' tab")
        print("4. Click 'Generate New Private Key'")
        print("5. Save it and update SERVICE_ACCOUNT_KEY path in this script")
        sys.exit(1)
    
    # Initialize Firebase
    try:
        cred = credentials.Certificate(SERVICE_ACCOUNT_KEY)
        firebase_admin.initialize_app(cred, {
            'storageBucket': 'your-project.appspot.com'  # REPLACE WITH YOUR BUCKET NAME
        })
        print("✅ Firebase initialized successfully!\n")
    except Exception as e:
        print(f"❌ ERROR initializing Firebase: {e}")
        sys.exit(1)
    
    # Get database and storage references
    db = firestore.client()
    bucket = storage.bucket()
    
    # Confirm before clearing
    print("⚠️  WARNING: This will DELETE ALL data from Firestore and Storage!")
    print("This action cannot be undone.\n")
    
    confirm = input("Type 'YES' to confirm deletion: ")
    if confirm != 'YES':
        print("❌ Operation cancelled.")
        sys.exit(0)
    
    print("\n🚀 Starting cleanup...\n")
    
    try:
        # Clear all data
        clear_firestore(db)
        clear_subcollections(db)
        clear_storage(bucket)
        
        print("=" * 50)
        print("✅ ALL DATA CLEARED SUCCESSFULLY!")
        print("=" * 50)
        print("\nYour Firebase project is now clean and ready for testing!")
        
    except Exception as e:
        print(f"❌ ERROR during cleanup: {e}")
        sys.exit(1)
    finally:
        firebase_admin.delete_app(firebase_admin.get_app())

if __name__ == '__main__':
    main()
