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
    typealias DataSource = RxTableViewSectionedAnimatedDataSource<СurrenciesTableSection>
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 46
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(class: CurrencyCell.self)
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
    
    var dataSource: DataSource!
    var state: Driver<CurrenciesViewState>!
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = cancelItem
        navigationItem.rightBarButtonItem = doneItem
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
        dataSource = DataSource(configureCell: { _, tableView, indexPath, item in
            switch item {
            case .currency(let state):
                let cell: CurrencyCell = tableView.dequeueCell(for: indexPath)
                cell.setup(with: state)
                return cell
            }
        }, canMoveRowAtIndexPath: { _, _ in true } )
        
        dataSource.titleForHeaderInSection = { sections, index in
            switch sections.sectionModels[index] {
            case .included: return "Добавленные"
            case .excluded: return "Доступные"
            }
        }

        tableView.rx
            .setDelegate(self)
            .disposed(by: bag)
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
        
        // UI
        state.map { $0.dataSource }
            .distinctUntilChanged { $0 == $1 }
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
}
