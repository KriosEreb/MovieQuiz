//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Артем Бобриков on 06.05.2026.
//


import Foundation

struct NetworkClient {
    
    private enum NetworkError: Error {
        case invalidResponse
        case invalidStatusCode
        case emptyData
    }
    
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                handler(.failure(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                handler(.failure(NetworkError.invalidResponse))
                return
            }
            
            guard 200..<300 ~= response.statusCode else {
                handler(.failure(NetworkError.invalidStatusCode))
                return
            }
            
            guard let data = data else {
                handler(.failure(NetworkError.emptyData))
                return
            }
            
            handler(.success(data))
        }
        
        task.resume()
    }
}
