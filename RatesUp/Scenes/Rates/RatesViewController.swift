//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxOptional
import RxDataSources

class RatesViewController: UIViewController, UITableViewDelegate {
    private var tableView: UITableView = {
        $0.separatorStyle = .none
        $0.backgroundColor = .background
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.estimatedRowHeight = 72
        $0.rowHeight = UITableView.automaticDimension

        $0.register(RateCell.self)
        return $0
    }(UITableView())

    lazy var editItem: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "Edit", style: .plain, target: nil, action: nil)
        item.tintColor = .mainText
        return item
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.tintColor = .activity
        return control
    }()
    
    private var dataSource: RxTableViewSectionedAnimatedDataSource<RatesTableSection>!
    private var state: Driver<RatesViewState>!
    private let bag = DisposeBag()
    
    init(store: AppStore) {
        super.init(nibName: nil, bundle: nil)
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = editItem

        tableView.addSubview(refreshControl)

        dataSource = RxTableViewSectionedAnimatedDataSource<RatesTableSection>(configureCell:
            { _, tableView, indexPath, item in
                switch item {
                case .rate(let state):
                    let cell: RateCell = tableView.dequeueCell(for: indexPath)
                    cell.setup(with: state)
                    return cell
                }
        })

        tableView.rx
            .setDelegate(self)
            .disposed(by: bag)
    }
 
//    func subscribe(to stateStore: AppStateStore) {
//
//        // State
//        state = stateStore
//            .stateBus
//            .map { $0.rates.viewState }
//            .distinctUntilChanged()
//
//        // UI
//        state
//            .map { $0.content }
//            .distinctUntilChanged { $0 == $1 }
//            .drive(tableView.rx.items(dataSource: dataSource))
//            .disposed(by: bag)
//
//        state.map { $0.isLoading }
//            .distinctUntilChanged()
//            .drive(refreshControl.rx.isRefreshing)
//            .disposed(by: bag)
//
//        // Events
//        refreshControl.rx
//            .controlEvent(.valueChanged)
//            .map { .rates(.refreshRates) }
//            .bind(to: stateStore.eventBus)
//            .disposed(by: bag)
//
//        editItem.rx.tap
//            .map { .rates(.openEditMode) }
//            .bind(to: stateStore.eventBus)
//            .disposed(by: bag)
//    }
}
