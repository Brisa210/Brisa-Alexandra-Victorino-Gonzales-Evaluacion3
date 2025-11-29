import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'entregas/entrega_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final nombre = auth.user?.nombre ?? '';
    final email = auth.user?.email ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paquexpress - Inicio'),
        actions: [
          IconButton(
            onPressed: () async {
              await auth.logout();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bienvenido, $nombre', style: const TextStyle(fontSize: 20)),
            Text('Email: $email'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EntregaListScreen()),
                );
              },
              child: const Text('Ver entregas asignadas'),
            ),
          ],
        ),
      ),
    );
  }
}
