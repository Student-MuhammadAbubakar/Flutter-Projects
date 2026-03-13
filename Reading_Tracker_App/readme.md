# 📚 Reading Tracker App

A cross-platform **Flutter** app with a **FastAPI + SQLite** backend to track your reading progress. Add books, update progress, search titles, and view analytics.

---

## 🔎 What is this?

This project includes two parts:

- **Backend (API)**: A FastAPI service that stores books in an SQLite database and exposes REST endpoints.
- **Frontend (Mobile/Desktop App)**: A Flutter application that consumes the API to display, add, update, search books, and show reading analytics.

---

## ✅ Key Features

- Add books with title, author, total pages, and current progress.
- Update progress (pages read + status: unread / in-progress / completed).
- Search for a book by title.
- View analytics (total books, currently reading, completed, unread).
- Works locally with a simple SQLite database.

---

## 🧱 Technology Stack

- **Frontend:** Flutter (Dart) using `http` + `provider`
- **Backend:** FastAPI (Python) + SQLite
- **Data Model:** Books stored in `backend/database.db`

---

## 🛠️ Project Structure

```
Reading_Tracker_App/
├── backend/                   # FastAPI backend
│   ├── app/
│   │   ├── database.py        # SQLite data access layer
│   │   ├── main.py            # FastAPI app + routes
│   │   └── schema.py          # Pydantic request models
│   └── database.db            # SQLite database file
└── reading_frontend/          # Flutter app
    ├── lib/
    │   ├── models/            # Book + Analytics models
    │   ├── providers/         # State management (Provider)
    │   ├── screens/           # UI screens
    │   └── services/          # API client (http)
    └── pubspec.yaml
```

---

## 🚀 Getting Started (Full Stack)

### 1) Backend (FastAPI)

#### Prerequisites

- Python 3.10+ (ensure `python` points to a supported version)

#### Setup

```bash
cd backend
python -m venv .venv
# Windows
.venv\Scripts\activate
# macOS/Linux
# source .venv/bin/activate

pip install fastapi uvicorn pydantic
```

#### Run the API server

```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

The API will be available at: `http://localhost:8000`

> ✅ The API will create `backend/database.db` automatically on first run.

---

### 2) Frontend (Flutter)

#### Prerequisites

- Flutter SDK (stable channel)
- A connected device or emulator (Android/iOS/desktop)

#### Setup

```bash
cd reading_frontend
flutter pub get
```

#### Run the app

```bash
flutter run
```

> 💡 **Android emulator NOTE:** The backend is expected to run at `http://10.0.2.2:8000` (this is the Android emulator host loopback address). If you run the app on a physical device or other platform, update `lib/services/api_services.dart` and set `baseUrl` to your machine IP (e.g. `http://192.168.x.y:8000`).

---

## 🧩 API Endpoints

| Method | Path | Description |
| ------ | ---- | ----------- |
| GET | `/books` | Get all books |
| POST | `/books` | Create a new book |
| PATCH | `/books/{id}` | Update pages/status for a book |
| DELETE | `/books/{id}` | Delete a book (used by frontend) |
| GET | `/search?title=...` | Find a book by title |
| GET | `/analytics` | Get reading stats |

---

## 📝 Notes / Tips

- The backend uses a local SQLite file (`backend/database.db`). Delete it to reset data.
- If you change API routes, update `reading_frontend/lib/services/api_services.dart` accordingly.
- When running the frontend on a physical device, use your host machine’s LAN IP instead of `10.0.2.2`.

---

## 🧪 Testing

This repo does not include automated tests yet, but you can manually verify:

- Backend: Use `curl` or tools like Postman to hit the endpoints.
- Flutter: Run the app and verify adding/updating/searching books and viewing analytics.

---

## 📦 Deployment Ideas

- **Backend:** Deploy to a cloud provider (Heroku, Fly.io, Railway) and switch `baseUrl` in the Flutter app.
- **Frontend:** Build with `flutter build apk` / `flutter build ios` or deploy as a desktop/web app.

---

## 🤝 Contributing

Contributions are welcome! Feel free to open issues or PRs for:

- Better error handling
- Offline persistence in the Flutter app
- Adding authentication
- Adding search by author

---

## 📜 License

This project is provided as-is. Add a license file if you want to share it publicly.
