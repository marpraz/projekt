import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fairytale_generator/models/fairy_tale.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000/api'; // URL pro Android emulator
  static const String cacheKey = 'cached_fairy_tales'; // Klíč pro SharedPreferences

  // Metoda pro uložení pohádky na server
  static Future<void> saveFairyTale(FairyTale tale) async {
    final url = Uri.parse('$baseUrl/tales/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(tale.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Chyba při ukládání: ${response.body}');
    }
  }

  // Metoda pro načtení všech pohádek
  static Future<List<FairyTale>> fetchFairyTales() async {
    try {
      final url = Uri.parse('$baseUrl/tales/');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        final tales = data.map((json) => FairyTale.fromJson(json)).toList();

        // Uložíme data i offline
        await _cacheFairyTales(tales);

        return tales;
      } else {
        throw Exception('Nepodařilo se načíst pohádky: ${response.body}');
      }
    } catch (e) {
      // Pokud nastane chyba (např. offline), zkusíme načíst uložené pohádky
      return await _loadCachedFairyTales();
    }
  }

  // Metoda pro odstranění pohádky ze serveru
  static Future<bool> deleteFairyTale(String id) async {
    final url = Uri.parse('$baseUrl/tales/$id/');
    final response = await http.delete(url);

    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  // === Interní pomocné metody ===

  static Future<void> _cacheFairyTales(List<FairyTale> tales) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonTales = tales.map((tale) => jsonEncode(tale.toJson())).toList();
    await prefs.setStringList(cacheKey, jsonTales);
  }

  static Future<List<FairyTale>> _loadCachedFairyTales() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonTales = prefs.getStringList(cacheKey) ?? [];

    return jsonTales.map((jsonStr) {
      final Map<String, dynamic> json = jsonDecode(jsonStr);
      return FairyTale.fromJson(json);
    }).toList();
  }
}
