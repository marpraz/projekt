# Fairytale Generator Project

Tento projekt slouží k vytvoření mobilní aplikace pro generování pohádek pomocí umělé inteligence. Aplikace využívá různé AI modely pro generování textu a umožňuje uživatelům ukládat a třídit pohádky. Aplikace je rozdělena na dvě hlavní části: backend a frontend.

## Složky projektu

### 1. **fairytale_backend**

Složka `fairytale_backend` obsahuje všechny související soubory pro backend server. Tento server je zodpovědný za správu uložených pohádek. Ukládá je do databáze, poskytuje API pro jejich získání a mazání.


### 2. **fairytale_generator**

Složka `fairytale_generator` obsahuje všechny související soubory pro mobilní aplikaci, která běží na frameworku Flutter. Tato aplikace umožňuje uživatelům generovat pohádky, upravovat je pomocí různých parametrů (např. délka pohádky, klíčová slova, žánr), ukládat je a číst je offline.

## Instalace a spuštění
### Backend (fairytale_backend)
1. **Instalace závislostí**:
    ```bash
    pip install -r requirements.txt
    ```

2. **Spuštění serveru**:
    ```bash
    python manage.py runserver
    ```

### Vytvoření `.env` souboru

Pro správnou funkčnost aplikace je nutné mít API klíče pro jednotlivé modely AI, jako jsou OpenAI (ChatGPT) a Gemini. Tyto klíče uložíš do souboru `.env`, který aplikace používá pro konfiguraci.

1. V kořenovém adresáři projektu (`fairytale_generator`), vytvoř nový soubor s názvem **`.env`**.
   
2. Tento soubor bude obsahovat API klíče pro OpenAI a Gemini. Použij následující formát pro soubor `.env`:

   ```dotenv
   OPENAI_API_KEY=tvůj_openai_api_klíč
   GEMINI_API_KEY=tvůj_gemini_api_klíč
   
### Mobilní aplikace (fairytale_generator)
1. **Instalace závislostí**:
    ```bash
    flutter pub get
    ```

2. **Spuštění aplikace**:
    ```bash
    flutter run
    ```
