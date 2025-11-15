#!/usr/bin/env python3
"""
Script to update biblical references in questions-nl-sv.json to use normalized book names.
This script maps old biblical book names to the new normalized versions.
"""

import json
import re
from typing import Dict, List, Optional

class BiblicalReferenceUpdater:
    """Updates biblical references to use normalized book names."""
    
    # Mapping from old book names to new normalized names
    BOOK_NAME_MAPPING = {
        # Old Testament corrections
        '1 Samuel': '1 Samuël',
        '2 Samuel': '2 Samuël',
        'Ester': 'Esther',
        'Ezechiel': 'Ezechiël',
        'Daniel': 'Daniël',
        'Joel': 'Joël',
        'Zefanja': 'Sefanja',
        'Hosea': 'Hosea',  # Keep as is, but handle variations
        'Hoséa': 'Hosea',
        'Hábakuk': 'Habakuk',
        'Jeremía': 'Jeremia',
        'Hizkía': 'Hizkia',  # If this exists
        'Maleáchi': 'Maleachi',
        'Nehémia': 'Nehemia',
        'Zacharía': 'Zacharia',
        'Zefánja': 'Sefanja',
        'Éxodus': 'Exodus',
        
        # New Testament corrections
        'Matteus': 'Mattheüs',
        'Marcus': 'Markus',
        '1 Korinthe': '1 Korintiërs',
        '2 Korinthe': '2 Korintiërs',
        'Korinthe': 'Korintiërs',  # For references like "1 en 2 Korinthe"
        '1 Korintiers': '1 Korintiërs',
        '2 Korintiers': '2 Korintiërs',
        'Efeziers': 'Efeziërs',
        'Éfeze': 'Efeziërs',
        '1 Timotheüs': '1 Timotheüs',  # Keep as is, handle variations
        '2 Timotheüs': '2 Timotheüs',
        '1 Timótheüs': '1 Timotheüs',
        '2 Timothéüs': '2 Timotheüs',
        '2 Timótheüs': '2 Timotheüs',
        '1 Timoteus': '1 Timotheüs',
        '2 Timoteus': '2 Timotheüs',
        'Hebreeen': 'Hebreeën',
        'Mattéüs': 'Mattheüs',
        'Matthéus': 'Mattheüs',
        'Matthéüs': 'Mattheüs',
        'Matthéüs  ': 'Mattheüs',  # Handle trailing spaces
        'Markus': 'Markus',  # Keep as is
        
        # Handle "Nieuwe testament" as a special case
        'In de Evangeliën': 'Nieuwe testament',
        'In de evangeliën': 'Nieuwe testament',
        
        # Handle Psalm vs Psalmen
        'Psalm': 'Psalmen',
        
        # Handle "Handelingen" variations (no change needed)
        'Handelingen': 'Handelingen',
    }
    
    def __init__(self):
        """Initialize the updater with reverse mapping for faster lookups."""
        # Create reverse mapping for faster lookups
        self._reverse_mapping = {v: k for k, v in self.BOOK_NAME_MAPPING.items()}
    
    def update_biblical_references(self, questions: List[Dict]) -> List[Dict]:
        """Update all biblical references in the questions list."""
        updated_count = 0
        
        for question in questions:
            if 'biblicalReference' in question and question['biblicalReference']:
                old_reference = question['biblicalReference']
                new_reference = self.update_reference_string(old_reference)
                
                if new_reference != old_reference:
                    question['biblicalReference'] = new_reference
                    updated_count += 1
                    print(f"Updated: {old_reference} → {new_reference}")
        
        return questions, updated_count
    
    def update_reference_string(self, reference: str) -> str:
        """Update a single biblical reference string."""
        if not reference or not reference.strip():
            return reference
        
        # Handle different reference formats:
        # "Book 1:1" -> "Book 1:1"
        # "Book 1:1-3" -> "Book 1:1-3"
        # "Book 1" -> "Book 1"
        # "Book 2 en 3" -> "Book 2 en 3"
        
        reference = reference.strip()
        
        # Special case for "book chapter en chapter" format
        if ' en ' in reference:
            return self._update_en_format_reference(reference)
        
        # Standard format parsing
        parts = reference.split(' ')
        if len(parts) < 2:
            # Single word reference
            return self._update_single_book_name(reference)
        
        # Extract book name (everything except the last part)
        book_name = ' '.join(parts[:-1])
        chapter_and_verses = parts[-1]
        
        # Update the book name
        updated_book_name = self._update_single_book_name(book_name)
        
        # Reconstruct the reference
        if updated_book_name != book_name:
            return f"{updated_book_name} {chapter_and_verses}"
        
        return reference
    
    def _update_en_format_reference(self, reference: str) -> str:
        """Update references with ' en ' format (e.g., "Genesis 1 en 3")."""
        parts = reference.split(' en ')
        if len(parts) == 2:
            first_part = parts[0].strip()
            second_part = parts[1].strip()
            
            # Update book name in first part
            first_match = re.match(r'(\w+(?:\s+\w+)*)\s+(\d+)', first_part)
            if first_match:
                book = first_match.group(1)
                chapter = first_match.group(2)
                
                updated_book = self._update_single_book_name(book)
                if updated_book != book:
                    return f"{updated_book} {chapter} en {second_part}"
        
        return reference
    
    def _update_single_book_name(self, book_name: str) -> str:
        """Update a single book name if it exists in the mapping."""
        # Check for exact match first
        if book_name in self.BOOK_NAME_MAPPING:
            return self.BOOK_NAME_MAPPING[book_name]
        
        # Check case-insensitive match
        book_name_lower = book_name.lower()
        for old_name, new_name in self.BOOK_NAME_MAPPING.items():
            if old_name.lower() == book_name_lower:
                return new_name
        
        # If no match found, return original
        return book_name
    
    def update_json_file(self, file_path: str, backup: bool = True) -> None:
        """Update biblical references in a JSON file."""
        print(f"Loading questions from: {file_path}")
        
        # Load the JSON file
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                questions = json.load(f)
        except FileNotFoundError:
            raise Exception(f"File not found: {file_path}")
        except json.JSONDecodeError as e:
            raise Exception(f"Invalid JSON in {file_path}: {e}")
        
        if not isinstance(questions, list):
            raise Exception("Expected questions to be a list")
        
        print(f"Loaded {len(questions)} questions")
        
        # Create backup if requested
        if backup:
            backup_path = f"{file_path}.backup"
            print(f"Creating backup: {backup_path}")
            with open(backup_path, 'w', encoding='utf-8') as f:
                json.dump(questions, f, ensure_ascii=False, indent=2)
        
        # Update references
        updated_questions, updated_count = self.update_biblical_references(questions)
        
        if updated_count > 0:
            # Write updated questions back to file
            print(f"Writing {len(updated_questions)} updated questions to: {file_path}")
            with open(file_path, 'w', encoding='utf-8') as f:
                json.dump(updated_questions, f, ensure_ascii=False, indent=2)
            
            print(f"✅ Successfully updated {updated_count} biblical references")
        else:
            print("✅ No biblical references needed updating")


def main():
    """Main function to run the biblical reference updater."""
    import sys
    
    file_path = "app/assets/questions-nl-sv.json"
    create_backup = True
    
    # Parse command line arguments
    if len(sys.argv) > 1:
        file_path = sys.argv[1]
    if len(sys.argv) > 2:
        if sys.argv[2].lower() in ['no-backup', 'false', '0']:
            create_backup = False
    
    updater = BiblicalReferenceUpdater()
    
    try:
        updater.update_json_file(file_path, backup=create_backup)
    except Exception as e:
        print(f"❌ Error: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()