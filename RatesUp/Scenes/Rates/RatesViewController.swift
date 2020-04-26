//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxOptional
import RxDataSources

class RatesViewController: UIViewController, UITableViewDelegate {
    private let tableView = update(UITableView()) {
        $0.separatorStyle = .none
        $0.backgroundColor = .background
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.estimatedRowHeight = 72
        $0.rowHeight = UITableView.automaticDimension

        $0.register(RateCell.self)
    }

    private let editItem = update(
        UIBarButtonItem(title: "Edit", style: .plain, target: nil, action: nil)
    ) {
        $0.tintColor = .mainText
    }
    
    private let refreshControl = update(UIRefreshControl()) {
        $0.tintColor = .activity
    }

    private let dataSourceProvider = RatesSectionsProvider(
        converter: RatesSection.converter
    )

    private let dataSource = RxTableViewSectionedAnimatedDataSource<RatesSection>(
        configureCell: { _, tableView, indexPath, item in
            switch item {
            case .rate(_, let state):
                let cell: RateCell = tableView.dequeueCell(for: indexPath)
                cell.setup(with: state)
                return cell
            }
    })

    private let bag = DisposeBag()
    
    init(store: AppStore) {
        super.init(nibName: nil, bundle: nil)

        navigationItem.rightBarButtonItem = editItem
        view.addSubview(tableView, constraints: [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        tableView.addSubview(refreshControl)

        subscribe(to: store)
        dataSourceProvider.subscribe(to: store)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSourceProvider.sections
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)

        tableView.rx
            .setDelegate(self)
            .disposed(by: bag)
    }
    
    func subscribe(to store: AppStore) {
        let ratesState = store.state.map(\.rates)
            .distinctUntilChanged()

        ratesState
            .map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: bag)

        // Events
        refreshControl.rx
            .controlEvent(.valueChanged)
            .map { .rates(.refreshRates) }
            .bind(onNext: { store.send($0) })
            .disposed(by: bag)
    }
}

fileprivate extension RatesState {
    var isLoading: Bool { ratesResult == nil }
}

extension UIView {
    func addSubview(_ view: UIView, constraints: [NSLayoutConstraint]) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        NSLayoutConstraint.activate(constraints)
    }
}
