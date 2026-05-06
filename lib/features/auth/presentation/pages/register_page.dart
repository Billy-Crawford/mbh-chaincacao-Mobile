// lib/features/auth/presentation/pages/register_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final pinController = TextEditingController();
  final villageController = TextEditingController();
  final regionController = TextEditingController();

  void register() async {
    await ref.read(authProvider.notifier).register(
      nameController.text,
      phoneController.text,
      pinController.text,
      villageController.text,
      regionController.text,
    );

    final state = ref.read(authProvider);

    if (!mounted) return;

    if (state.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Compte créé avec succès"),
          backgroundColor: Color(0xFF2F6B3F),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pushReplacementNamed(context, '/login');
    } else {
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
      backgroundColor: const Color(0xFFFBF9F4),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF2E1E12)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                "Nouveau Compte",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2E1E12),
                  letterSpacing: -1,
                ),
              ),
              const Text(
                "Rejoignez la communauté des agriculteurs",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 40),

              _buildInputField(
                controller: nameController,
                label: "Nom complet",
                icon: Icons.person_add_alt_1_rounded,
              ),

              const SizedBox(height: 16),

              _buildInputField(
                controller: phoneController,
                label: "Numéro de téléphone",
                icon: Icons.phone_android_rounded,
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 16),

              _buildInputField(
                controller: villageController,
                label: "Village",
                icon: Icons.location_on_outlined,
              ),

              const SizedBox(height: 16),

              _buildInputField(
                controller: regionController,
                label: "Région",
                icon: Icons.map_outlined,
              ),

              const SizedBox(height: 16),

              _buildInputField(
                controller: pinController,
                label: "Code PIN / Mot de passe",
                icon: Icons.lock_outline_rounded,
                isPassword: true,
              ),

              const SizedBox(height: 40),

              state.isLoading
                  ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF2F6B3F)),
              )
                  : ElevatedButton(
                onPressed: register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2F6B3F),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Créer mon compte",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                  child: RichText(
                    text: const TextSpan(
                      text: "Déjà inscrit ? ",
                      style: TextStyle(color: Colors.grey),
                      children: [
                        TextSpan(
                          text: "Connectez-vous",
                          style: TextStyle(
                            color: Color(0xFF2F6B3F),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF5C3A21),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: const Color(0xFF2F6B3F), size: 22),
              border: InputBorder.none,
              hintText: "Saisir votre $label",
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              contentPadding: const EdgeInsets.symmetric(vertical: 18),
            ),
          ),
        ),
      ],
    );
  }
}


