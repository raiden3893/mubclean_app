// lib/core/providers/auth_provider.dart

import 'dart:convert'; // <- Faltaba esto (para jsonEncode)
import 'package:flutter/material.dart'; // <- Faltaba esto (para ChangeNotifier)
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Modelo de Perfil (lo moví aquí para que sea más fácil de usar)
class UserProfile {
  final String id;
  final String nombreCompleto;
  final int idRol;

  UserProfile({
    required this.id,
    required this.nombreCompleto,
    required this.idRol,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'nombre_completo': nombreCompleto, 'id_rol': idRol};
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as String,
      nombreCompleto: map['nombre_completo'] as String,
      idRol: map['id_rol'] as int,
    );
  }
}

// ¡AQUÍ ESTÁ LA MAGIA!
// Añade "with ChangeNotifier" para que "notifyListeners()" funcione
class AuthProvider with ChangeNotifier {
  final supabase = Supabase.instance.client;
  final SharedPreferences prefs;

  // --- VARIABLES QUE FALTABAN ---
  UserProfile? _perfilUsuario;
  bool _isLoading = false;

  // --- GETTERS ---
  UserProfile? get perfil => _perfilUsuario;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _perfilUsuario != null;

  // Constructor
  AuthProvider(this.prefs) {
    _cargarSesionGuardada();
  }

  // Cargar sesión desde el teléfono
  void _cargarSesionGuardada() {
    final perfilString = prefs.getString('userProfile');
    if (perfilString != null) {
      final perfilMap = jsonDecode(perfilString);
      _perfilUsuario = UserProfile.fromMap(perfilMap);
      notifyListeners();
    }
  }

  // --- FUNCIONES ---

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await supabase.functions.invoke(
        'login-personalizado',
        body: {'email': email, 'password': password},
      );

      if (response.status != 200) {
        throw Exception(response.data?['error'] ?? 'Error de credenciales');
      }

      _perfilUsuario = UserProfile.fromMap(response.data);
      await prefs.setString('userProfile', jsonEncode(_perfilUsuario!.toMap()));
    } catch (e) {
      print(
        "Error en login: $e",
      ); // El error de 'print' es solo una advertencia, está bien por ahora
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register({
    required String nombreCompleto,
    required String email,
    required String telefono,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await supabase.functions.invoke(
        'register-personalizado',
        body: {
          'nombre_completo': nombreCompleto,
          'email': email,
          'telefono': telefono,
          'password': password,
        },
      );

      if (response.status != 201) {
        throw Exception(response.data?['error'] ?? 'Error desconocido');
      }

      _perfilUsuario = UserProfile.fromMap(response.data);
      await prefs.setString('userProfile', jsonEncode(_perfilUsuario!.toMap()));
    } catch (e) {
      print("Error en registro: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _perfilUsuario = null;
    await prefs.remove('userProfile');
    notifyListeners();
  }
}
