//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Артем Бобриков on 14.05.2026.
//

import Foundation

final class MovieQuizPresenter {
    
    let questionsAmount: Int = 10
    
    private var currentQuestionIndex: Int = 0
    var isAnswerProcessing: Bool = false
    
    weak var viewController: MovieQuizViewController?
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: model.image,
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func handleAnswer(_ givenAnswer: Bool) {
        guard !isAnswerProcessing else { return }
        guard let currentQuestion = viewController?.currentQuestion else { return }
        
        isAnswerProcessing = true
        
        let correctAnswer = currentQuestion.correctAnswer
        viewController?.showAnswerResult(isCorrect: givenAnswer == correctAnswer)
    }
}
