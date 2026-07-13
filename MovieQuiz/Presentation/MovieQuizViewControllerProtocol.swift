//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Артем Бобриков on 14.05.2026.
//


import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func showQuestion(_ viewModel: QuizStepViewModel)
    func showResult(_ viewModel: QuizResultViewModel)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
    
    func highlightAnswer(isCorrect: Bool)
    func setAnswerButtonsEnabled(_ isEnabled: Bool)
}
