//
//  WordCombination.swift
//  TranslateTestApp


import Foundation


struct WordCombination: Decodable {
    let id: Int
    let text: String
    let meanings: [Meaming]
}

struct Meaming: Decodable {
    let id: Int
    let translation: Translation
    let imageUrl: String
    let transcription: String?
}

struct Translation: Decodable {
    let text: String
    let note: String?
}
