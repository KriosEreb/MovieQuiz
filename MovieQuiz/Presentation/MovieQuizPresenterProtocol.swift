//
//  MovieQuizPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Артем Бобриков on 14.05.2026.
//


import Foundation

protocol MovieQuizPresenterProtocol {
    func loadData()
    func didAnswer(_ givenAnswer: Bool)
    func restartQuiz()
}
