// lib/app_wrapper.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// --- IMPORTS QUE FALTABAN ---
import 'core/providers/auth_provider.dart';
import 'features/01_auth/screens/login_screen.dart';
import 'features/02_home/screens/home_screen.dart';
// ---

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Esto ahora funcionará
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.isLoggedIn) {
      // Esto ahora funcionará
      return const HomeScreen();
    }

    // Esto ahora funcionará
    return const LoginScreen();
  }
}
