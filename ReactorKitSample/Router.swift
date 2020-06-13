//
//  Router.swift
//  ReactorKitSample
//
//  Created by Fumiya Tanaka on 2020/06/13.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

protocol RouterType {
    func present(viewController: UIViewController, animated: Bool) -> Observable<Void>
}

extension RouterType where Self: UIViewController {
    func present(viewController: UIViewController, animated: Bool) -> Observable<Void> {
        Observable<Void>.create { observer -> Disposable in
            self.present(viewController, animated: animated) {
                observer.onNext(())
            }
            return Disposables.create()
        }
    }
}
