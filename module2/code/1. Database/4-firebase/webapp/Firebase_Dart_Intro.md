---
marp: true
theme: default
class: lead
paginate: true
---

# 🔥 Firebase + Dart: Quick Start Guide

Learn how to:
- Create a Firebase project
- Add authentication and Firestore
- Write a basic Dart app for login/register

---

## 🧭 Step 1: Create Firebase Project

1. Go to 👉 [https://console.firebase.google.com](https://console.firebase.google.com)
2. Click **Add Project**
3. Enter a name (e.g., `my-firebase-app`)
4. Follow the steps to create the project
5. Add a **Web App** → get `firebaseConfig`

---

## 🔑 Step 2: Enable Authentication

1. In the Firebase Console:
2. Go to **Build → Authentication**
3. Click **Get Started**
4. Enable **Email/Password** sign-in method

---

## 🗃 Step 3: Create Firestore Collection

1. Go to **Build → Firestore Database**
2. Click **Create database** (start in test mode)
3. Create a collection:
   - Name: `users`
   - Add document with fields: `email`, `createdAt`

---

## 🧪 Step 4: Add SDKs

Include Firebase in your Dart (web) project:

```html
<!-- index.html -->
<script src="https://www.gstatic.com/firebasejs/10.3.0/firebase-app.js"></script>
<script src="https://www.gstatic.com/firebasejs/10.3.0/firebase-auth.js"></script>
<script src="https://www.gstatic.com/firebasejs/10.3.0/firebase-firestore.js"></script>
```

---

## ⚙️ Step 5: Init Firebase

```js
const firebaseConfig = {
  apiKey: "...",
  authDomain: "...",
  projectId: "...",
};

firebase.initializeApp(firebaseConfig);
const auth = firebase.auth();
const db = firebase.firestore();
```

---

## 🧑‍💻 Step 6: Register & Login (JS Example)

```js
// Register
auth.createUserWithEmailAndPassword(email, password)
  .then(user => console.log(user))
  .catch(err => console.error(err));

// Login
auth.signInWithEmailAndPassword(email, password)
  .then(user => console.log(user))
  .catch(err => console.error(err));
```

---

## 🚀 Optional: Dart (package:firebase)

1. Use Flutter or `dart:html` with JS interop
2. Or try [firebase_dart](https://pub.dev/packages/firebase_dart)

```yaml
# pubspec.yaml
dependencies:
  firebase_dart: ^1.0.0
```

```dart
import 'package:firebase_dart/firebase_dart.dart';

final app = await Firebase.initializeApp(options: FirebaseOptions(...));
final auth = FirebaseAuth.instanceFor(app: app);
await auth.signInWithEmailAndPassword("email", "password");
```

---

## 📚 Summary

| Feature         | Where to Set Up     |
|----------------|----------------------|
| Project         | Firebase Console     |
| Auth            | Enable Email/Password |
| Firestore       | Create `users` collection |
| Dart Program    | Use `firebase_dart`  |

Let me know if you want a full Flutter version! ✅
