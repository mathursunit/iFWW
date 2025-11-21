const fs = require('fs');

const html = fs.readFileSync('index.html', 'utf8');
const match = html.match(/const WORD_CSV = "([^"]+)"/s);

if (match) {
    const wordList = match[1];
    const swiftContent = `//
//  WordListData.swift
//  SunSar
//
//  Word list data
//

import Foundation

struct WordListData {
    static let wordCSV = """
${wordList}
"""
}
`;
    
    if (!fs.existsSync('Data')) {
        fs.mkdirSync('Data');
    }
    
    fs.writeFileSync('Data/WordListData.swift', swiftContent, 'utf8');
    console.log('Word list extracted successfully!');
} else {
    console.log('Could not find WORD_CSV in index.html');
}

