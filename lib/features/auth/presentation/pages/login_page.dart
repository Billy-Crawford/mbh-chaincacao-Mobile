// lib/features/auth/presentation/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void login() async {
    await ref.read(authProvider.notifier).login(
      usernameController.text,
      passwordController.text,
    );

    final state = ref.read(authProvider);

    if (!mounted) return;

    if (state.token != null) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else if (state.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.error!),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F4), // Fond plus lumineux et propre
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icone ou Logo Thématique
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2F6B3F).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.agriculture_rounded,
                    size: 80,
                    color: Color(0xFF2F6B3F),
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  "Bienvenue",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2E1E12),
                    letterSpacing: -0.5,
                  ),
                ),

                const Text(
                  "Connectez-vous à votre espace agriculteur",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 40),

                // Champ Utilisateur
                _buildTextField(
                  controller: usernameController,
                  label: "Nom d'utilisateur",
                  icon: Icons.person_outline_rounded,
                ),

                const SizedBox(height: 16),

                // Champ Mot de passe
                _buildTextField(
                  controller: passwordController,
                  label: "Mot de passe",
                  icon: Icons.lock_outline_rounded,
                  isPassword: true,
                ),

                const SizedBox(height: 12),

                // Lien mot de passe oublié (Optionnel mais recommandé pour le design)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Mot de passe oublié ?",
                      style: TextStyle(color: Color(0xFF2F6B3F), fontWeight: FontWeight.w600),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Bouton de Connexion
                state.isLoading
                    ? const CircularProgressIndicator(color: Color(0xFF2F6B3F))
                    : ElevatedButton(
                  onPressed: login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2F6B3F),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                    shadowColor: const Color(0xFF2F6B3F).withOpacity(0.4),
                  ),
                  child: const Text(
                    "Se connecter",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 24),

                // Footer Créer un compte
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Nouveau ici ?"),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/register'),
                      child: const Text(
                        "Créer un compte",
                        style: TextStyle(
                          color: Color(0xFF2F6B3F),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget Helper pour les champs de texte
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: const Color(0xFF2F6B3F)),
          labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          floatingLabelStyle: const TextStyle(color: Color(0xFF2F6B3F)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}