import React, { useState, useEffect } from "react";
import {
    StyleSheet,
    Text,
    View,
    TextInput,
    TouchableOpacity,
    FlatList,
} from "react-native";

import {
    insertTask,
    updateTask,
    toggleTask,
    deleteTask,
    getAllTasks,
} from "./databaseHelpers";

type Task = {
    id: number;
    text: string;
    completed: boolean;
};

export default function App() {
    const [task, setTask] = useState("");
    const [tasks, setTasks] = useState<Task[]>([]);
    const [editingTaskId, setEditingTaskId] = useState<number | null>(null);

    // Load tasks on start
    useEffect(() => {
        const setup = async () => {
            await loadTasks();
        };
        setup();
    }, []);

    // --------------------------
    // Load tasks from SQLite
    // --------------------------
    const loadTasks = async () => {
        try {
            const rows = await getAllTasks();
            setTasks(
                rows.map((r) => ({
                    id: r.id,
                    text: r.text,
                    completed: !!r.completed,
                }))
            );
        } catch (err) {
            console.error("Error loading tasks:", err);
        }
    };

    // --------------------------
    // Add or update task
    // --------------------------
    const addOrUpdateTaskHandler = async () => {
        if (!task.trim()) return;

        try {
            if (editingTaskId !== null) {
                await updateTask(editingTaskId, task);
                setEditingTaskId(null);
            } else {
                await insertTask(task);
            }

            setTask("");
            await loadTasks(); // refresh UI
        } catch (err) {
            console.error("Error adding/updating task:", err);
        }
    };

    // --------------------------
    // Delete task
    // --------------------------
    const removeTaskHandler = async (id: number) => {
        try {
            await deleteTask(id);
            await loadTasks(); // refresh UI
        } catch (err) {
            console.error("Error deleting task:", err);
        }
    };

    // --------------------------
    // Toggle completion
    // --------------------------
    const toggleCompleteHandler = async (id: number, completed: boolean) => {
        try {
            await toggleTask(id, !completed);
            await loadTasks(); // refresh UI
        } catch (err) {
            console.error("Error toggling task:", err);
        }
    };

    // --------------------------
    // Edit task
    // --------------------------
    const editTaskHandler = (t: Task) => {
        setTask(t.text);
        setEditingTaskId(t.id);
    };

    return (
        <View style={styles.container}>
            <Text style={styles.heading}>My To-Do List</Text>

            {/* Input + Add/Update */}
            <View style={styles.inputContainer}>
                <TextInput
                    style={styles.input}
                    placeholder="Enter a task"
                    value={task}
                    onChangeText={setTask}
                />
                <TouchableOpacity style={styles.addButton} onPress={addOrUpdateTaskHandler}>
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
                            onPress={() => toggleCompleteHandler(item.id, item.completed)}
                        >
                            <Text style={[styles.taskText, item.completed && styles.completedTask]}>
                                {item.text}
                            </Text>
                        </TouchableOpacity>

                        <View style={styles.actions}>
                            <TouchableOpacity onPress={() => editTaskHandler(item)}>
                                <Text style={styles.actionText}>✏️</Text>
                            </TouchableOpacity>
                            <TouchableOpacity onPress={() => removeTaskHandler(item.id)}>
                                <Text style={styles.actionText}>❌</Text>
                            </TouchableOpacity>
                        </View>
                    </View>
                )}
            />
        </View>
    );
}

// --------------------
// Styles
// --------------------
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
    taskText: { fontSize: 16 },
    completedTask: { textDecorationLine: "line-through", color: "gray" },
    actions: { flexDirection: "row" },
    actionText: { fontSize: 18, marginLeft: 10 },
});