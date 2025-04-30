import 'package:flutter/material.dart';
import 'package:fairytale_generator/models/fairy_tale.dart';
import 'package:fairytale_generator/services/api_service.dart';

class StoryScreen extends StatelessWidget {
  final String story;
  final String title;
  final int id;

  const StoryScreen({super.key, required this.story, required this.title, required this.id});

  void _showSaveDialog(BuildContext context) {
    final TextEditingController tagController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Uložit pohádku'),
          content: TextField(
            controller: tagController,
            decoration: const InputDecoration(
              labelText: 'Zadejte tagy (oddělené čárkou)',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Zrušit'),
            ),
            TextButton(
              onPressed: () async {
                final tags = tagController.text
                    .split(',')
                    .map((tag) => tag.trim())
                    .where((tag) => tag.isNotEmpty)
                    .toList();

                final tale = FairyTale(id: id, title: title, story: story, tags: tags);

                try {
                  await ApiService.saveFairyTale(tale);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pohádka byla uložena')),
                  );
                } catch (e) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Chyba při ukládání: $e')),
                  );
                }
              },
              child: const Text('Uložit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_add),
            tooltip: 'Uložit pohádku',
            onPressed: () => _showSaveDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  story,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Zpět na výběr parametrů'),
            ),
          ],
        ),
      ),
    );
  }
}
