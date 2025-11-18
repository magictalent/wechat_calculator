# 📝 Files You MUST Update for Your Firebase Account

## 🔴 CRITICAL - Must Change These 5 Files

### 1. `android/app/google-services.json`
**What**: Android Firebase configuration  
**How**: Download from Firebase Console (Android app setup)  
**Action**: Replace entire file  
**Status**: ⚠️ REQUIRED

---

### 2. `ios/Runner/GoogleService-Info.plist`
**What**: iOS Firebase configuration  
**How**: Download from Firebase Console (iOS app setup)  
**Action**: Replace entire file  
**Status**: ⚠️ REQUIRED (if building for iOS)

---

### 3. `lib/firebase_options.dart`
**What**: Flutter Firebase configuration  
**How**: Run `flutterfire configure` command  
**Action**: File will be auto-generated  
**Status**: ⚠️ REQUIRED

---

### 4. `lib/api/notification_access_token.dart`
**What**: Service account credentials for push notifications  
**How**: Download JSON from Firebase → Project Settings → Service Accounts  
**Action**: Replace lines 24-38 with your JSON  

**Current code (CHANGE THIS):**
```dart
ServiceAccountCredentials.fromJson({
  "type": "service_account",
  "project_id": "we-chat-75f13",  // ← YOUR PROJECT ID
  "private_key_id": "...",         // ← YOUR VALUES
  "private_key": "-----BEGIN PRIVATE KEY-----\n...",
  // ... rest of JSON
}),
```

**Status**: ⚠️ REQUIRED for push notifications

---

### 5. `lib/api/apis.dart` (Line 80)
**What**: Firebase project ID for FCM  
**How**: Copy from Firebase Console → Project Settings  
**Action**: Change one line  

**Current code:**
```dart
const projectID = 'we-chat-75f13';
```

**Change to:**
```dart
const projectID = 'your-actual-project-id';
```

**Status**: ⚠️ REQUIRED for push notifications

---

## 🟡 OPTIONAL - App Icon Changes

### If you want calculator-themed icons:

**Android Icons** (replace these):
```
android/app/src/main/res/
  ├── mipmap-hdpi/ic_launcher.png (72x72)
  ├── mipmap-mdpi/ic_launcher.png (48x48)
  ├── mipmap-xhdpi/ic_launcher.png (96x96)
  ├── mipmap-xxhdpi/ic_launcher.png (144x144)
  └── mipmap-xxxhdpi/ic_launcher.png (192x192)
```

**iOS Icons** (replace these):
```
ios/Runner/Assets.xcassets/AppIcon.appiconset/
  └── (multiple PNG files in various sizes)
```

**Status**: 🟡 OPTIONAL but recommended

---

## 🟢 ALREADY DONE - No Action Needed

These files have already been updated:

✅ `lib/main.dart` - App name changed to "Calculator"  
✅ `lib/screens/calculator_screen.dart` - Calculator UI created  
✅ `lib/screens/pin_entry_screen.dart` - PIN authentication  
✅ `lib/screens/splash_screen.dart` - Calculator-themed splash  
✅ `lib/screens/home_screen.dart` - Friend request bell icon  
✅ `lib/screens/friend_requests_screen.dart` - Friend request UI  
✅ `lib/api/apis.dart` - Friend request API methods  
✅ `lib/models/friend_request.dart` - Friend request model  
✅ `pubspec.yaml` - Dependencies added  
✅ `android/app/src/main/AndroidManifest.xml` - App name "Calculator"  
✅ `ios/Runner/Info.plist` - App name "Calculator"  

---

## 📊 Quick Summary

| Priority | Files to Change | Time Required |
|----------|----------------|---------------|
| 🔴 Critical | 5 files | 20 minutes |
| 🟡 Optional | Icon files | 10 minutes |
| 🟢 Done | 11+ files | ✓ Complete |

---

## ⚡ Quick Commands

### 1. Install FlutterFire CLI (if not installed)
```bash
dart pub global activate flutterfire_cli
```

### 2. Configure Firebase
```bash
flutterfire configure
```

### 3. Clean and Build
```bash
flutter clean
flutter pub get
flutter run
```

---

## 🎯 Verification Checklist

After updating files, verify:

- [ ] `android/app/google-services.json` exists and has your project name
- [ ] `lib/firebase_options.dart` has correct projectId
- [ ] `lib/api/apis.dart` line 80 has your project ID
- [ ] `lib/api/notification_access_token.dart` has your service account JSON
- [ ] App builds without errors: `flutter run`
- [ ] Can sign in with Google
- [ ] Can send/receive friend requests
- [ ] Push notifications work

---

## 🆘 Still Confused?

**See detailed guides:**
1. `QUICK_START_CHECKLIST.md` - Step-by-step with checkboxes
2. `FIREBASE_MIGRATION_GUIDE.md` - Complete technical guide
3. `CLIENT_SUMMARY.md` - Feature overview
4. `SETUP_GUIDE.md` - Original setup documentation

**Need help with a specific file?**
- Read the comments in each file
- Each critical file has warnings and instructions
- Follow the guides in order listed above

