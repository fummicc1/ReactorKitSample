//
//  AppReactor.swift
//  ReactorKitSample
//
//  Created by Fumiya Tanaka on 2020/06/13.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation
import ReactorKit
import UIKit

enum LoadingState {
    case progress
    case complete
    case fail(Error)
    case idel
    
    var isLoading: Bool {
        switch self {
        case .complete, .fail, .idel:
            return false
        case .progress:
            return true
        }
    }
}

class AppReactor: Reactor {
    var initialState: State = .init()
    var depedency: Dependency = .init(server: MockServer())
    
    enum Action {
        case didTapAddModelButton(title: String, content: String)
        case pullToRefresh
        case fetchLatestData
    }
    
    enum Mutation {
        case loadingState(LoadingState)
        case setModels([Model.Response])
    }
    
    struct State {
        var isLoading: Bool = false
        var error: Error?
        var models: [Model.Response] = []
        var isEmpty: Bool {
            models.isEmpty
        }
    }
    
    // Action -> Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapAddModelButton(let title, let content):
            let model = Model.Request(title: title, content: content)
            return Observable.concat([
                Observable.just(Mutation.loadingState(.progress)),
                self.depedency.server.create(model: model).materialize()
                    .map ({ event in
                        if let error = event.error {
                            return Mutation.loadingState(.fail(error))
                        }
                        return Mutation.loadingState(.complete)
                    })
                    .do(onNext: { mutation in
                        self.action.onNext(.fetchLatestData)
                    })
            ])
            
        case .pullToRefresh, .fetchLatestData:
            return fetchModels()
        }
    }
    
    private func fetchModels() -> Observable<Mutation> {
        Observable.concat([
            Observable.just(Mutation.loadingState(.progress)),
            depedency.server.get().materialize().map ({ event in
                if let error = event.error {
                    return Mutation.loadingState(.fail(error))
                }
                if let element = event.element {
                    return Mutation.setModels(element)
                }
                return Mutation.loadingState(.complete)
            }),
        ])
    }
    
    // Mutation -> State
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        state.error = nil
        switch mutation {
        case .loadingState(let loadingState):
            state.isLoading = loadingState.isLoading
            if case LoadingState.fail(let error) = loadingState {
                state.error = error
            }
            
        case .setModels(let models):
            state.models = models
        }
        return state
    }
}

extension AppReactor {
    struct Dependency {
        let server: DAO
        
        init(server: DAO = Server.shared) {
            self.server = server
        }
    }
}
