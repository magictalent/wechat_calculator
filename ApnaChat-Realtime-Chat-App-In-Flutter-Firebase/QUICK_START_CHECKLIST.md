# 🚀 Quick Start Checklist

## Before You Start
- [ ] Have a Google account
- [ ] Have Flutter installed and working
- [ ] Have Android Studio / Xcode installed

---

## 📋 Step-by-Step Checklist

### Firebase Setup (30 minutes)

- [ ] **Create Firebase Project** at https://console.firebase.google.com/
  - Project name: (e.g., "calculator-chat")
  
- [ ] **Enable Google Authentication**
  - Firebase Console → Authentication → Get Started
  - Sign-in method → Google → Enable
  
- [ ] **Create Firestore Database**
  - Firebase Console → Firestore Database → Create database
  - Production mode → Choose location
  
- [ ] **Add Firestore Security Rules**
  - Copy rules from `FIREBASE_MIGRATION_GUIDE.md`
  - Paste in Rules tab → Publish
  
- [ ] **Create Firestore Index**
  - Firestore → Indexes → Create Index
  - Collection: `friend_requests`
  - Fields: `to_id` (Ascending), `status` (Ascending), `created_at` (Descending)
  
- [ ] **Enable Firebase Storage**
  - Firebase Console → Storage → Get Started
  - Update rules from guide → Publish
  
- [ ] **Enable Cloud Messaging**
  - Project Settings → Cloud Messaging (verify it's there)

### App Configuration (15 minutes)

- [ ] **Register Android App**
  - Add app → Android
  - Package name: `com.harshRajpurohit.we_chat`
  - Download `google-services.json`
  - Replace file in `android/app/google-services.json`
  
- [ ] **Register iOS App** (if needed)
  - Add app → iOS
  - Download `GoogleService-Info.plist`
  - Replace file in `ios/Runner/GoogleService-Info.plist`
  
- [ ] **Generate Service Account Key**
  - Project Settings → Service Accounts
  - Generate New Private Key → Download JSON
  
- [ ] **Update notification_access_token.dart**
  - Open `lib/api/notification_access_token.dart`
  - Replace lines 24-38 with your downloaded JSON
  
- [ ] **Update Project ID**
  - Open `lib/api/apis.dart`
  - Line 80: Change `'we-chat-75f13'` to `'your-project-id'`
  
- [ ] **Run FlutterFire Configure**
  ```bash
  flutterfire configure
  ```

### Build & Test (10 minutes)

- [ ] **Clean and Build**
  ```bash
  flutter clean
  flutter pub get
  flutter run
  ```
  
- [ ] **Test Calculator**
  - App opens to calculator
  - Calculator works (try: 5 + 3 = 8)
  
- [ ] **Test Secret Access**
  - Tap settings icon (top right) 5 times quickly
  - PIN screen appears
  
- [ ] **Test PIN Setup**
  - Enter 4-digit PIN (e.g., 1234)
  - Confirm PIN
  
- [ ] **Test Google Sign-In**
  - Sign in with Google account
  - Should reach home screen
  
- [ ] **Test Friend Request (Need 2 Accounts)**
  - Account A: Add Account B's email
  - Account B: Check bell icon (should show badge)
  - Account B: Accept request
  - Both: Can now chat

---

## 🎯 What Should Work After Setup

✅ App appears as "Calculator" in app drawer  
✅ Opens to calculator screen  
✅ Secret access (tap settings 5 times)  
✅ PIN authentication  
✅ Google sign-in  
✅ Friend requests with notifications  
✅ Chat messaging  
✅ Image sharing  
✅ Push notifications  

---

## ⏱️ Time Estimate

- Firebase Setup: **30 minutes**
- App Configuration: **15 minutes**
- Testing: **10 minutes**
- **Total: ~1 hour**

---

## 🆘 Common Issues & Quick Fixes

### "User does not exist" when adding friend
**Fix**: Friend must sign in at least once to create their account

### Push notifications not working
**Fix**: 
1. Verify service account JSON is correct
2. Verify project ID matches your Firebase project
3. Test on real device (not emulator)

### "Index not found" error
**Fix**: 
1. Click the link in error message, or
2. Manually create index in Firebase Console → Firestore → Indexes

### App crashes on launch
**Fix**: 
1. Check `google-services.json` is correct
2. Run `flutter clean` and `flutter pub get`
3. Rebuild app

---

## 📱 Ready for Production?

### Before Publishing:

- [ ] Replace app icon with calculator-themed icon
- [ ] Test with at least 2 real users
- [ ] Test all features on real devices
- [ ] Verify push notifications work
- [ ] Update app version in `pubspec.yaml`

### Build Commands:

**Android APK:**
```bash
flutter build apk --release
```

**Android App Bundle (for Play Store):**
```bash
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
```

---

## 📚 Need More Details?

- **Technical Setup**: See `FIREBASE_MIGRATION_GUIDE.md`
- **Feature Overview**: See `CLIENT_SUMMARY.md`
- **Complete Guide**: See `SETUP_GUIDE.md`

---

## ✨ You're All Set!

Once all checkboxes are checked, your calculator-disguised chat app is ready to use! 🎉

