//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Артем Бобриков on 29.04.2026.
//

import Foundation

final class StatisticService: StatisticServiceProtocol {
    private let storage: UserDefaults = .standard
    private enum Keys: String {
        case gamesCount
        case bestGameCorrect
        case bestGameTotal
        case bestGameDate
        case totalCorrectAnswers
        case totalQuestionsAsked
    }
    
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            let correct = storage.integer(
                forKey: Keys.bestGameCorrect.rawValue
            )
            let total = storage.integer(forKey: Keys.bestGameTotal.rawValue)
            let date =
            storage.object(
                forKey: Keys.bestGameDate.rawValue
            ) as? Date ?? Date.now
            
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            storage.set(
                newValue.correct,
                forKey: Keys.bestGameCorrect.rawValue
            )
            storage.set(
                newValue.total,
                forKey: Keys.bestGameTotal.rawValue
            )
            storage.set(
                newValue.date,
                forKey: Keys.bestGameDate.rawValue
            )
        }
    }
    
    private var totalCorrectAnswers: Int {
        get {
            storage.integer(forKey: Keys.totalCorrectAnswers.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalCorrectAnswers.rawValue)
        }
    }
    
    private var totalQuestionsAsked: Int {
        get {
            storage.integer(forKey: Keys.totalQuestionsAsked.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalQuestionsAsked.rawValue)
        }
        
    }
    
    var totalAccuracy: Double {
        if totalQuestionsAsked == 0 {
            return 0
        } else {
            return Double(totalCorrectAnswers) / Double(totalQuestionsAsked)
            * 100
        }
    }
    
    func store(correctAnswers count: Int, questionsAmount amount: Int) {
        gamesCount += 1
        
        let currentGameResult = GameResult(
            correct: count,
            total: amount,
            date: .now)
        
        let previousBestGame = bestGame
        
        if currentGameResult.isBetterThan(previousBestGame) {
            bestGame = currentGameResult
        }
        
        totalCorrectAnswers += count
        totalQuestionsAsked += amount
    }
    
}
