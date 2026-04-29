//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Артем Бобриков on 29.04.2026.
//


import Foundation

struct AlertModel {
    var title: String
    var message: String
    var buttonText: String
    var completion: () -> Void
}


