//
//  ViewController.swift
//  AlefTestProblem
//
//  Created by Ruslan Abbasov on 25.10.2022.
//

import UIKit

class RegistrationViewController: UIViewController, UITableViewDelegate {

    private var viewModel = RegistratioinViewModel()
    private var tableView: UITableView?

    required init?(coder: NSCoder) {
        self.tableView = viewModel.tableView
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let tableView = self.tableView else {
            fatalError("Tableview is not initialized")
        }
        view.addSubview(tableView)
        tableView.register(UINib(nibName: "LabelTableViewCell", bundle: nil), forCellReuseIdentifier: "LabelTableViewCell")
        tableView.register(UINib(nibName: "TextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "TextFieldTableViewCell")

        tableView.dataSource = viewModel.dataSource
        tableView.delegate = self

        tableView.separatorColor = UIColor.clear

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AppleCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "OrangeCell")

        viewModel.getData()
    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView?.frame = view.bounds
    }


}

//extension RegistrationViewController {
//
//    private func getData() {
//
//        let labelCell = [LabelCell(labelText: "Персональные данные")]
//        //Have data
//        self.updateTable(cells: labelCell)
//    }
//
//    private func updateTable(cells: [LabelCell]) {
//        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
//        defer {
//            dataSource.apply(snapshot, animatingDifferences: tableView.window != nil)
//        }
//        snapshot.appendSections([.emptySection])
//        snapshot.appendItems(cells, toSection: .emptySection)
//    }
//
//    private func makeDataSource() -> DiffableViewDataSource {
//        return DiffableViewDataSource(tableView: tableView) { tableView, indexPath, item in
//            if let labelCell = item as? LabelCell {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "LabelTableViewCell", for: indexPath) as? LabelTableViewCell
//                cell?.label.text = labelCell.labelText
//                return cell
//            } else {
//                fatalError("Unknown cell type")
//            }
//        }
//    }
//
//    struct LabelCell: Hashable {
//        var labelText: String
//    }
//
//}
