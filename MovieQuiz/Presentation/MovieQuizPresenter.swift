//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Артем Бобриков on 14.05.2026.
//

import Foundation

final class MovieQuizPresenter: MovieQuizPresenterProtocol, QuestionFactoryDelegate {
    // MARK: - Constants
    private let questionsAmount: Int = 10
    
    // MARK: - State
    private var currentQuestionIndex: Int = 0
    private var isAnswerProcessing: Bool = false
    private var currentQuestion: QuizQuestion?
    private var correctAnswers: Int = 0
    
    // MARK: - Dependencies
    private weak var view: MovieQuizViewControllerProtocol?
    private var questionFactory: QuestionFactoryProtocol?
    private let statisticService: StatisticServiceProtocol
    
    init(view: MovieQuizViewControllerProtocol, statisticService: StatisticServiceProtocol = StatisticService()) {
        self.view = view
        self.statisticService = statisticService
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
    }
    
    convenience init(viewController: MovieQuizViewControllerProtocol) {
        self.init(view: viewController)
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.isAnswerProcessing = false
            self?.view?.showQuestion(viewModel)
            self?.view?.setAnswerButtonsEnabled(true)
        }
    }
    
    func didLoadDataFromServer() {
        view?.hideLoadingIndicator()
        requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        view?.showNetworkError(message: error.localizedDescription)
    }
    
    func loadData() {
        questionFactory?.loadData()
    }
    
    private func requestNextQuestion() {
        questionFactory?.requestNextQuestion()
    }
    
    private func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func restartQuiz() {
        correctAnswers = 0
        currentQuestionIndex = 0
        requestNextQuestion()
    }
    
    private func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: model.image,
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func didAnswer(_ givenAnswer: Bool) {
        guard !isAnswerProcessing else { return }
        guard let currentQuestion = currentQuestion else { return }
        
        isAnswerProcessing = true
        
        let correctAnswer = currentQuestion.correctAnswer
        showAnswerFeedback(isCorrect: givenAnswer == correctAnswer)
    }
    
    private func proceedToNextStep() {
        if isLastQuestion() {
            statisticService.store(
                correctAnswers: correctAnswers,
                questionsAmount: questionsAmount)
            
            let viewModel = makeQuizResultViewModel()
            view?.showResult(viewModel)
            
        } else {
            switchToNextQuestion()
            
            requestNextQuestion()
        }
    }
    
    private func showAnswerFeedback(isCorrect: Bool) {
        view?.highlightAnswer(isCorrect: isCorrect)
        
        if isCorrect {
            correctAnswers += 1
        }
        
        view?.setAnswerButtonsEnabled(false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {[weak self] in
            guard let self = self else { return }
            
            proceedToNextStep()
        }
    }
    
    private func makeQuizResultViewModel() -> QuizResultViewModel {
        let bestGame = statisticService.bestGame
        let text = """
            Ваш результат: \(correctAnswers)/\(questionsAmount)
            Количество сыгранных квизов: \(statisticService.gamesCount)
            Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))
            Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
        """
        return QuizResultViewModel(
            title: "Этот раунд окончен!",
            text: text,
            buttonText: "Сыграть ещё раз")
    }
}
