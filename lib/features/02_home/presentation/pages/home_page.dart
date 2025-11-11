import 'package:flutter/material.dart';
import 'package:mubclean/core/providers/auth_provider.dart'; // 1. Importa el provider
import 'package:mubclean/config/app_colors.dart'; // Importa tus colores
import 'package:provider/provider.dart'; // 2. Importa provider

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Índice para la navegación inferior (si se implementa)
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // 3. Obtén los datos del usuario desde el provider
    final authProvider = context.watch<AuthProvider>();
    final nombreUsuario =
        authProvider.perfil?.nombreCompleto.split(' ').first ?? 'Usuario';

    // Detectar el modo oscuro para aplicar colores dinámicamente
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode
        ? AppColors.backgroundDark
        : AppColors.backgroundLight;
    final textColor = isDarkMode
        ? AppColors.textColorDark
        : AppColors.textColorLight;
    final cardColor = isDarkMode ? AppColors.slate800 : AppColors.white;
    final secondaryTextColor = isDarkMode
        ? AppColors.gray400
        : AppColors.gray500;
    final dividerColor = isDarkMode ? AppColors.slate700 : AppColors.gray200;

    return Scaffold(
      backgroundColor: backgroundColor,
      // No usamos un Drawer en este diseño, la navegación es inferior

      // --- Custom AppBar (Barra superior) ---
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(
          kToolbarHeight + 16,
        ), // Altura un poco más grande
        child: Container(
          color: backgroundColor, // Fondo de la barra
          padding: const EdgeInsets.only(
            top: 16.0,
            left: 16.0,
            right: 16.0,
          ), // Padding personalizado
          child: AppBar(
            backgroundColor: Colors
                .transparent, // Transparente para usar el Container de fondo
            elevation: 0, // Sin sombra
            leading: const Icon(
              Icons.auto_awesome,
              color: AppColors.primary,
              size: 28,
            ), // Ícono de estrella
            title: Text(
              'Hola, $nombreUsuario', // 4. Usa el nombre dinámico
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              // Botón de Logout (opcional, pero recomendado aquí)
              IconButton(
                icon: const Icon(Icons.logout),
                color: textColor,
                onPressed: () {
                  // Llama a la lógica de logout
                  context.read<AuthProvider>().logout();
                },
              ),
            ],
          ),
        ),
      ),

      // --- Body (Contenido principal de la página) ---
      body: SingleChildScrollView(
        // Para permitir el scroll si el contenido es largo
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Alinea el contenido a la izquierda
          children: <Widget>[
            // --- Primary CTA Card ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: cardColor,
                elevation: 1, // Sombra ligera
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 180, // Altura fija para la imagen
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12.0),
                        ),
                        image: const DecorationImage(
                          image: NetworkImage(
                            "https://via.placeholder.com/600x400/CCCCCC/FFFFFF?text=Mueble+Limpio", // Placeholder
                            // "https://lh3.googleusercontent.com/aida-public/AB6AXuBZOzET4C055vW0JIGNHKv4bwISAxb4q4cHpnN1f9ee1NwndPddwYxt2iGV5L6INKYjRYKNZWYWnO0eMovejcZs0SlMRLfi-8HFWJD8t0573ctatnd8kbVAgs5hfEUfMZ61GXqkOGLv3ZxHLNVpUkDPxY87igp5IqQnhFhUTWSha4cCH7V49rTUfAksmiIAuWCDzzChAp7IoQ9j6mM5XHlrbuZGrgCppI6tWenL5EhqfqAZLRP5L_kSediWnp5qq0_2lILbHaQy613n", // URL de la imagen original (podría no funcionar directamente)
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Deja tus muebles como nuevos',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Cotiza, agenda y paga en minutos.',
                                  style: TextStyle(
                                    color: secondaryTextColor,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              ElevatedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Cotizar Ahora'),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                ),
                                child: const Text(
                                  'Cotizar Ahora',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --- Próxima Cita Section ---
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Text(
                'Próxima Cita',
                style: TextStyle(
                  color: textColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                color: cardColor,
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withAlpha(51),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: const Icon(
                              Icons.calendar_month,
                              color: AppColors.primary,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Limpieza de Sofá',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Técnico: Juan Pérez',
                                style: TextStyle(
                                  color: secondaryTextColor,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'Martes, 28 de Octubre, 10:00 AM',
                                style: TextStyle(
                                  color: secondaryTextColor,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Ver Detalles')),
                          );
                        },
                        child: const Text(
                          'Ver Detalles',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // --- Quick Access Links Section ---
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 24.0,
              ),
              child: Text(
                'Accesos Rápidos',
                style: TextStyle(
                  color: textColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                // Usamos Column para que cada tarjeta ocupe el ancho completo
                children: [
                  _buildQuickAccessCard(
                    context,
                    icon: Icons.history,
                    title: 'Mi Historial de Servicios',
                    subtitle: 'Revisa tus citas pasadas',
                    cardColor: cardColor,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Ir a Historial')),
                      );
                    },
                  ),
                  const SizedBox(height: 16), // Espacio entre tarjetas
                  _buildQuickAccessCard(
                    context,
                    icon: Icons.local_offer,
                    title: 'Promociones',
                    subtitle: 'Aprovecha los descuentos',
                    cardColor: cardColor,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Ir a Promociones')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 100,
            ), // Espacio para que la navegación inferior no cubra contenido
          ],
        ),
      ),

      // --- Bottom Navigation Bar ---
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: cardColor.withAlpha(230), // Fondo con opacidad y efecto blur
          border: Border(top: BorderSide(color: dividerColor, width: 1.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(0, -2), // Sombra hacia arriba
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor:
              Colors.transparent, // Fondo transparente para usar el Container
          elevation: 0, // Sin sombra
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
            // Lógica de navegación aquí
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Navegando a la opción ${index + 1}')),
            );
          },
          selectedItemColor: AppColors.primary,
          unselectedItemColor: secondaryTextColor,
          selectedLabelStyle: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
          type:
              BottomNavigationBarType.fixed, // Para que todos los ítems se vean
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long),
              label: 'Mis Servicios',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Mi Perfil',
            ),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para las tarjetas de Acceso Rápido
  Widget _buildQuickAccessCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color cardColor,
    required Color textColor,
    required Color secondaryTextColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      // Hace que toda la tarjeta sea clickable
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.0),
      child: Card(
        color: cardColor,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: EdgeInsets.zero, // Eliminar margen por defecto de Card
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(51),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Icon(icon, color: AppColors.primary, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(color: secondaryTextColor, fontSize: 14),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: secondaryTextColor),
            ],
          ),
        ),
      ),
    );
  }
}
