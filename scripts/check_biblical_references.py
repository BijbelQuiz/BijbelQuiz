#!/usr/bin/env python3
"""
Simple Biblical reference checker - lists only failing question IDs and book names
"""

import json
import urllib.request
import urllib.parse
import urllib.error
import re
import time
from typing import List, Dict, Set, Tuple, Optional


class SimpleBiblicalChecker:
    """Simple checker that outputs only failing references."""
    
    # API Base URL (same as AppUrls.bibleApiBase)
    API_BASE = "https://www.online-bijbel.nl/api.php"
    
    # Book mapping (same as BibleBookMapper._bookNameToNumber but as Python dict)
    BOOK_NAME_TO_NUMBER = {
        # Old Testament
        'Genesis': 1, 'Exodus': 2, 'Leviticus': 3, 'Numeri': 4, 'Deuteronomium': 5,
        'Jozua': 6, 'Richteren': 7, 'Ruth': 8, '1 Samuël': 9, '2 Samuël': 10,
        '1 Koningen': 11, '2 Koningen': 12, '1 Kronieken': 13, '2 Kronieken': 14,
        'Ezra': 15, 'Nehemia': 16, 'Esther': 17, 'Job': 18, 'Psalmen': 19,
        'Spreuken': 20, 'Prediker': 21, 'Hooglied': 22, 'Jesaja': 23, 'Jeremia': 24,
        'Klaagliederen': 25, 'Ezechiël': 26, 'Daniël': 27, 'Hosea': 28, 'Joël': 29,
        'Amos': 30, 'Obadja': 31, 'Jona': 32, 'Micha': 33, 'Nahum': 34,
        'Habakuk': 35, 'Sefanja': 36, 'Haggai': 37, 'Zacharia': 38, 'Maleachi': 39,
        
        # New Testament
        'Nieuwe testament': 40, 'Mattheüs': 41, 'Markus': 42, 'Lukas': 43, 'Johannes': 44,
        'Handelingen': 45, 'Romeinen': 46, '1 Korintiërs': 47, '2 Korintiërs': 48, 'Galaten': 49,
        'Efeziërs': 50, 'Filippenzen': 51, 'Kolossenzen': 52, '1 Tessalonicenzen': 53,
        '2 Tessalonicenzen': 54, '1 Timotheüs': 55, '2 Timotheüs': 56, 'Titus': 57,
        'Filemon': 58, 'Hebreeën': 59, 'Jakobus': 60, '1 Petrus': 61, '2 Petrus': 62,
        '1 Johannes': 63, '2 Johannes': 64, '3 Johannes': 65, 'Judas': 66, 'Openbaring': 67,
    }
    
    def normalize_book_name(self, book_name: str) -> str:
        """Normalize book name the same way as BibleBookMapper._normalizeBookName."""
        normalized = book_name.strip() \
            .replace('ë', 'e').replace('ï', 'i').replace('é', 'e').replace('è', 'e').replace('ê', 'e') \
            .replace('â', 'a').replace('ô', 'o').replace('û', 'u').replace('î', 'i') \
            .replace('ä', 'a').replace('ö', 'o').replace('ü', 'u').replace('ÿ', 'y').replace('ç', 'c')
        
        # Remove any remaining special characters
        normalized = re.sub(r'[^\w\s]', '', normalized).strip()
        return normalized
    
    def parse_reference(self, reference: str) -> Optional[Dict]:
        """Parse reference using the same logic as _parseReference in biblical_reference_dialog.dart."""
        if not reference or not reference.strip():
            return None
        
        reference = reference.strip()
        
        # Special case for "book chapter en chapter" format
        if ' en ' in reference:
            parts = reference.split(' en ')
            if len(parts) == 2:
                first_part = parts[0].strip()
                second_part = parts[1].strip()
                
                # Parse first reference
                first_match = re.match(r'(\w+)\s+(\d+)', first_part)
                if first_match:
                    book = first_match.group(1)
                    chapter = int(first_match.group(2))
                    
                    # Parse second reference
                    second_match = re.match(r'(\d+)', second_part)
                    if second_match:
                        # For "book chapter en chapter" format, treat as single chapter reference
                        return {
                            'book': book,
                            'chapter': chapter,
                            'startVerse': None,
                            'endVerse': None,
                        }
        
        # Standard parsing for "Book chapter:verse" format
        parts = reference.split(' ')
        if len(parts) < 2:
            # Handle single word references like "Psalmen"
            normalized_book = self.normalize_book_name(reference)
            if normalized_book in self.BOOK_NAME_TO_NUMBER:
                return {
                    'book': reference,
                    'chapter': 1,
                    'startVerse': None,
                    'endVerse': None,
                }
            return None
        
        # Extract book name (everything except the last part)
        book = ' '.join(parts[:-1])
        chapter_and_verses = parts[-1]
        
        # Split chapter and verses by colon
        chapter_verse_parts = chapter_and_verses.split(':')
        
        if not chapter_verse_parts:
            return None
        
        chapter = int(chapter_verse_parts[0]) if chapter_verse_parts[0].isdigit() else None
        if not chapter:
            return None
        
        start_verse = None
        end_verse = None
        
        if len(chapter_verse_parts) > 1:
            # Has verse information
            verse_part = chapter_verse_parts[1]
            if '-' in verse_part:
                # Range of verses
                verse_range = verse_part.split('-')
                if len(verse_range) == 2:
                    start_verse = int(verse_range[0]) if verse_range[0].strip().isdigit() else None
                    end_verse = int(verse_range[1]) if verse_range[1].strip().isdigit() else None
            else:
                # Single verse
                start_verse = int(verse_part.strip()) if verse_part.strip().isdigit() else None
        
        return {
            'book': book,
            'chapter': chapter,
            'startVerse': start_verse,
            'endVerse': end_verse,
        }
    
    def check_reference(self, question_id: str, reference: str) -> bool:
        """Check if a reference works - return True if it works, False if it fails."""
        if not reference or not reference.strip():
            return True  # Empty references are valid
        
        # Parse the reference
        parsed = self.parse_reference(reference)
        if not parsed:
            return False
        
        book = parsed['book']
        
        # Normalize book name and get book number
        normalized_book = self.normalize_book_name(book)
        book_number = self.BOOK_NAME_TO_NUMBER.get(normalized_book)
        
        if not book_number:
            # Try alternative normalizations
            for normalized, number in self.BOOK_NAME_TO_NUMBER.items():
                if self.normalize_book_name(normalized) == normalized_book or \
                   self.normalize_book_name(book) == normalized:
                    book_number = number
                    break
        
        return book_number is not None
    
    def check_questions_file(self, file_path: str, max_checks: int = 100) -> List[Tuple[str, str]]:
        """Check references and return list of (question_id, book_name) for failing ones."""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                questions = json.load(f)
        except FileNotFoundError:
            raise Exception(f"File not found: {file_path}")
        except json.JSONDecodeError as e:
            raise Exception(f"Invalid JSON in {file_path}: {e}")
        
        failing = []
        checked = 0
        
        for question in questions:
            question_id = question.get('id', 'unknown')
            reference = question.get('biblicalReference')
            
            if not self.check_reference(question_id, reference):
                # Extract book name for reporting
                if reference and reference.strip():
                    parsed = self.parse_reference(reference)
                    if parsed:
                        book = parsed['book']
                        failing.append((question_id, book))
            
            checked += 1
            if checked >= max_checks:
                break
        
        return failing


def main():
    """Main function to check references and output failing ones."""
    import sys
    
    file_path = "app/assets/questions-nl-sv.json"
    max_checks = 100
    
    if len(sys.argv) > 1:
        file_path = sys.argv[1]
    if len(sys.argv) > 2:
        try:
            max_checks = int(sys.argv[2])
        except ValueError:
            print(f"Invalid max_checks argument: {sys.argv[2]}")
            sys.exit(1)
    
    checker = SimpleBiblicalChecker()
    
    try:
        failing = checker.check_questions_file(file_path, max_checks)
        
        # Output only the failing references
        for question_id, book_name in failing:
            print(f"{question_id}: {book_name}")
        
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()