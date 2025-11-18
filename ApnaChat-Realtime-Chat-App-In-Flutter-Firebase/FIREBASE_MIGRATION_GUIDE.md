# Firebase Backend Migration Guide

## 🎯 How to Change to Your Own Firebase Account

Follow these steps to migrate from the original Firebase project to your own.

---

## Step 1: Create New Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **"Add Project"** or **"Create a project"**
3. Enter project name (e.g., "calculator-chat")
4. Enable/disable Google Analytics (your choice)
5. Click **"Create Project"**

---

## Step 2: Enable Authentication

1. In Firebase Console, go to **Authentication**
2. Click **"Get Started"**
3. Go to **"Sign-in method"** tab
4. Enable **Google** sign-in provider
5. Add your support email
6. Save

---

## Step 3: Create Firestore Database

1. In Firebase Console, go to **Firestore Database**
2. Click **"Create database"**
3. Choose **"Start in production mode"** (we'll add rules later)
4. Select a location (closest to your users)
5. Click **"Enable"**

### Create Security Rules

Click on **"Rules"** tab and paste this:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
      
      match /my_users/{document=**} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
    
    // Friend requests collection (NEW)
    match /friend_requests/{requestId} {
      allow read: if request.auth != null && 
                    (resource.data.from_id == request.auth.uid || 
                     resource.data.to_id == request.auth.uid);
      allow create: if request.auth != null && 
                      request.resource.data.from_id == request.auth.uid;
      allow update: if request.auth != null && 
                      resource.data.to_id == request.auth.uid;
    }
    
    // Chats collection
    match /chats/{chatId}/messages/{messageId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

Click **"Publish"**

### Create Composite Index

1. Go to **Firestore Database** → **Indexes** tab
2. Click **"Create Index"**
3. Collection ID: `friend_requests`
4. Add fields:
   - Field: `to_id` | Order: Ascending
   - Field: `status` | Order: Ascending  
   - Field: `created_at` | Order: Descending
5. Click **"Create"**

---

## Step 4: Enable Firebase Storage

1. Go to **Storage** in Firebase Console
2. Click **"Get Started"**
3. Accept default security rules (for now)
4. Choose same location as Firestore
5. Click **"Done"**

### Update Storage Rules

Click **"Rules"** tab and paste:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

Click **"Publish"**

---

## Step 5: Enable Cloud Messaging (Push Notifications)

1. Go to **Project Settings** (gear icon) → **Cloud Messaging** tab
2. Note your **Server Key** and **Sender ID** (you won't need to copy them, but verify they exist)

---

## Step 6: Register Your Flutter App

### For Android:

1. In Firebase Console, click **"Add app"** → Android icon
2. Enter Android package name: `com.harshRajpurohit.we_chat` (found in `android/app/build.gradle`)
3. Download `google-services.json`
4. **Replace** the file at: `android/app/google-services.json`
5. Click **"Next"** → **"Next"** → **"Continue to console"**

### For iOS (if building for iOS):

1. In Firebase Console, click **"Add app"** → iOS icon
2. Enter iOS bundle ID: (found in Xcode or `ios/Runner.xcodeproj`)
3. Download `GoogleService-Info.plist`
4. **Replace** the file at: `ios/Runner/GoogleService-Info.plist`
5. Click **"Next"** → **"Next"** → **"Continue to console"**

---

## Step 7: Update Firebase Options in Flutter

Run this command in your project root:

```bash
flutterfire configure
```

**If you don't have FlutterFire CLI:**

```bash
# Install it first
dart pub global activate flutterfire_cli

# Then run
flutterfire configure
```

Follow the prompts:
1. Select your Firebase project
2. Select platforms (Android, iOS, Web, etc.)
3. This will update `lib/firebase_options.dart` automatically

---

## Step 8: Generate Service Account Key (for Push Notifications)

This is **CRITICAL** for push notifications to work!

1. Go to **Project Settings** → **Service Accounts** tab
2. Click **"Generate New Private Key"**
3. Click **"Generate Key"** (a JSON file will download)
4. Open the downloaded JSON file in a text editor

### Update notification_access_token.dart

Open `lib/api/notification_access_token.dart` and replace the entire JSON (lines 24-38) with your downloaded JSON:

```dart
ServiceAccountCredentials.fromJson({
  "type": "service_account",
  "project_id": "your-project-id",        // ← Your values here
  "private_key_id": "...",
  "private_key": "-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n",
  "client_email": "...",
  "client_id": "...",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "...",
  "universe_domain": "googleapis.com"
}),
```

---

## Step 9: Update Project ID in APIs.dart

Open `lib/api/apis.dart` and find line 80:

```dart
// Firebase Project > Project Settings > General Tab > Project ID
const projectID = 'we-chat-75f13';  // ← Change this!
```

Replace with YOUR project ID (found in Firebase Console → Project Settings → General tab):

```dart
const projectID = 'your-project-id-here';
```

---

## Step 10: Test Everything

### Clean and Rebuild

```bash
# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Run the app
flutter run
```

### Test Checklist:

- [ ] App opens to calculator splash screen
- [ ] Calculator functions work
- [ ] Can access PIN screen (tap settings 5 times)
- [ ] Can set PIN on first launch
- [ ] Can sign in with Google
- [ ] Can see home screen after login
- [ ] Can send friend request by email
- [ ] Friend receives notification
- [ ] Can accept/reject friend request
- [ ] Can send messages
- [ ] Push notifications work

---

## 🎬 Optional: Video Recording Feature

If you want to add video recording/sending in chat:

### 1. Add Dependencies

Add to `pubspec.yaml`:

```yaml
dependencies:
  image_picker: ^1.1.2  # Already included
  video_player: ^2.8.7
  camera: ^0.11.0
```

### 2. Update Permissions

**Android** (`android/app/src/main/AndroidManifest.xml`):
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
```

**iOS** (`ios/Runner/Info.plist`):
```xml
<key>NSCameraUsageDescription</key>
<string>App requires access to the camera for recording videos.</string>
<key>NSMicrophoneUsageDescription</key>
<string>App requires access to the microphone for recording videos.</string>
```

### 3. Modify Chat Screen

Update `lib/screens/chat_screen.dart` to add video picker option similar to image picker.

**Let me know if you want me to implement the video feature!**

---

## ⚠️ Important Notes

### Security:

1. **Never commit** `google-services.json` or `GoogleService-Info.plist` to public repos
2. **Never commit** the service account JSON in `notification_access_token.dart` to public repos
3. Consider using environment variables for sensitive data in production

### Testing:

1. Test with at least 2 user accounts (to verify friend requests)
2. Test on real device for push notifications (emulator may not work)
3. Ensure internet connection is stable

### Common Issues:

**"User not found" when adding friend:**
- Make sure both users have signed in at least once
- Check Firestore Users collection exists and has data

**Push notifications not working:**
- Verify service account JSON is correct
- Verify project ID matches
- Check Firebase Cloud Messaging is enabled
- Test on real device, not emulator

**Firestore permission denied:**
- Check security rules are published
- Verify user is authenticated

---

## 📱 Building for Production

### Android:

```bash
flutter build apk --release
# or for Play Store:
flutter build appbundle --release
```

### iOS:

```bash
flutter build ios --release
```

---

## ✅ Migration Complete!

After completing all steps, your app will be running on your own Firebase backend with:

- ✅ Calculator disguise
- ✅ PIN protection
- ✅ Google authentication
- ✅ Friend request system
- ✅ Push notifications
- ✅ Secure messaging
- ✅ Image sharing

Your data is now stored in YOUR Firebase project, giving you complete control!

---

## 🆘 Need Help?

If you encounter issues:

1. Check Firebase Console for error logs (Functions logs, Authentication logs)
2. Check Flutter debug console for errors
3. Verify all steps above are completed
4. Check that composite index is created and active (not building)

## 📞 Contact

For Firebase-specific issues, consult:
- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)

