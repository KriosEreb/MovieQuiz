//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Артем Бобриков on 14.05.2026.
//

import Foundation

final class MovieQuizPresenter: QuestionFactoryDelegate {
    // MARK: - Constants
    let questionsAmount: Int = 10
    
    // MARK: - State
    private var currentQuestionIndex: Int = 0
    var isAnswerProcessing: Bool = false
    private var currentQuestion: QuizQuestion?
    var correctAnswers: Int = 0
    
    // MARK: - Dependencies
    weak var viewController: MovieQuizViewController?
    private lazy var questionFactory: QuestionFactoryProtocol = QuestionFactory(
        moviesLoader: MoviesLoader(),
        delegate: self)
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        viewController?.showNetworkError(message: error.localizedDescription)
    }
    
    func loadData() {
        questionFactory.loadData()
    }
    
    func requestNextQuestion() {
        questionFactory.requestNextQuestion()
    }
    
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
        guard let currentQuestion = currentQuestion else { return }
        
        isAnswerProcessing = true
        
        let correctAnswer = currentQuestion.correctAnswer
        viewController?.showAnswerResult(isCorrect: givenAnswer == correctAnswer)
    }
    
    func showNextQuestionOrResult() {
        if isLastQuestion() {
            viewController?.statisticService.store(
                correctAnswers: correctAnswers,
                questionsAmount: questionsAmount)
            
            guard let viewModel = viewController?.makeQuizResultViewModel() else { return }
            viewController?.show(quiz: viewModel)
            
        } else {
            switchToNextQuestion()
            
            requestNextQuestion()
        }
    }
}
