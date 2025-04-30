import 'package:flutter/material.dart';
import 'package:fairytale_generator/models/fairy_tale.dart';
import 'package:fairytale_generator/screens/story_screen.dart';
import 'package:fairytale_generator/services/api_service.dart';

class SavedFairyTalesScreen extends StatefulWidget {
  const SavedFairyTalesScreen({super.key});

  @override
  State<SavedFairyTalesScreen> createState() => _SavedFairyTalesScreenState();
}

class _SavedFairyTalesScreenState extends State<SavedFairyTalesScreen> {
  late Future<List<FairyTale>> _futureTales;
  List<String> _selectedTags = [];

  @override
  void initState() {
    super.initState();
    _futureTales = ApiService.fetchFairyTales();
  }

  Future<void> _removeTale(String id) async {
    final response = await ApiService.deleteFairyTale(id);

    if (response) {
      setState(() {
        _futureTales = ApiService.fetchFairyTales();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pohádka byla úspěšně smazána.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chyba při mazání pohádky.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Uložené pohádky")),
      body: FutureBuilder<List<FairyTale>>(
        future: _futureTales,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Chyba: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Žádné uložené pohádky."));
          }

          final allTales = snapshot.data!;
          final allTags = <String>{
            for (var tale in allTales) ...tale.tags,
          }.toList()
            ..sort();

          final filteredTales = _selectedTags.isEmpty
              ? allTales
              : allTales.where((tale) => tale.tags.any((tag) => _selectedTags.contains(tag))).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 12.0),
                      child: Text(
                        "Filtrování:",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children: allTags.map((tag) {
                          final isSelected = _selectedTags.contains(tag);
                          return FilterChip(
                            label: Text(tag),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedTags.add(tag);
                                } else {
                                  _selectedTags.remove(tag);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: filteredTales.isNotEmpty
                    ? ListView.builder(
                        itemCount: filteredTales.length,
                        itemBuilder: (context, index) {
                          final tale = filteredTales[index];
                          return ListTile(
                            title: Text(tale.title),
                            subtitle: Text(tale.tags.isNotEmpty ? tale.tags.join(", ") : "Žádné tagy"),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Potvrzení'),
                                    content: const Text('Opravdu chcete tuto pohádku odstranit?'),
                                    actions: [
                                      TextButton(
                                        child: const Text('Ne'),
                                        onPressed: () => Navigator.of(context).pop(false),
                                      ),
                                      TextButton(
                                        child: const Text('Ano'),
                                        onPressed: () => Navigator.of(context).pop(true),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm == true) {
                                  _removeTale(tale.id.toString());
                                }
                              },
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StoryScreen(
                                    id: tale.id,
                                    title: tale.title,
                                    story: tale.story,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      )
                    : const Center(child: Text("Žádné pohádky s vybranými tagy.")),
              ),
            ],
          );
        },
      ),
    );
  }
}
