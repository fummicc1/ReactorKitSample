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
    func create(title: String?, message: String?, style: UIAlertController.Style, actions: [AlertActionType]) -> Observable<(alert: UIAlertController, tapAction: AlertActionType?)>
}

class Alert: AlertType {
    func create(title: String?, message: String?, style: UIAlertController.Style, actions: [AlertActionType]) -> Observable<(alert: UIAlertController, tapAction: AlertActionType?)> {
        Observable.create { observer -> Disposable in
            let alert = UIAlertController(title: title, message: message, preferredStyle: style)
            for action in actions {
                let alertAction = UIAlertAction(title: action.title, style: action.style) { _ in
                    observer.onNext((alert, action))
                }
                alert.addAction(alertAction)
            }
            observer.onNext((alert, nil))
            return Disposables.create()
        }
    }
}

class AlertAction: AlertActionType {
    var title: String
    var style: UIAlertAction.Style
    
    init(title: String, style: UIAlertAction.Style = .default) {
        self.title = title
        self.style = style
    }
}
