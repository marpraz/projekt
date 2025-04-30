import 'package:flutter/material.dart';
import 'generate_screen.dart';
import 'SavedFairyTalesScreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Generátor pohádek'),centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Vygenerovat novou pohádku'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ParametersScreen()));
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Uložené pohádky'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SavedFairyTalesScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

