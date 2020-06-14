//
//  ViewController.swift
//  ReactorKitSample
//
//  Created by Fumiya Tanaka on 2020/06/13.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import UIKit
import ReactorKit
import RxCocoa

class ViewController: UIViewController, StoryboardView {
    
    @IBOutlet weak var tableView: UITableView!
    
    var disposeBag: DisposeBag = .init()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        reactor = AppReactor()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        reactor = AppReactor()
    }
    
    override func viewDidLoad() {
        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        super.viewDidLoad()
    }
    
    func bind(reactor: AppReactor) {
        // Output
        reactor.state.compactMap { $0.error }.flatMap {
            Alert().create(title: "エラー", message: "\($0)", style: .alert, actions: [AlertAction(title: "閉じる")])
        }.map { $0.alert }.subscribe(onNext: { [weak self] alert in
            _ = self?.present(viewController: alert, animated: true)
        }).disposed(by: disposeBag)
        
        reactor.state.map { $0.isEmpty }.bind(to: tableView.rx.isHidden).disposed(by: disposeBag)
        reactor.state.map { $0.models }.bind(to: tableView.rx.items(cellIdentifier: "Cell")) { tableView, model, cell in
            cell.textLabel?.text = model.title
            cell.detailTextLabel?.text = model.content
        }.disposed(by: disposeBag)
        if let refreshControl = tableView.refreshControl {
            reactor.state.map { $0.isLoading }.bind(to: refreshControl.rx.isRefreshing).disposed(by: disposeBag)
        }
        
        
        // Input
        if let refreshControl = tableView.refreshControl {
            refreshControl.rx.controlEvent(.valueChanged).map { AppReactor.Action.pullToRefresh }.bind(to: reactor.action).disposed(by: disposeBag)
        }
        navigationItem.rightBarButtonItem?.rx.tap.map { AppReactor.Action.didTapAddModelButton(title: "Title", content: UUID().uuidString) }.bind(to: reactor.action).disposed(by: disposeBag)
        
        self.rx.sentMessage(#selector(viewDidAppear(_:))).map { _ in AppReactor.Action.fetchLatestData }.bind(to: reactor.action).disposed(by: disposeBag)
    }
}

extension ViewController: RouterType { }
