#!/usr/bin/env python3
"""
Script to convert the questions JSON file to SQL INSERT statements for Supabase.
This script reads the questions-nl-sv.json file and generates SQL statements
to populate the questions table.

The script outputs SQL to a file and uses ON CONFLICT to handle:
- Adding new records if ID doesn't exist
- Updating existing records if ID already exists
"""

import json
import sys
import argparse
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
    parser = argparse.ArgumentParser(description='Convert questions JSON to SQL statements')
    parser.add_argument('--output', '-o', 
                       default='database_supabase/questions_data.sql',
                       help='Output SQL file path (default: database_supabase/questions_data.sql)')
    parser.add_argument('--json-file', '-j',
                       default=None,
                       help='Path to JSON file (default: app/assets/questions-nl-sv.json)')
    
    parser.add_argument('--language', '-l',
                       choices=['nl', 'en'],
                       default='nl',
                       help='Language of the questions (nl or en). Default: nl')
    
    args = parser.parse_args()
    
    # Determine JSON file path
    if args.json_file:
        json_path = Path(args.json_file)
    else:
        if args.language == 'en':
            json_path = Path(__file__).parent.parent / "app" / "assets" / "questions-en.json"
        else:
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

    # Prepare SQL output
    sql_lines = []
    sql_lines.append(f"-- SQL INSERT statements for {args.language} questions table")
    sql_lines.append(f"-- Generated from {json_path.name}")
    sql_lines.append(f"-- Generated on: {Path(__file__).stat().st_mtime}")
    sql_lines.append("")
    
    # Ensure output directory exists
    output_path = Path(args.output)
    output_path.parent.mkdir(parents=True, exist_ok=True)

    table_name = 'questions_en' if args.language == 'en' else 'questions'

    for question in questions:
        # Extract fields based on language
        question_id = escape_sql_string(question.get('id', ''))
        
        if args.language == 'en':
            q_text = escape_sql_string(question.get('question', ''))
            correct = escape_sql_string(question.get('correctAnswer', ''))
            incorrect = array_to_sql(question.get('incorrectAnswers', []))
            difficulty = question.get('difficulty', 3)
            q_type = escape_sql_string(question.get('type', 'mc'))
            categories = array_to_sql(question.get('categories', []))
            bib_ref = escape_sql_string(question.get('biblicalReference'))
            
            # Generate INSERT statement for English
            sql = f"""INSERT INTO {table_name} (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ({question_id}, {q_text}, {correct}, {incorrect}, {difficulty}, {q_type}, {categories}, {bib_ref})
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();"""

        else: # Dutch
            q_text = escape_sql_string(question.get('vraag', ''))
            correct = escape_sql_string(question.get('juisteAntwoord', ''))
            incorrect = array_to_sql(question.get('fouteAntwoorden', []))
            difficulty = question.get('moeilijkheidsgraad', 3)
            q_type = escape_sql_string(question.get('type', 'mc'))
            categories = array_to_sql(question.get('categories', []))
            bib_ref = escape_sql_string(question.get('biblicalReference'))

            # Generate INSERT statement for Dutch
            sql = f"""INSERT INTO {table_name} (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ({question_id}, {q_text}, {correct}, {incorrect}, {difficulty}, {q_type}, {categories}, {bib_ref})
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();"""

        sql_lines.append(sql)
        sql_lines.append("")

    sql_lines.append(f"-- Total questions processed: {len(questions)}")

    # Write SQL to file (overwriting if exists)
    try:
        with open(output_path, 'w', encoding='utf-8') as f:
            f.write('\n'.join(sql_lines))
        print(f"SQL statements successfully written to: {output_path}")
        print(f"Total questions processed: {len(questions)}")
    except Exception as e:
        print(f"Error writing to output file: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()