# 🧮 Flutter Calculator App with SQLite History

A simple and elegant calculator app built using **Flutter**, featuring basic arithmetic operations and a persistent **calculation history** using **SQLite**.  
The app also includes a smooth **bottom sheet popup** to view and clear history records.

---

## 🚀 Features

- Perform basic arithmetic operations: `+`, `-`, `×`, `÷`, `%`
- Clear display and reset calculations with `AC`
- Toggle sign using `+/-`
- Persistent **calculation history** using SQLite
- View history in a **bottom sheet popup**
- **Clear all history** with one tap
- Beautiful and responsive UI inspired by iOS-style calculators

---

## 🧱 Tech Stack

| Component | Description |
|------------|--------------|
| **Framework** | Flutter |
| **Database** | SQLite (via `sqflite` package) |
| **Math Parsing** | `math_expressions` package |
| **Path Handling** | `path` package |

---

## 📦 Dependencies

Add these dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  sqflite: ^2.3.0
  path: ^1.9.0
  math_expressions: ^2.4.0
