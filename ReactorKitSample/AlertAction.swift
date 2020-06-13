//
//  AlertAction.swift
//  ReactorKitSample
//
//  Created by Fumiya Tanaka on 2020/06/13.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

protocol AlertActionType {
    var title: String { get }
        var style: UIAlertAction.Style { get }
}

extension AlertActionType {
    var style: UIAlertAction.Style {
        .default
    }
}

protocol AlertType {
    func show(title: String?, message: String?, style: UIAlertController.Style, actions: [AlertActionType]) -> Observable<AlertActionType>
}

class Alert: AlertType {
    func show(title: String?, message: String?, style: UIAlertController.Style, actions: [AlertActionType]) -> Observable<AlertActionType> {
        Observable<AlertActionType>.create { observer -> Disposable in
            let alert = UIAlertController(title: title, message: message, preferredStyle: style)
            for action in actions {
                let alertAction = UIAlertAction(title: action.title, style: action.style) { _ in
                    observer.onNext(action)
                }
                alert.addAction(alertAction)
            }
            
            return Disposables.create()
        }
    }
}
