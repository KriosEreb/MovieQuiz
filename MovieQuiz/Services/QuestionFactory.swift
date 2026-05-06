//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Артем Бобриков on 28.04.2026.
//

import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    private let moviesLoader: MoviesLoading
    private weak var delegate: QuestionFactoryDelegate?
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    private var movies: [MostPopularMovie] = []
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            guard let movie = self.getRandomMovie() else { return }
            
            let imageData = self.loadImageData(from: movie.resizedImageURL)
            let question = self.makeQuestion(for: movie, imageData: imageData)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
    
    private func getRandomMovie() -> MostPopularMovie? {
        let index = (0..<movies.count).randomElement() ?? 0
        return movies[safe: index]
    }
    
    private func loadImageData(from url: URL) -> Data {
        do {
            return try Data(contentsOf: url)
        } catch {
            print("Failed to load image")
            return Data()
        }
    }
    
    private func makeQuestion(for movie: MostPopularMovie, imageData: Data) -> QuizQuestion {
        let rating = Float(movie.rating) ?? 0
        let comparisonRating = Float.random(in: 8.3...9.2)
        let roundedComparisonRating = (comparisonRating * 10).rounded() / 10
        let isGreaterQuestion = Bool.random()
        
        let text: String
        let correctAnswer: Bool
        
        if isGreaterQuestion {
            text = "Рейтинг этого фильма больше, чем \(roundedComparisonRating)?"
            correctAnswer = rating > roundedComparisonRating
        } else {
            text = "Рейтинг этого фильма меньше, чем \(roundedComparisonRating)?"
            correctAnswer = rating < roundedComparisonRating
        }
        
        return QuizQuestion(image: imageData,
                            text: text,
                            correctAnswer: correctAnswer)
    }
}

//    private let questions: [QuizQuestion] = [
//        QuizQuestion(
//            imageName: "The Godfather",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: true),
//        QuizQuestion(
//            imageName: "The Dark Knight",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: true),
//        QuizQuestion(
//            imageName: "Kill Bill",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: true),
//        QuizQuestion(
//            imageName: "The Avengers",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: true),
//        QuizQuestion(
//            imageName: "Deadpool",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: true),
//        QuizQuestion(
//            imageName: "The Green Knight",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: true),
//        QuizQuestion(
//            imageName: "Old",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: false),
//        QuizQuestion(
//            imageName: "The Ice Age Adventures of Buck Wild",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: false),
//        QuizQuestion(
//            imageName: "Tesla",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: false),
//        QuizQuestion(
//            imageName: "Vivarium",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: false)
//    ]

