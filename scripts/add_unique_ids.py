#!/usr/bin/env python3
"""
Script to add unique IDs to every question in the questions-nl-sv.json file.
"""

import json
import os

def add_unique_ids_to_questions(file_path):
    """
    Adds a unique sequential ID to each question in the JSON file if it doesn't already have one.
    """
    # Read the existing JSON file
    with open(file_path, 'r', encoding='utf-8') as file:
        questions = json.load(file)
    
    print(f"Processing {len(questions)} questions...")
    
    # Add sequential ID to each question that doesn't already have one
    for i, question in enumerate(questions):
        if 'id' not in question:
            # Generate a sequential ID starting from 000001
            question['id'] = f"{i+1:06d}"
            print(f"Added ID {question['id']} to question {i+1}: {question['vraag'][:50]}...")
        else:
            # If the question already has an ID, we'll keep it but make sure it's formatted as 6 digits
            if not isinstance(question['id'], str) or not question['id'].isdigit() or len(question['id']) != 6:
                # If the existing ID is not in the proper format, replace it with the sequential one
                question['id'] = f"{i+1:06d}"
                print(f"Replaced ID with sequential ID {question['id']} for question {i+1}: {question['vraag'][:50]}...")
            else:
                print(f"Question {i+1} already has proper ID: {question['id']}")
    
    # Write the updated JSON back to the file
    with open(file_path, 'w', encoding='utf-8') as file:
        json.dump(questions, file, indent=2, ensure_ascii=False)
    
    print(f"Successfully updated {len(questions)} questions with unique sequential IDs.")

def main():
    # Define the path to the questions file
    file_path = os.path.join(os.path.dirname(__file__), '..', 'app', 'assets', 'questions-nl-sv.json')
    
    # Check if the file exists
    if not os.path.exists(file_path):
        print(f"Error: File not found: {file_path}")
        return
    
    # Add unique IDs to the questions
    add_unique_ids_to_questions(file_path)
    
    print("All questions now have unique IDs!")

if __name__ == "__main__":
    main()