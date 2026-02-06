# 📚 GutenBooks

A SwiftUI iOS app built as a **Coding Challenge** to demonstrate clean architecture, async programming, and testable business logic.

The app displays a list of books fetched from the public **Gutendex API**, allows users to mark favorites, and explore book details in a simple and intuitive UI.

---

## 🛠 Tech Stack
- **SwiftUI**
- **Swift Concurrency (async/await)**
- **MVVM architecture**
- **URLSession**
- **Unit & UI Tests**
- **iOS 26+**
- Supports **Portrait & Landscape** orientations

---

## ✨ Features
- 📖 Browse a paginated list of books
- 🔍 Book details screen with extended information
- ❤️ Add / remove books from Favorites (session-based)
- ⭐ Mark books as *Read / Unread*
- 📂 Dedicated Favorites tab
- 🔀 Sorting options on Favorites screen
- 📄 Cover image loading
- 🔄 Retry handling on network errors

---

## 🧠 Architecture
- Central **BooksStore** as a single source of truth
- SwiftUI views observe shared state
- ViewModels is introduced to handle additional presentation logic
- Clear separation of concerns with testable business logic
- Designed with **SOLID principles** in mind

---

## 🧪 Testing
- ✅ **Unit tests** for core business logic (`BooksStore`)
- ✅ **UI tests** covering main user flows (favoriting / unfavoriting)

---

## 🌐 API
Data is fetched from the public **Gutendex API**  

---

## 📌 Notes
- Favorites are **session-based** (no persistence by design)
- UI is intentionally simple and clean to focus on code quality

---

👨‍💻 Author: *Viktor Zavhorodnii*
