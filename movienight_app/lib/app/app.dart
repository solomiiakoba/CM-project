import 'package:flutter/material.dart';

import '../features/sessions/presentation/create_session_page.dart';
import '../features/sessions/presentation/scan_session_page.dart';
import '../features/bluetooth/presentation/bluetooth_peripheral_test_page.dart';

import 'theme.dart';

class MovieNightApp extends StatelessWidget {
  const MovieNightApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MovieNight',
      debugShowCheckedModeBanner: false,
      theme: MovieNightTheme.light,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MovieNight'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'MovieNight 🎬',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'Escolhe um filme com os teus amigos.',
            ),

            const SizedBox(height: 32),

            // =================================================
            // CRIAR SESSÃO
            // =================================================

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const CreateSessionPage(),
                  ),
                );
              },
              child: const Text('Nova sessão'),
            ),

            const SizedBox(height: 16),

            // =================================================
            // ENTRAR NUMA SESSÃO
            // =================================================

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const ScanSessionPage(),
                  ),
                );
              },
              child: const Text('Entrar numa sessão'),
            ),

            const SizedBox(height: 16),

            // =================================================
            // TESTE PERIPHERAL
            // =================================================

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const BluetoothPeripheralTestPage(),
                  ),
                );
              },
              child: const Text('Bluetooth Peripheral'),
            ),
          ],
        ),
      ),
    );
  }
}
