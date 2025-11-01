package com.example.authdemokotlin.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import com.google.firebase.auth.FirebaseAuth

@Composable
fun HomeScreen(navController: NavController) {
    val auth = FirebaseAuth.getInstance()
    val user = auth.currentUser

    Scaffold { padding ->
        Column(
            modifier = Modifier
                .padding(padding)
                .fillMaxSize(),
            verticalArrangement = Arrangement.Center,
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text("Welcome, ${user?.email ?: "User"}", style = MaterialTheme.typography.headlineLarge)
            Spacer(Modifier.height(16.dp))
            Button(onClick = {
                auth.signOut()
                navController.navigate("login") { popUpTo("home") { inclusive = true } }
            }) {
                Text("Logout")
            }
        }
    }
}
