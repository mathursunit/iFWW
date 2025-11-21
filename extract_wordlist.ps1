$content = Get-Content 'index.html' -Raw
$pattern = 'const WORD_CSV = "([^"]+)"'
if ($content -match $pattern) {
    $wordList = $matches[1]
    $swiftContent = @"
//
//  WordListData.swift
//  SunSar
//
//  Word list data
//

import Foundation

struct WordListData {
    static let wordCSV = """
$wordList
"""
}
"@
    
    if (-not (Test-Path 'Data')) {
        New-Item -ItemType Directory -Path 'Data' | Out-Null
    }
    
    Set-Content -Path 'Data/WordListData.swift' -Value $swiftContent -Encoding UTF8
    Write-Host "Word list extracted successfully!"
} else {
    Write-Host "Could not find WORD_CSV"
}

