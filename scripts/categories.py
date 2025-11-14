import json
import subprocess
import sys
import os
import argparse

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
QUESTIONS_FILE = os.path.join(SCRIPT_DIR, "..", "app", "assets", "questions-nl-sv.json")
QUESTIONS_FILE_WITH_CATEGORIES = os.path.join(SCRIPT_DIR, "..", "app", "assets", "questions-nl-sv_with_categories.json")
CATEGORIES_FILE = os.path.join(SCRIPT_DIR, "..", "app", "assets", "categories.json")

# --- Ollama helpers (from add-cat.py) ---
def get_ollama_models():
    try:
        print("[DEBUG] Fetching Ollama models...", file=sys.stderr)
        result = subprocess.run(
            ["ollama", "list"],
            capture_output=True,
            text=True
        )
        if result.returncode != 0:
            print(f"[ERROR] ollama list failed: {result.stderr}", file=sys.stderr)
            return []
        lines = [line.strip() for line in result.stdout.splitlines() if line.strip()]
        models = [line.split()[0] for line in lines[1:]] if len(lines) > 1 else []
        print(f"[DEBUG] Models found: {models}", file=sys.stderr)
        return models
    except Exception as e:
        print(f"[ERROR] Exception fetching models: {e}", file=sys.stderr)
        return []

def vraag_ollama(vraag, categorieen, model_naam):
    prompt = f"""
Je bent een categorisatietool voor een Nederlandse Bijbelquiz.

BELANGRIJK: Voeg NOOIT een categorie toe die niet in de onderstaande lijst staat. Gebruik alleen categorieën uit deze lijst. Als geen enkele categorie past, kies dan uitsluitend [\"none\"]. Voeg nooit nieuwe categorieën toe.

Gegeven de meerkeuzevraag hieronder, kies alle toepasselijke categorieën (0 of meer) uit deze lijst:
{', '.join(categorieen)}

Vraag: \"{vraag}\"

Geef alleen een JSON-array terug, zoals:
[\"New Testament\", \"Facts and Numbers\"]
of [\"none\"] als geen enkele categorie past.
"""
    try:
        result = subprocess.run(
            ["ollama", "run", model_naam],
            input=prompt,
            capture_output=True,
            text=True
        )
        if result.returncode != 0:
            print(f"[ERROR] ollama run failed: {result.stderr}", file=sys.stderr)
            return ["none"]
        print(f"[DEBUG] ollama output: {result.stdout}", file=sys.stderr)
        # Parse output, fallback to ["none"] if empty or invalid
        try:
            cats = json.loads(result.stdout.strip())
            if not cats or not isinstance(cats, list):
                return ["none"]
            return cats
        except Exception:
            return ["none"]
    except Exception as e:
        print(f"[ERROR] Parserfout of call error: {e}", file=sys.stderr)
        return ["none"]

def categoriseer_cli(model_naam):
    print("[DEBUG] Starting categorization...", file=sys.stderr)
    try:
        with open(QUESTIONS_FILE, "r", encoding="utf-8") as f:
            vragen = json.load(f)
        with open(CATEGORIES_FILE, "r", encoding="utf-8") as f:
            categorieen = json.load(f)
    except Exception as e:
        print(f"[ERROR] Kon bestanden niet laden: {e}", file=sys.stderr)
        sys.exit(1)

    output_file = QUESTIONS_FILE_WITH_CATEGORIES
    temp_file = output_file + ".tmp"

    changed = False
    for idx, v in enumerate(vragen):
        if not v.get("categories"):
            print(f"[INFO] Categorizing question {idx+1}/{len(vragen)}: {v.get('vraag', '')[:60]}...", file=sys.stderr)
            v["categories"] = vraag_ollama(v.get("vraag", ""), categorieen, model_naam)
            changed = True
            try:
                with open(temp_file, "w", encoding="utf-8") as f:
                    json.dump(vragen, f, ensure_ascii=False, indent=2)
                print(f"[DEBUG] Progress saved to {temp_file} after question {idx+1}", file=sys.stderr)
            except Exception as e:
                print(f"[ERROR] Could not save progress: {e}", file=sys.stderr)
        else:
            print(f"[INFO] Skipping question {idx+1}/{len(vragen)} (already categorized)", file=sys.stderr)

    if changed:
        try:
            with open(output_file, "w", encoding="utf-8") as f:
                json.dump(vragen, f, ensure_ascii=False, indent=2)
            print(f"[INFO] Geslaagd! Resultaat opgeslagen in '{output_file}'.", file=sys.stderr)
            if os.path.exists(temp_file):
                os.remove(temp_file)
        except Exception as e:
            print(f"[ERROR] Kon niet opslaan: {e}", file=sys.stderr)
    else:
        print("[INFO] Geen vragen om te categoriseren. Alles is al gecategoriseerd.", file=sys.stderr)

# --- Category check/clean (from check-cat.py) ---
def check_and_clean_categories():
    with open(CATEGORIES_FILE, "r", encoding="utf-8") as f:
        valid_categories = set(json.load(f))
    with open(QUESTIONS_FILE_WITH_CATEGORIES, "r", encoding="utf-8") as f:
        questions = json.load(f)
    changes = []
    for idx, q in enumerate(questions):
        q_cats = q.get("categories", [])
        invalid = [cat for cat in q_cats if cat not in valid_categories]
        if invalid:
            new_cats = [cat for cat in q_cats if cat in valid_categories]
            questions[idx]["categories"] = new_cats
            changes.append((idx, q.get("vraag", "<geen vraag>"), invalid))
    if changes:
        print("Ongeldige categorieën verwijderd:")
        for idx, vraag, cats in changes:
            print(f"Vraag #{idx+1}: '{vraag}' -> Verwijderd: {cats}")
        with open(QUESTIONS_FILE_WITH_CATEGORIES, "w", encoding="utf-8") as f:
            json.dump(questions, f, ensure_ascii=False, indent=2)
        print(f"Totaal: {len(changes)} vragen aangepast. Bestand bijgewerkt.")
    else:
        print("Alle categorieën zijn geldig. Geen wijzigingen nodig.")

# --- Main CLI ---
def main():
    parser = argparse.ArgumentParser(description="BijbelQuiz Categoriseer & Check Tool")
    subparsers = parser.add_subparsers(dest="command", required=False)

    # Categorize subcommand
    parser_cat = subparsers.add_parser("categorize", help="Categoriseer vragen met Ollama")
    parser_cat.add_argument(
        "--model",
        type=str,
        help="Naam van het Ollama-model om te gebruiken (anders handmatige selectie)",
        default=None
    )

    # Check subcommand
    parser_check = subparsers.add_parser("check", help="Controleer en herstel categorieën")

    args = parser.parse_args()

    if args.command == "categorize":
        models = get_ollama_models()
        if not models:
            print("[ERROR] Geen Ollama-modellen gevonden. Installeer of start Ollama.", file=sys.stderr)
            sys.exit(1)
        model_naam = args.model
        if not model_naam:
            print("Beschikbare modellen:")
            for i, m in enumerate(models, 1):
                print(f"  {i}. {m}")
            while True:
                try:
                    keuze = input(f"Kies een model (1-{len(models)}): ").strip()
                    idx = int(keuze) - 1
                    if 0 <= idx < len(models):
                        model_naam = models[idx]
                        break
                    else:
                        print(f"Voer een getal in tussen 1 en {len(models)}.")
                except ValueError:
                    print("Ongeldige invoer. Voer een getal in.")
        elif model_naam not in models:
            print(f"[ERROR] Gekozen model '{model_naam}' niet gevonden. Beschikbare modellen: {models}", file=sys.stderr)
            sys.exit(1)
        print(f"[INFO] Gebruik model: {model_naam}", file=sys.stderr)
        categoriseer_cli(model_naam)
    elif args.command == "check":
        check_and_clean_categories()
    else:
        # Default: run categorize (with prompt) and then check
        print("[INFO] Geen subcommando opgegeven. Eerst categoriseren, daarna controleren.")
        models = get_ollama_models()
        if not models:
            print("[ERROR] Geen Ollama-modellen gevonden. Installeer of start Ollama.", file=sys.stderr)
            sys.exit(1)
        print("Beschikbare modellen:")
        for i, m in enumerate(models, 1):
            print(f"  {i}. {m}")
        while True:
            try:
                keuze = input(f"Kies een model (1-{len(models)}): ").strip()
                idx = int(keuze) - 1
                if 0 <= idx < len(models):
                    model_naam = models[idx]
                    break
                else:
                    print(f"Voer een getal in tussen 1 en {len(models)}.")
            except ValueError:
                print("Ongeldige invoer. Voer een getal in.")
        print(f"[INFO] Gebruik model: {model_naam}", file=sys.stderr)
        categoriseer_cli(model_naam)
        print("[INFO] Start controle van categorieën...")
        check_and_clean_categories()

if __name__ == "__main__":
    main() 