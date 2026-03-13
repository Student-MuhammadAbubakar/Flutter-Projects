# 🧠 Reading Tracker API (Backend)

This is the **FastAPI** backend for the Reading Tracker project. It provides a simple REST API backed by **SQLite** and is intended to be consumed by the Flutter frontend.

---

## 📦 What’s Included

- `app/main.py` — FastAPI application & route definitions
- `app/database.py` — SQLite access layer (CRUD + analytics)
- `app/schema.py` — Pydantic models and enums for request validation
- `database.db` — Local SQLite database file (auto-created on first run)

---

## ✅ Features

- List all books
- Create a new book
- Update book progress (pages read + status)
- Delete a book
- Search a book by title
- Get reading analytics (total, reading, completed, unread)

---

## ⚙️ Setup & Run

### Prerequisites

- Python 3.10+

### Install dependencies

```bash
cd backend
python -m venv .venv
# Windows
.venv\Scripts\activate
# macOS/Linux
# source .venv/bin/activate

pip install fastapi uvicorn pydantic
```

### Run the API

```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

The API will be available at: `http://localhost:8000`

> ✅ The `database.db` file will be created automatically in the `backend/` directory when the API starts.

---

## 🧩 API Endpoints

| Method | Path | Description |
| ------ | ---- | ----------- |
| GET | `/books` | Get all books |
| POST | `/books` | Create a new book |
| PATCH | `/books/{id}` | Update pages/status for a book |
| DELETE | `/books/{id}` | Delete a book |
| GET | `/search?title=...` | Find a book by title |
| GET | `/analytics` | Get reading stats |

---

## 🧠 Data Model

Books are stored in a SQLite table named `Books` with the following columns:

- `id` (INTEGER PRIMARY KEY)
- `title` (TEXT)
- `author` (TEXT)
- `Total_pages` (INTEGER)
- `pages_read` (INTEGER)
- `status` (TEXT: one of `in_progress`, `completed`, `un_read`)

---

## 🛠️ Notes

- The backend uses a simple SQLite database for local development. Delete `database.db` to reset data.
- CORS is enabled for all origins (`allow_origins=["*"]`) to simplify frontend development. Lock this down for production.

---

## 🧪 Testing

This repo does not include automated tests yet.

You can test the API manually using `curl`, Postman, or any HTTP client:

```bash
curl http://localhost:8000/books
```

---

## 🚀 Deployment Notes

- Deploy the FastAPI app to any Python-friendly host (e.g., Heroku, Fly.io, Railway, AWS).
- Configure the frontend to point to the deployed backend URL.
