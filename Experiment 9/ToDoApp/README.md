# 📋 React Native To-Do App (Expo + SQLite)

A simple **To-Do list app** built with **React Native** and **Expo**, using **SQLite** for offline data storage.  
It allows users to **add**, **edit**, **delete**, and **mark tasks as completed**, all stored locally for persistence.

---

## 🚀 Features

- ✅ Add new tasks  
- ✏️ Edit existing tasks  
- ❌ Delete tasks  
- ☑️ Tap to mark tasks as complete/incomplete  
- 💾 Offline storage using SQLite  
- 🎨 Clean, minimal user interface  

---

## 🧠 Tech Stack

- **React Native (Expo)**
- **Expo SQLite** (`expo-sqlite`)
- **TypeScript**
- **React Hooks**
- **Local Database (SQLite)**

---

## 🧱 Database Structure

| Column     | Type     | Description                     |
|-------------|----------|----------------------------------|
| `id`        | INTEGER  | Primary Key (Auto Increment)     |
| `title`     | TEXT     | Task description text            |
| `completed` | INTEGER  | 0 = Incomplete, 1 = Completed    |

---
