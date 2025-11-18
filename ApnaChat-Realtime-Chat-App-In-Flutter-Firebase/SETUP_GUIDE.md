# Setup Guide for Calculator Chat App

## Overview
This app has been transformed from a standard chat app into a calculator-disguised secure messaging app with PIN protection and friend request system.

## Key Changes

### 1. Calculator Disguise
- **Entry Point**: App now opens with a fully functional calculator screen
- **Secret Access**: Tap the black settings icon (top right) **5 times quickly** to access the PIN entry screen
- **Theme**: Black calculator theme with orange accents

### 2. PIN Authentication
- **First Launch**: Users will be prompted to set a 4-digit PIN
- **Subsequent Launches**: Users must enter their PIN to access the chat
- **Storage**: PIN is stored locally using SharedPreferences
- **Reset**: To reset PIN, users need to clear app data

### 3. Friend Request System
- **Send Request**: When adding a user by email, a friend request is sent instead of auto-adding
- **Notification**: Bell icon in home screen shows pending friend request count
- **Accept/Reject**: Recipients can accept or reject requests from the Friend Requests screen
- **Push Notifications**: Both parties receive notifications for requests and acceptances

### 4. App Branding
- **App Name**: Changed to "Calculator" on both Android and iOS
- **Splash Screen**: Shows calculator-themed splash screen
- **Home Title**: Changed from "We Chat" to "Secure Chat"

## Firebase Backend Configuration

### Required Firestore Collections

#### 1. Existing Collections (already configured)
- `users` - User profiles
- `chats` - Chat messages
- Each user has a `my_users` subcollection for contacts

#### 2. New Collection (needs to be created)
- **Collection Name**: `friend_requests`
- **Document Structure**:
```
{
  "id": "string",              // Unique request ID
  "from_id": "string",         // Sender's user ID
  "to_id": "string",           // Recipient's user ID
  "from_name": "string",       // Sender's name
  "from_email": "string",      // Sender's email
  "from_image": "string",      // Sender's profile image URL
  "status": "string",          // "pending", "accepted", or "rejected"
  "created_at": "string"       // Timestamp in milliseconds
}
```

### Firestore Indexes Required

Create composite indexes for the `friend_requests` collection:

1. **Index 1**: For fetching pending requests
   - Collection: `friend_requests`
   - Fields:
     - `to_id` (Ascending)
     - `status` (Ascending)
     - `created_at` (Descending)

To create this index:
1. Go to Firebase Console > Firestore Database > Indexes
2. Click "Create Index"
3. Add the fields as specified above
4. Click "Create"

Alternatively, when you first run the app and try to fetch friend requests, Firestore will show an error with a direct link to create the required index.

### Firestore Security Rules

Update your Firestore security rules to include friend requests:

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
    
    // Friend requests collection
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

## How to Use

### For End Users

1. **First Time Setup**:
   - Open the app (shows Calculator)
   - Tap the black settings icon 5 times quickly
   - Set your 4-digit PIN
   - Sign in with Google
   - Start chatting!

2. **Daily Use**:
   - App opens to calculator (use it normally)
   - Access chat: Tap settings icon 5 times → Enter PIN
   - Back to calculator: Use back button from home screen

3. **Adding Friends**:
   - In chat home, tap the "Add User" icon (person with +)
   - Enter friend's email
   - They receive a friend request notification
   - Once accepted, you can start chatting

4. **Managing Friend Requests**:
   - Bell icon shows pending request count (red badge)
   - Tap bell to see all pending requests
   - Accept or reject as needed

### For Developers

#### Testing Friend Requests
1. Create two test accounts
2. From Account A, add Account B's email
3. Account B should see notification in bell icon
4. Account B accepts/rejects the request
5. If accepted, both can now chat

#### Customization Options
- **PIN Length**: Modify `lib/screens/pin_entry_screen.dart` (line 68, change `_pin.length < 4`)
- **Secret Tap Count**: Modify `lib/screens/calculator_screen.dart` (line 79, change `_secretTapCount >= 5`)
- **Calculator Theme**: Modify colors in `lib/screens/calculator_screen.dart`
- **App Icon**: Replace files in `android/app/src/main/res/mipmap-*` folders and `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

## Push Notifications Configuration

### Current Setup
Push notifications are already configured in the original project using:
- Firebase Cloud Messaging (FCM)
- Bearer token authentication via `googleapis_auth`

### Important Note
The Firebase project ID is currently set to `we-chat-75f13` in `lib/api/apis.dart` line 80.

**You MUST update this** if using a different Firebase project:
```dart
const projectID = 'your-project-id-here';
```

### Notification Features
- Friend request sent/received
- Friend request accepted
- New messages
- All notifications work in foreground and background

## Building the App

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## Important Notes

1. **Firebase Project**: Make sure to update the Firebase configuration files if using your own project:
   - `android/app/google-services.json`
   - `ios/Runner/GoogleService-Info.plist`
   - `lib/firebase_options.dart`

2. **App Icon**: The current icon is not calculator-themed. You can:
   - Use an online tool like [AppIcon.co](https://www.appicon.co/) to generate calculator icons
   - Replace icon files in the respective platform folders
   - Use `flutter_launcher_icons` package (already commented in pubspec.yaml)

3. **PIN Security**: 
   - PINs are stored locally using SharedPreferences
   - For enhanced security, consider encrypting the stored PIN
   - Users can reset by clearing app data

4. **Firestore Indexes**: 
   - The app will prompt to create indexes on first run
   - Follow the provided link or manually create as specified above

## Troubleshooting

### Issue: "Index not found" error
**Solution**: Create the Firestore composite index as specified in the Firebase Backend Configuration section

### Issue: Friend requests not showing
**Solution**: 
1. Check Firestore security rules
2. Verify the index was created successfully
3. Check Firebase Console > Firestore > friend_requests collection exists

### Issue: Notifications not working
**Solution**:
1. Verify Firebase project ID in `lib/api/apis.dart`
2. Ensure service account credentials are correct
3. Check Firebase Console > Cloud Messaging settings

### Issue: Can't access chat from calculator
**Solution**: Tap the black settings icon (top right) 5 times quickly within 2 seconds

## Support
For any issues or questions, refer to the Firebase documentation or Flutter documentation.

