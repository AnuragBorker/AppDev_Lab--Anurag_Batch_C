package com.example.authdemokotlin

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.runtime.*
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.example.authdemokotlin.ui.screens.*
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.FirebaseApp

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        FirebaseApp.initializeApp(this)

        setContent {
            val navController = rememberNavController()
            val auth = FirebaseAuth.getInstance()
            var user by remember { mutableStateOf(auth.currentUser) }

            DisposableEffect(Unit) {
                val listener = FirebaseAuth.AuthStateListener { authState ->
                    user = authState.currentUser
                }
                auth.addAuthStateListener(listener)
                onDispose { auth.removeAuthStateListener(listener) }
            }

            NavHost(
                navController = navController,
                startDestination = if (user == null) "login" else "home"
            ) {
                composable("login") { LoginScreen(navController) }
                composable("register") { RegisterScreen(navController) }
                composable("home") { HomeScreen(navController) }
            }
        }
    }
}
