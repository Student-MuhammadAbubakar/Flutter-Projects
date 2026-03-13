# 📱 Reading Tracker (Flutter Frontend)

This Flutter app is the frontend for the **Reading Tracker** project. It consumes a **FastAPI** backend (running separately) to manage books and track reading progress.

---

## 🚀 What this app does

- Displays a list of books with progress and status.
- Lets you add a new book (title, author, total pages, starting pages read).
- Updates a book’s progress (pages read + status: unread / in-progress / completed).
- Searches books by title.
- Shows analytics (total books, reading, completed, unread).

---

## 🧱 Project Structure

```
reading_frontend/
├── lib/
│   ├── models/          # Data models (Book, Analytics)
│   ├── providers/       # State management via Provider
│   ├── screens/         # UI screens (home, details, add/edit, search, analytics)
│   └── services/        # API client (HTTP calls to backend)
├── pubspec.yaml         # Dependencies + metadata
└── README.md            # (this file)
```

---

## 🛠️ Setup & Run

### Prerequisites

- Flutter SDK (stable)
- A connected device or emulator (Android/iOS/desktop)

### Install dependencies

```bash
cd reading_frontend
flutter pub get
```

### Run on emulator/device

```bash
flutter run
```

---

## 🔌 Backend Configuration (Important)

The frontend expects the backend API to be available at **`http://10.0.2.2:8000`** by default (Android emulator loopback).

If you are running the backend on a real device or on a different host, update the base URL in:

- `lib/services/api_services.dart` → `static const String baseUrl`

Example for a local network IP:

```dart
static const String baseUrl = 'http://192.168.1.10:8000';
```

---

## 🧩 API Endpoints Used

The frontend uses these backend routes:

- `GET /books` – List all books
- `POST /books` – Create a book
- `PATCH /books/{id}` – Update a book
- `DELETE /books/{id}` – Delete a book
- `GET /search?title=` – Search by title
- `GET /analytics` – Reading stats

---

## 📌 Notes

- The app uses `provider` for state management and `http` for API calls.
- The UI expects the backend response shape to match the models in `lib/models/`.
- If you change backend model fields, update the frontend models and serialization accordingly.

---

## 🧪 Testing

No automated tests are included yet. To validate behavior:

- Run the backend and ensure the API is reachable.
- Run the app and verify add/edit/search functionality.

---

## 🛠️ Extending this App

Suggestions:

- Add offline persistence (e.g., Hive, SQLite) so the app works without a running backend.
- Add authentication/login.
- Improve error handling and loading states.
- Use Riverpod or Bloc for more scalable state management.
