import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos el provider para leer los datos del usuario
    final authProvider = context.read<AuthProvider>();

    // Obtenemos el nombre del perfil (asegurándonos de que no sea nulo)
    final nombreUsuario = authProvider.perfil?.nombreCompleto ?? 'Usuario';

    return Scaffold(
      appBar: AppBar(
        // ¡AQUÍ PONES TU APPBAR DE DISEÑO!
        title: const Text('Home'),
        actions: [
          // Botón de Logout
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Llama a la lógica de logout
              authProvider.logout();
              // El AuthWrapper se encargará de navegar al Login
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¡Bienvenido de vuelta, $nombreUsuario!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            // ¡AQUÍ CONSTRUYES EL RESTO DE TU HOME PAGE!
            const Text('Tu contenido del Home va aquí.'),
          ],
        ),
      ),
    );
  }
}
