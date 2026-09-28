import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:movienight_app/features/session/presentation/providers/session_controller.dart';
import 'package:movienight_app/l10n/app_localizations.dart';
import 'session_lobby_page.dart';

class CreateSessionPage extends ConsumerStatefulWidget {
  const CreateSessionPage({super.key});

  @override
  ConsumerState<CreateSessionPage> createState() =>
      _CreateSessionPageState();
}

class _CreateSessionPageState
    extends ConsumerState<CreateSessionPage> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _createSession() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      final errorText = AppLocalizations.of(context)!.createSessionEmptyName;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorText),
        ),
      );
      return;
    }

    final session =
    await ref.read(sessionControllerProvider).createSession(
          name: name,
        );

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SessionLobbyPage(
          session: session,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.createSessionTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.createSessionSubtitle,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(l10n.createSessionDesc),
            const SizedBox(height: 32),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.createSessionLabel,
                hintText: l10n.createSessionHint,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _createSession,
                child: Text(l10n.createSessionButton),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
