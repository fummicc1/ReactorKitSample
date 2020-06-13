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
}

class AppReactor: Reactor {
    var initialState: State = .init()
    var depedency: Dependency = .init()
    
    enum Action {
        case didTapAddModelButton(title: String, content: String)
        case pullToRefresh
        case fetchLatestData
    }
    
    enum Mutation {
        case fetchModelsState(LoadingState)
        case addModelState(LoadingState)
        case setModels([Model.Response])
        case setEmptyState(Bool)
    }
    
    struct State {
        var isLoading: Bool = false
        var models: [Model.Response] = []
        var isEmpty: Bool = false
    }
    
    // Action -> Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapAddModelButton(let title, let content):
            let model = Model.Request(title: title, content: content)
            return Observable.concat([
                Observable.just(Mutation.addModelState(.progress)),
                self.depedency.server.create(model: model).materialize()
                    .map ({ event in
                        if let error = event.error {
                            return Mutation.addModelState(.fail(error))
                        }
                        return Mutation.addModelState(.complete)
                    })
                    .do(onNext: { mutation in
                        self.action.onNext(.fetchLatestData)
                    })
            ])
            
        case .pullToRefresh, .fetchLatestData:
            return depedency.server.get().map { Mutation.setModels($0) }
        }
    }
    
    private func fetchModels() -> Observable<Mutation> {
        depedency.server.get().map { Mutation.setModels($0) }
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
