import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/providers/auth_provider.dart'; // Importa el Provider
import 'app_wrapper.dart'; // Importa el Wrapper

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Cargar .env
  await dotenv.load(fileName: ".env");

  // Iniciar Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  // Iniciar SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // Pasa las 'prefs' al AuthProvider
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(prefs),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MubClean App',
      theme: ThemeData(
        // ¡AQUÍ PONES TUS COLORES DE DISEÑO!
        primaryColor: const Color(0xFF00AABB), // Ejemplo
        scaffoldBackgroundColor: const Color(0xFFF5F5F5), // Ejemplo
      ),
      // El home de la app es el WIDGET VIGILANTE
      home: const AuthWrapper(),
    );
  }
}
