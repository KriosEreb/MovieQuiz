//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Артем Бобриков on 29.04.2026.
//


import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterThan(_ anotherGameResult: GameResult) -> Bool {
        if total == 0 || anotherGameResult.total == 0 {
            return true
        }
        let currentAcurracy = Double(correct) / Double(total)
        let anotherAcurracy = Double(anotherGameResult.correct) / Double(anotherGameResult.total)
        
        return currentAcurracy >= anotherAcurracy
    }
}
