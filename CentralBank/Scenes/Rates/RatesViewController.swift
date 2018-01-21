//
//  ExchangeRatesViewController.swift
//  CentralBank
//
//  Created by Максим on 20/01/2018.
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import RxSwift
import RxCocoa
import RxFeedback
import RxDataSources
import RxOptional

class RatesViewController: UIViewController, ViewType {
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: RxTableViewSectionedAnimatedDataSource<RatesTableSection>!
    var state: Driver<RatesViewState>!
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 72
        tableView.register(RateCell.self)

        dataSource = RxTableViewSectionedAnimatedDataSource<RatesTableSection>(configureCell:
            { _, tableView, indexPath, item in
                switch item {
                case .rate(let state):
                    let cell: RateCell = tableView.dequeueReusableCell(for: indexPath)
                    cell.setup(with: state)
                    return cell
                }
        })

        tableView.rx
            .setDelegate(self)
            .disposed(by: bag)
    }
 
    func subscribe(to stateStore: AppStateStore) {
        
        // State
        state = stateStore
            .stateBus
            .map { $0.rates.viewState }
            .distinctUntilChanged()
        
        // UI
     
        state
            .map { $0.content }
            .distinctUntilChanged { $0 == $1 }
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)

    }
}

extension RatesViewController: UITableViewDelegate {}
