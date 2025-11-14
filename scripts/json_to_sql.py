#!/usr/bin/env python3
"""
Script to convert the questions JSON file to SQL INSERT statements for Supabase.
This script reads the questions-nl-sv.json file and generates SQL statements
to populate the questions table.
"""

import json
import sys
from pathlib import Path

def escape_sql_string(s):
    """Escape single quotes for SQL"""
    if s is None:
        return 'NULL'
    return f"'{s.replace(chr(39), chr(39) + chr(39))}'"

def array_to_sql(arr):
    """Convert Python array to PostgreSQL array syntax"""
    if not arr:
        return "'{}'"
    escaped_items = [f"'{item.replace(chr(39), chr(39) + chr(39))}'" for item in arr]
    return f"ARRAY[{','.join(escaped_items)}]"

def main():
    # Path to the questions JSON file
    json_path = Path(__file__).parent.parent / "app" / "assets" / "questions-nl-sv.json"

    if not json_path.exists():
        print(f"Error: Questions JSON file not found at {json_path}")
        sys.exit(1)

    try:
        with open(json_path, 'r', encoding='utf-8') as f:
            questions = json.load(f)
    except Exception as e:
        print(f"Error reading JSON file: {e}")
        sys.exit(1)

    print("-- SQL INSERT statements for questions table")
    print("-- Generated from questions-nl-sv.json")
    print()

    for question in questions:
        # Extract fields
        question_id = escape_sql_string(question.get('id', ''))
        vraag = escape_sql_string(question.get('vraag', ''))
        juiste_antwoord = escape_sql_string(question.get('juisteAntwoord', ''))
        foute_antwoorden = array_to_sql(question.get('fouteAntwoorden', []))
        moeilijkheidsgraad = question.get('moeilijkheidsgraad', 3)
        question_type = escape_sql_string(question.get('type', 'mc'))
        categories = array_to_sql(question.get('categories', []))
        biblical_reference = escape_sql_string(question.get('biblicalReference'))

        # Generate INSERT statement
        sql = f"""INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ({question_id}, {vraag}, {juiste_antwoord}, {foute_antwoorden}, {moeilijkheidsgraad}, {question_type}, {categories}, {biblical_reference})
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();"""

        print(sql)
        print()

    print(f"-- Total questions processed: {len(questions)}")

if __name__ == "__main__":
    main()