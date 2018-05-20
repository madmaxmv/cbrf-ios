//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import RxSwift
import RxCocoa
import RxFeedback
import RxDataSources
import RxOptional

class RatesViewController: UIViewController, UITableViewDelegate, DataDrivenView {
    
    @IBOutlet weak var tableView: UITableView!

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
    
    var dataSource: RxTableViewSectionedAnimatedDataSource<RatesTableSection>!
    var state: Driver<RatesViewState>!
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = editItem
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .background
        
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.estimatedRowHeight = 72
        tableView.rowHeight = UITableViewAutomaticDimension

        tableView.register(RateCell.self)
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
        
        state.map { $0.isLoading }
            .distinctUntilChanged()
            .drive(refreshControl.rx.isRefreshing)
            .disposed(by: bag)
        
        // Events
        refreshControl.rx
            .controlEvent(.valueChanged)
            .map { .rates(.refreshRates) }
            .bind(to: stateStore.eventBus)
            .disposed(by: bag)

        editItem.rx.tap
            .map { .rates(.openEditMode) }
            .bind(to: stateStore.eventBus)
            .disposed(by: bag)
    }
}
