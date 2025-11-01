import React from "react";
import { View, Text, TouchableOpacity, StyleSheet } from "react-native";
import { signOut } from "firebase/auth";
import { auth } from "../firebaseConfig";

export default function HomeScreen() {
    return (
        <View style={styles.container}>
            <Text style={styles.title}>Welcome 🎉</Text>
            <Text style={styles.text}>You are logged in as {auth.currentUser?.email}</Text>
            <TouchableOpacity style={styles.button} onPress={() => signOut(auth)}>
                <Text style={styles.buttonText}>Logout</Text>
            </TouchableOpacity>
        </View>
    );
}

const styles = StyleSheet.create({
    container: { flex: 1, justifyContent: "center", alignItems: "center", backgroundColor: "#fff" },
    title: { fontSize: 26, fontWeight: "bold", marginBottom: 20 },
    text: { fontSize: 16, marginBottom: 30 },
    button: { backgroundColor: "#ff5252", padding: 15, borderRadius: 8 },
    buttonText: { color: "#fff", fontWeight: "bold" },
});
