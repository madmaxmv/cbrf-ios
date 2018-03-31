//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxFeedback
import RxDataSources
import RxOptional

class СurreniesViewController: UIViewController, UITableViewDelegate, DataDrivenView {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableViewAutomaticDimension
        
        return tableView
    }()
    
    lazy var cancelItem: UIBarButtonItem = {
        let item = UIBarButtonItem()
        item.tintColor = .mainText
        item.title = "Cancel"
        item.style = .plain
        return item
    }()
    
    lazy var doneItem: UIBarButtonItem = {
        let item = UIBarButtonItem()
        item.tintColor = .mainText
        item.title = "Done"
        item.style = .done
        return item
    }()
    
    var dataSource: RxTableViewSectionedAnimatedDataSource<RatesTableSection>!
    var state: Driver<CurrenciesViewState>!
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = cancelItem
        navigationItem.rightBarButtonItem = doneItem
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor)
            ])
    }
    
    func subscribe(to stateStore: AppStateStore) {
        
        // State
        state = stateStore
            .stateBus
            .map { $0.rates.edit?.viewState }
            .filterNil()
            .distinctUntilChanged()
        
        // Events
        cancelItem.rx.tap
            .map { .rates(.cancelEditing) }
            .bind(to: stateStore.eventBus)
            .disposed(by: bag)

        doneItem.rx.tap
            .map { .rates(.edit(.saveChanges)) }
            .bind(to: stateStore.eventBus)
            .disposed(by: bag)
    }
}
