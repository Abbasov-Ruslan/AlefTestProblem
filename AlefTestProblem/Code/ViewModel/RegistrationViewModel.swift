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
        tableView.register(UINib(nibName: "LabelTableViewCell", bundle: nil), forCellReuseIdentifier: "LabelTableViewCell")
        tableView.register(UINib(nibName: "TextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "TextFieldTableViewCell")
        tableView.register(UINib(nibName: "LabelButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "LabelButtonTableViewCell")

        tableView.dataSource = dataSource

        

        getData()

        
    }

    public func getData() {

        let cells: [AnyHashable] = [LabelCell(labelText: "Персональные данные"), TextfieldCell(subtitileText: "Имя"), TextfieldCell(subtitileText: "Возраст"), LabelButtonCell()]
        self.updateTable(cells: cells)
    }

    public func updateTable(cells: [AnyHashable]) {
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
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: "LabelTableViewCell",
                    for: indexPath) as? LabelTableViewCell

                cell?.label.text = labelCell.labelText
                return cell
            } else if let labelCell = item as? TextfieldCell {
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: "TextFieldTableViewCell",
                    for: indexPath) as? TextFieldTableViewCell
                
                cell?.subtitleLabel.text = labelCell.subtitileText
                return cell
            } else if let labelCell = item as? LabelButtonCell {
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: "LabelButtonTableViewCell",
                    for: indexPath) as? LabelButtonTableViewCell
                return cell
            } else {
                fatalError("Unknown cell type")
            }
        }
    }

    struct LabelCell: Hashable {
        var labelText: String
    }

    struct TextfieldCell: Hashable {
        var subtitileText: String
    }

    struct LabelButtonCell: Hashable {
    }

}
