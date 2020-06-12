//
//  ViewController.swift
//  ReactorKitSample
//
//  Created by Fumiya Tanaka on 2020/06/13.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import UIKit
import ReactorKit

class ViewController: UIViewController, StoryboardView {
    var disposeBag: DisposeBag = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        reactor = AppReactor()
    }

    func bind(reactor: AppReactor) {
        
    }
}

