import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Přidání importu pro dotenv

class AIService {
  // Načteme klíče z .env
  final String openAiApiKey = dotenv.env['OPENAI_API_KEY'] ?? ''; // Pokud není klíč, použije prázdný string
  final String geminiApiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

  Future<Map<String, String>> generateFairyTale(String model, String keywords, int length, String genre, String ending) async {
    try {
      String title = "Nepodařilo se vygenerovat název";  // Defaultní hodnota pro název
      String story = "Nepodařilo se vygenerovat pohádku.";  // Defaultní hodnota pro pohádku

      if (model == "ChatGPT") {
        // ChatGPT API
        String apiUrl = "https://api.openai.com/v1/chat/completions";
        var response = await http.post(
          Uri.parse(apiUrl),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $openAiApiKey",
          },
          body: jsonEncode({
            "model": "gpt-3.5-turbo",
            "messages": [
              {"role": "system", "content": "Jsi pohádkový vypravěč."},
              {"role": "user", "content": "Vytvoř $genre pro děti o délce přibližně $length slov na téma: $keywords. Konec pohádky bude $ending. Začni názvem pohádky."}
            ],
            "max_tokens": 1000, // Lze upravit dle potřeby
            "temperature": 0.7,
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final generatedStory = data['choices'][0]['message']['content'];

          // Předpokládáme, že první řádek je název pohádky
          title = generatedStory.split("\n").first;  // První řádek je název
          story = generatedStory.split("\n").skip(1).join("\n");  // Odstraníme název z pohádky
        } else {
          return {"title": "Chyba při generování pohádky (ChatGPT)", "story": "Chyba při generování pohádky (ChatGPT)."};
        }

      } else if (model == "Gemini") {
        // Gemini API
        final generativeModel = GenerativeModel(
          model: 'gemini-2.0-flash',
          apiKey: geminiApiKey,
          generationConfig: GenerationConfig(
            temperature: 1,
            topK: 40,
            topP: 0.95,
            maxOutputTokens: 8192,
          ),
        );

        final chat = generativeModel.startChat(history: []);
        final response = await chat.sendMessage(
          Content.text("Vytvoř $genre pro děti o délce přibližně $length slov na téma: $keywords. Konec pohádky bude $ending. Na první řádek napiš název pohádky bez speciálních znaků."),
        );

        // Předpokládáme, že první řádek je název pohádky
        title = response.text?.split("\n").first ?? "Nepodařilo se vygenerovat název";
        story = response.text?.split("\n").skip(1).join("\n") ?? "Nepodařilo se vygenerovat pohádku z Gemini.";
      } else {
        return {"title": "Neznámý model", "story": "Neznámý model."};
      }

      return {"title": title, "story": story};
    } catch (e) {
      return {"title": "Chyba připojení nebo generování", "story": "Chyba připojení nebo generování: $e"};
    }
  }
}
