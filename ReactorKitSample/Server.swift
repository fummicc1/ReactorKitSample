//
//  Server.swift
//  ReactorKitSample
//
//  Created by Fumiya Tanaka on 2020/06/13.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation
import RxSwift

class Server {
    static let shared: Server = .init()
    
    private let session: URLSession = .shared
    private let baseURL: URL = URL(string: "http://localhost:8080/api/v1/todo")!
}

extension Server: DAO {
    func get() -> Observable<[Model.Response]> {
        Single.create { [weak self] observer -> Disposable in
            guard let self = self else {
                return Disposables.create()
            }
            var request: URLRequest = URLRequest(url: self.baseURL)
            request.httpMethod = "GET"
            self.session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    observer(.error(error))
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    fatalError()
                }
                guard let data = data else {
                    fatalError()
                }
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                guard let todos = try? JSONDecoder().decode([Model.Response].self, from: data) else {
                    fatalError()
                }
                print(todos)
            }.resume()
            return Disposables.create()
        }.asObservable()
    }
    
    func create(model: Model.Request) -> Observable<Void> {
        return Single.create { [unowned self] observer -> Disposable in
            var request: URLRequest = URLRequest(url: self.baseURL)
            request.httpMethod = "POST"
            request.httpBody = try? JSONEncoder().encode(model)
            self.session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    observer(.error(error))
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    fatalError()
                }
                observer(.success(()))
            }.resume()
            return Disposables.create()
        }.asObservable()
    }
}
