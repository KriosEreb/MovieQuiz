//
//  MovieQuizPresenterTests.swift
//  MovieQuiz
//
//  Created by Артем Бобриков on 14.05.2026.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func showQuestion(_ viewModel: QuizStepViewModel) {
    }
    
    func showResult(_ viewModel: QuizResultViewModel) {
    }
    
    func highlightAnswer(isCorrect: Bool) {
    }
    
    func showLoadingIndicator() {
    
    }
    
    func hideLoadingIndicator() {
    
    }
    
    func showNetworkError(message: String) {
    
    }
    
    func setAnswerButtonsEnabled(_ isEnabled: Bool) {
    }
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
        XCTAssertEqual(viewModel.image, emptyData)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
