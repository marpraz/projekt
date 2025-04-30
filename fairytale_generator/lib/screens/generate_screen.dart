import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // Přidáno pro kontrolu internetu
import 'package:fairytale_generator/services/ai_service.dart';
import 'package:fairytale_generator/screens/story_screen.dart';

class ParametersScreen extends StatefulWidget {
  const ParametersScreen({super.key});

  @override
  _ParametersScreenState createState() => _ParametersScreenState();
}

class _ParametersScreenState extends State<ParametersScreen> {
  String selectedModel = "ChatGPT";
  String fairyTale = "";
  String keywords = "";
  String genre = "Klasická pohádka";
  String ending = "Šťastný";
  TextEditingController keywordController = TextEditingController();
  double wordCount = 300;

  // Funkce pro kontrolu připojení k internetu
  Future<bool> isConnected() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parametry pohádky'),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Výběr modelu
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            "Model: ",
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(width: 10),
                          DropdownButton<String>(
                            value: selectedModel,
                            items: ["ChatGPT", "Gemini"].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedModel = newValue!;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Klíčová slova
                      const Text(
                        "Zadejte klíčová slova pro pohádku: ",
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: keywordController,
                        decoration: const InputDecoration(
                          hintText: "Např. princezna, drak, les",
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (text) {
                          setState(() {
                            keywords = text;
                          });
                        },
                      ),
                      const SizedBox(height: 20),

                      // Počet slov
                      const Text(
                        "Počet slov v pohádce:",
                        style: TextStyle(fontSize: 18),
                      ),
                      Slider(
                        value: wordCount,
                        min: 200,
                        max: 700,
                        divisions: 500,
                        label: wordCount.round().toString(),
                        onChanged: (double newValue) {
                          setState(() {
                            wordCount = newValue;
                          });
                        },
                      ),
                      Text(
                        "Počet slov: ${wordCount.round()}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),

                      // Žánr pohádky
                      const Text(
                        "Žánr pohádky:",
                        style: TextStyle(fontSize: 18),
                      ),
                      DropdownButton<String>(
                        value: genre,
                        items: [
                          "Klasická pohádka",
                          "Fantasy pohádka",
                          "Dobrodružná pohádka",
                          "Romantická pohádka",
                          "Hororová pohádka",
                          "Vědecká pohádka",
                          "Historická pohádka"
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            genre = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 20),

                      // Typ konce
                      const Text(
                        "Typ konce pohádky:",
                        style: TextStyle(fontSize: 18),
                      ),
                      DropdownButton<String>(
                        value: ending,
                        items: [
                          "Šťastný",
                          "Tragický",
                          "Neutrální",
                          "Otevřený",
                          "Poučný",
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            ending = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 20),

                      // Výstup pohádky
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            fairyTale,
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Tlačítko vygenerovat pohádku
                      ElevatedButton(
                        onPressed: () async {
                          if (await isConnected()) {
                            setState(() {
                              fairyTale = "Generování pohádky pro model $selectedModel...";
                            });

                            try {
                              var result = await AIService().generateFairyTale(
                                selectedModel,
                                keywords,
                                wordCount.toInt(),
                                genre,
                                ending,
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StoryScreen(
                                    id: int.tryParse(result['id'] ?? '') ?? 0,
                                    story: result['story']!,
                                    title: result['title']!,
                                  ),
                                ),
                              );
                            } catch (e) {
                              setState(() {
                                fairyTale = "Chyba při generování pohádky: $e";
                              });
                            }
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Offline režim'),
                                content: const Text('Jste offline. Nelze vygenerovat novou pohádku.'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        child: const Text('Vygenerovat pohádku'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
