//
//  DAO.swift
//  ReactorKitSample
//
//  Created by Fumiya Tanaka on 2020/06/13.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation
import RxSwift

protocol DAO {
    func create(model: Model.Request) -> Observable<Void>
    func get() -> Observable<[[Model.Response]]>
}
