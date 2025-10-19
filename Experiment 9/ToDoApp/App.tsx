import React, { useState, useEffect } from "react";
import {
  StyleSheet,
  Text,
  View,
  TextInput,
  TouchableOpacity,
  FlatList,
} from "react-native";
import * as SQLite from "expo-sqlite";

const db = SQLite.openDatabaseSync("todo.db");

type Task = {
  id: number;
  text: string;
  completed: boolean;
};

export default function App() {
  const [task, setTask] = useState("");
  const [tasks, setTasks] = useState<Task[]>([]);
  const [editingTaskId, setEditingTaskId] = useState<number | null>(null);

  // ✅ Create table and load tasks once
  useEffect(() => {
    const setupDB = async () => {
      await db.execAsync(`
        CREATE TABLE IF NOT EXISTS tasks (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          text TEXT NOT NULL,
          completed INTEGER DEFAULT 0
        );
      `);
      await loadTasks();
    };
    setupDB();
  }, []);

  // ✅ Load tasks from DB
  const loadTasks = async () => {
    const rows = (await db.getAllAsync("SELECT * FROM tasks")) as {
      id: number;
      text: string;
      completed: number;
    }[];

    setTasks(rows.map((r) => ({ id: r.id, text: r.text, completed: !!r.completed })));
  };

  // ✅ Add or update a task
  const addOrUpdateTask = async () => {
    if (task.trim().length === 0) return;

    if (editingTaskId !== null) {
      await db.runAsync("UPDATE tasks SET text = ? WHERE id = ?", [
        task,
        editingTaskId,
      ]);
      setEditingTaskId(null);
    } else {
      await db.runAsync("INSERT INTO tasks (text) VALUES (?)", [task]);
    }

    setTask("");
    await loadTasks();
  };

  // ✅ Delete task
  const removeTask = async (id: number) => {
    await db.runAsync("DELETE FROM tasks WHERE id = ?", [id]);
    await loadTasks();
  };

  // ✅ Toggle completion
  const toggleComplete = async (id: number, completed: boolean) => {
    const newCompleted = completed ? 0 : 1;
    await db.runAsync("UPDATE tasks SET completed = ? WHERE id = ?", [
      newCompleted,
      id,
    ]);
    await loadTasks();
  };

  // ✅ Edit a task
  const editTask = (task: Task) => {
    setTask(task.text);
    setEditingTaskId(task.id);
  };

  return (
      <View style={styles.container}>
        <Text style={styles.heading}>My To-Do List</Text>

        {/* Input + Add/Update button */}
        <View style={styles.inputContainer}>
          <TextInput
              style={styles.input}
              placeholder="Enter a task"
              value={task}
              onChangeText={setTask}
          />
          <TouchableOpacity style={styles.addButton} onPress={addOrUpdateTask}>
            <Text style={styles.addButtonText}>
              {editingTaskId !== null ? "✔" : "+"}
            </Text>
          </TouchableOpacity>
        </View>

        {/* Task list */}
        <FlatList
            data={tasks}
            keyExtractor={(item) => item.id.toString()}
            renderItem={({ item }) => (
                <View style={styles.taskItem}>
                  <TouchableOpacity
                      style={{ flex: 1 }}
                      onPress={() => toggleComplete(item.id, item.completed)}
                  >
                    <Text
                        style={[
                          styles.taskText,
                          item.completed && styles.completedTask,
                        ]}
                    >
                      {item.text}
                    </Text>
                  </TouchableOpacity>

                  <View style={styles.actions}>
                    {/* ✏️ Edit button */}
                    <TouchableOpacity onPress={() => editTask(item)}>
                      <Text style={styles.actionText}>✏️</Text>
                    </TouchableOpacity>
                    {/* ❌ Delete button */}
                    <TouchableOpacity onPress={() => removeTask(item.id)}>
                      <Text style={styles.actionText}>❌</Text>
                    </TouchableOpacity>
                  </View>
                </View>
            )}
        />
      </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#f5f5f5",
    paddingTop: 50,
    paddingHorizontal: 20,
  },
  heading: {
    fontSize: 28,
    fontWeight: "bold",
    marginBottom: 20,
    textAlign: "center",
  },
  inputContainer: {
    flexDirection: "row",
    marginBottom: 20,
  },
  input: {
    flex: 1,
    borderWidth: 1,
    borderColor: "#ccc",
    paddingHorizontal: 10,
    paddingVertical: 8,
    borderRadius: 8,
    backgroundColor: "#fff",
  },
  addButton: {
    marginLeft: 10,
    backgroundColor: "#007AFF",
    borderRadius: 8,
    justifyContent: "center",
    alignItems: "center",
    paddingHorizontal: 15,
  },
  addButtonText: {
    color: "#fff",
    fontSize: 22,
    fontWeight: "bold",
  },
  taskItem: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
    padding: 12,
    marginBottom: 10,
    backgroundColor: "#fff",
    borderRadius: 8,
    borderWidth: 1,
    borderColor: "#ddd",
  },
  taskText: {
    fontSize: 16,
  },
  completedTask: {
    textDecorationLine: "line-through",
    color: "gray",
  },
  actions: {
    flexDirection: "row",
  },
  actionText: {
    fontSize: 18,
    marginLeft: 10,
  },
});