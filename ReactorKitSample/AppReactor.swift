//
//  AppReactor.swift
//  ReactorKitSample
//
//  Created by Fumiya Tanaka on 2020/06/13.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation
import ReactorKit

class AppReactor: Reactor {
    var initialState: State = .init()
    
    enum Action {
        case didTapAddModelButton(title: String, content: String)
        case pullToRefresh
    }
    
    enum Mutation {
        case setModels([Model.Response])
    }
    
    struct State {
        var models: [Model.Response] = []
    }
}
