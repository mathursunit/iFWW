import re

with open('index.html', 'r', encoding='utf-8') as f:
    content = f.read()

# Find the WORD_CSV constant
match = re.search(r'const WORD_CSV = "([^"]+)"', content, re.DOTALL)
if match:
    word_csv = match.group(1)
    
    # Write to Swift file
    with open('Data/WordListData.swift', 'w', encoding='utf-8') as out:
        out.write('''//
//  WordListData.swift
//  SunSar
//
//  Word list data
//

import Foundation

struct WordListData {
    static let wordCSV = """
''')
        out.write(word_csv)
        out.write('''
"""
}
''')
    print("Word list extracted successfully!")
else:
    print("Could not find WORD_CSV in index.html")

