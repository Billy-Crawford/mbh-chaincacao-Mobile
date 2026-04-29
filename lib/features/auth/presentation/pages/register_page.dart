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

  void register() async {
    await ref.read(authProvider.notifier).register(
      nameController.text,
      phoneController.text,
      pinController.text,
    );

    final state = ref.read(authProvider);

    if (state.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Compte créé avec succès")),
      );

      Navigator.pushReplacementNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.error!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F1E7),
      appBar: AppBar(
        title: const Text("Inscription"),
        backgroundColor: const Color(0xFF5C3A21),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Nom",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: "Téléphone",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: pinController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Mot de passe",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            state.isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: register,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2F6B3F),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Créer un compte"),
            ),
          ],
        ),
      ),
    );
  }
}

