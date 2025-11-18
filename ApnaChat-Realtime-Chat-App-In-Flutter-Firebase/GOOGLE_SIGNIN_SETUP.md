# Google Sign-In Setup Guide

## The Problem
Google Sign-In requires SHA-1 certificate fingerprints to be registered in Firebase Console.

## Solution: Add SHA-1 Certificate to Firebase

### Step 1: Get Your SHA-1 Fingerprint

**On Windows (PowerShell):**
```powershell
keytool -list -v -keystore "$env:USERPROFILE\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```

**On Windows (CMD):**
```cmd
keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```

**On Mac/Linux:**
```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

Look for lines like:
```
SHA1: AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD
SHA256: 11:22:33:44:55:66:77:88:99:AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD:EE:FF:00
```

Copy both SHA-1 and SHA-256 values.

---

### Step 2: Add SHA Certificates to Firebase

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select project: **we-chat-75f13**
3. Click on **Settings** (⚙️ gear icon) → **Project settings**
4. Scroll down to **Your apps** section
5. Find your Android app: `com.harshRajpurohit.we_chat`
6. Click **Add fingerprint** button
7. Paste your **SHA-1** fingerprint and click **Save**
8. Click **Add fingerprint** again
9. Paste your **SHA-256** fingerprint and click **Save**

---

### Step 3: Download New google-services.json (IMPORTANT!)

1. After adding fingerprints, click **Download google-services.json**
2. Replace the file at: `android/app/google-services.json`
3. Run in terminal:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

---

## Alternative: Use Gradle to Get SHA-1

```bash
cd android
./gradlew signingReport
```

Look for the **SHA1** under **Variant: debug** → **Config: debug**

---

## Common Errors:

### Error: "API: YOUR_API_KEY is not enabled for your project"
- Add SHA-1 and SHA-256 to Firebase Console

### Error: "DEVELOPER_ERROR" or "Error code 10"
- SHA-1 certificate not registered in Firebase
- Wrong package name in Firebase

### Error: "Sign-in cancelled"
- User closed the Google Sign-In dialog
- This is normal behavior if cancelled

---

## Quick Test:
After adding SHA certificates:
1. **Uninstall** the app completely: `adb uninstall com.harshRajpurohit.we_chat`
2. **Clean** the project: `flutter clean`
3. **Rebuild** and run: `flutter run`
4. Try Google Sign-In again

---

## Need Help?
Check the terminal/logcat output for detailed error messages after clicking "Login with Google"

