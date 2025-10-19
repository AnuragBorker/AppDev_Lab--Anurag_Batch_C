import * as SQLite from "expo-sqlite/next";

let db;

// Initialize the database
export const initDB = async () => {
    db = await SQLite.openDatabaseAsync("todo.db");

    // noinspection SqlNoDataSourceInspection
    await db.execAsync(`
    CREATE TABLE IF NOT EXISTS tasks (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      text TEXT NOT NULL,
      completed INTEGER
    );
  `);
};

// Fetch all tasks
export const getTasks = async () => {
    const rows = await db.getAllAsync("SELECT * FROM tasks;");
    return rows;
};

// Add a new task
export const addTask = async (text) => {
    await db.runAsync("INSERT INTO tasks (text, completed) VALUES (?, ?);", [
        text,
        0,
    ]);
};

// Update a task’s text
export const updateTask = async (id, newText) => {
    await db.runAsync("UPDATE tasks SET text = ? WHERE id = ?;", [newText, id]);
};

// Toggle completion
export const toggleTask = async (id, completed) => {
    await db.runAsync("UPDATE tasks SET completed = ? WHERE id = ?;", [
        completed ? 1 : 0,
        id,
    ]);
};

// Delete a task
export const deleteTask = async (id) => {
    await db.runAsync("DELETE FROM tasks WHERE id = ?;", [id]);
};