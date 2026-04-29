//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Артем Бобриков on 28.04.2026.
//


protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}