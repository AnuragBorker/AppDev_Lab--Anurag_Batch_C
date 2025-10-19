// databaseHelpers.ts
import * as SQLite from "expo-sqlite";
import {
    addTask as addTaskToFirebase,
    updateTask as updateTaskInFirebase,
    toggleTask as toggleTaskInFirebase,
    deleteTask as deleteTaskFromFirebase,
} from "./database"; // Firebase helpers

const db = SQLite.openDatabaseSync("todo.db");

export type TaskRow = {
    id: number;
    firebase_id?: string;
    text: string;
    completed: number;
};

// Initialize DB
export const initDB = () => {
    try {
        db.execSync(`
      CREATE TABLE IF NOT EXISTS tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        firebase_id TEXT,
        text TEXT NOT NULL,
        completed INTEGER DEFAULT 0
      );
    `);
    } catch (err: any) {
        console.error("SQLite initDB error:", err);
    }
};

// Insert Task
export const insertTask = async (text: string): Promise<void> => {
    try {
        // Add to Firebase first
        const firebaseId = await addTaskToFirebase(text);

        // Insert into SQLite
        db.runSync(
            "INSERT INTO tasks (firebase_id, text, completed) VALUES (?, ?, 0);",
            [firebaseId, text]
        );
    } catch (err) {
        console.error("SQLite insertTask error:", err);
    }
};

// Update Task text
export const updateTask = async (id: number, text: string): Promise<void> => {
    try {
        const rows = db.getAllSync("SELECT * FROM tasks WHERE id = ?;", [id]) as TaskRow[];
        const task = rows[0]; // now TS knows this is TaskRow | undefined

        if (task?.firebase_id) {
            await updateTaskInFirebase(task.firebase_id, text);
        }

        db.runSync("UPDATE tasks SET text = ? WHERE id = ?;", [text, id]);
    } catch (err) {
        console.error("SQLite updateTask error:", err);
    }
};

// Toggle completion
export const toggleTask = async (id: number, completed: boolean): Promise<void> => {
    try {
        const rows = db.getAllSync("SELECT * FROM tasks WHERE id = ?;", [id]) as TaskRow[];
        const task = rows[0];

        if (task?.firebase_id) {
            await toggleTaskInFirebase(task.firebase_id, completed);
        }

        db.runSync(
            "UPDATE tasks SET completed = ? WHERE id = ?;",
            [completed ? 1 : 0, id]
        );
    } catch (err) {
        console.error("SQLite toggleTask error:", err);
    }
};

// Delete task
export const deleteTask = async (id: number): Promise<void> => {
    try {
        const rows = db.getAllSync("SELECT * FROM tasks WHERE id = ?;", [id]) as TaskRow[];
        const task = rows[0];

        if (task?.firebase_id) {
            await deleteTaskFromFirebase(task.firebase_id);
        }

        db.runSync("DELETE FROM tasks WHERE id = ?;", [id]);
    } catch (err) {
        console.error("SQLite deleteTask error:", err);
    }
};

// Get all tasks
export const getAllTasks = (): TaskRow[] => {
    try {
        const rows = db.getAllSync("SELECT * FROM tasks ORDER BY id DESC;");
        // @ts-ignore
        return rows || [];
    } catch (err) {
        console.error("SQLite getAllTasks error:", err);
        return [];
    }
};