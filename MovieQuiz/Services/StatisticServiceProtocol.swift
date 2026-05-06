//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Артем Бобриков on 29.04.2026.
//


import Foundation

protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(correctAnswers count: Int, questionsAmount amount: Int)
}


