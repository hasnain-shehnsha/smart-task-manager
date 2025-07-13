# 🧠 Smart Task Manager App

A powerful Flutter-based Smart Task Manager app with **Firebase (online)** and **SQLite (offline)** support — built using **Clean Architecture** and **Riverpod** for robust state management.

---

## 🚀 Features

* 🔐 Firebase Authentication (Login/Signup)
* ✅ Add, edit, delete, and complete tasks
* 🔄 Auto Sync: Firebase (cloud) ↔ SQLite (offline)
* 📴 Works seamlessly offline
* ☁️ Syncs automatically when online
* 🔄 sort by completed, pending, upcomming or latest
* 🧠 Built with Clean Architecture + Riverpod

---

## 🧱 Tech Stack

| Layer         | Technology              |
| ------------- | ----------------------- |
| Frontend      | Flutter (Dart)          |
| State Manager | Riverpod                |
| Architecture  | Clean Architecture      |
| Online DB     | Firebase Firestore      |
| Offline DB    | SQLite (sqflite)        |
| Auth          | Firebase Authentication |

---

## 📁 Folder Structure (Clean Architecture)

```
lib/
├── core/             # Constants, themes, error handling
├── data/             # Firebase & SQLite data sources
├── domain/           # Models & repositories
├── application/      # Business logic, use cases, providers
├── presentation/     # UI widgets, pages, screens
└── main.dart         # App entry point
```

---

## 🧪 Requirements

* Flutter 3.x
* Firebase CLI configured
* Internet for sync features
* Android/iOS device or emulator

---

## 🔥 How to Run

```bash
git clone https://github.com/YOUR-USERNAME/Smart-Task-Manager.git
cd Smart-Task-Manager
flutter pub get
flutter run
```

> Replace `YOUR-USERNAME` with your actual GitHub username.

---

## 📸 Screenshots

<img width="407" height="892" alt="Screenshot 2025-07-14 010632" src="https://github.com/user-attachments/assets/0c3fd1c2-4a85-469c-978a-3400e67880e1" />
<img width="399" height="883" alt="Screenshot 2025-07-14 010728" src="https://github.com/user-attachments/assets/e880915b-19fb-4f17-996e-a483556f7523" />
<img width="396" height="889" alt="Screenshot 2025-07-14 010748" src="https://github.com/user-attachments/assets/dfa67e57-b300-45dd-b7af-1272f35212f9" />

---

## 📄 License

MIT License © [hasnain-shehnsha](https://github.com/hasnain-shehnsha)
