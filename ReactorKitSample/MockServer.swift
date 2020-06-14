//
//  MockServer.swift
//  ReactorKitSample
//
//  Created by Fumiya Tanaka on 2020/06/14.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation
import RxSwift

class MockServer: DAO {
    
    private var data: [Model.Response] = []
    
    func create(model: Model.Request) -> Observable<Void> {
        let curret = Date()
        let formatter = ISO8601DateFormatter()
        let response = Model.Response.init(id: data.count, title: model.title, content: model.content, due: formatter.string(from: curret))
        data.append(response)
        return Observable.just(())
    }
    
    func get() -> Observable<[Model.Response]> {
        Observable.just(data)
    }
}
