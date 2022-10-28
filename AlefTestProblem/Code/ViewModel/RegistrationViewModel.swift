//
//  RegistrationViewModel.swift
//  AlefTestProblem
//
//  Created by Ruslan Abbasov on 26.10.2022.
//

import UIKit

class RegistratioinViewModel {

    lazy var dataSource: DiffableViewDataSource = makeDataSource()
    public var tableView: UITableView = RegisterTableView()

    init() {
    }

    public func getData() {

        let labelCell = [LabelCell(labelText: "Персональные данные")]
        //Have data
        self.updateTable(cells: labelCell)
    }

    public func updateTable(cells: [LabelCell]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        defer {
            dataSource.apply(snapshot, animatingDifferences: tableView.window != nil)
        }
        snapshot.appendSections([.emptySection])
        snapshot.appendItems(cells, toSection: .emptySection)
    }

    public func makeDataSource() -> DiffableViewDataSource {
        return DiffableViewDataSource(tableView: tableView) { tableView, indexPath, item in
            if let labelCell = item as? LabelCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LabelTableViewCell", for: indexPath) as? LabelTableViewCell
                cell?.label.text = labelCell.labelText
                return cell
            } else {
                fatalError("Unknown cell type")
            }
        }
    }

    struct LabelCell: Hashable {
        var labelText: String
    }
}
