//
//  RegistrationViewModel.swift
//  AlefTestProblem
//
//  Created by Ruslan Abbasov on 26.10.2022.
//

import UIKit
import Combine

class RegistratioinViewModel {

    lazy var dataSource: DiffableViewDataSource = makeDataSource()
    public var tableView: UITableView = RegisterTableView()
    var clearaAllInformationSubject = PassthroughSubject<Void, Never>()
    var AddChildInformationSubject = PassthroughSubject<Void, Never>()
    private var subscriptions = Set<AnyCancellable>()
    var childrenCellIndex = 0
    var firstSubscribeAddChildFlag = true
    var firstSubscribeClearAllFlag = true

    init() {
        tableView.register(UINib(nibName: "LabelTableViewCell", bundle: nil), forCellReuseIdentifier: "LabelTableViewCell")
        tableView.register(UINib(nibName: "TextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "TextFieldTableViewCell")
        tableView.register(UINib(nibName: "LabelButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "LabelButtonTableViewCell")
        tableView.register(UINib(nibName: "TextFieldButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "TextFieldButtonTableViewCell")
        tableView.register(UINib(nibName: "SeparatorTableViewCell", bundle: nil), forCellReuseIdentifier: "SeparatorTableViewCell")
        tableView.register(UINib(nibName: "ButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "ButtonTableViewCell")

        tableView.dataSource = dataSource

        getData()
    }

    public func getData() {

        let cells: [AnyHashable] = [LabelCell(labelText: "Персональные данные"),
                                    TextfieldCell(subtitileText: "Имя"),
                                    TextfieldCell(subtitileText: "Возраст"),
                                    LabelButtonCell(),
                                    ButtonCell()]

        self.updateTable(cells: cells)
    }

    public func AddChildCells() {
        let childCells: [AnyHashable]  = [
            TextfieldButtonCell(subtitileText: "Имя", index: childrenCellIndex),
            TextfieldButtonCell(subtitileText: "Возраст", index: childrenCellIndex),
            SeparatorCell(index: childrenCellIndex)]

        remove(ButtonCell(), animate: false)
        var snapshot = dataSource.snapshot()
        snapshot.appendItems(childCells, toSection: .mainSection)
        snapshot.appendItems([ButtonCell()], toSection: .mainSection)
        dataSource.apply(snapshot, animatingDifferences: false)

        increaseChildrenIndexNumber()
    }

    private func increaseChildrenIndexNumber() {
        childrenCellIndex += 1
    }

    private func decreaseChildrenIndexNumber() {
        childrenCellIndex -= 1
    }

    public func updateTable(cells: [AnyHashable]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        defer {
            dataSource.apply(snapshot, animatingDifferences: tableView.window != nil)
        }
        snapshot.appendSections([.mainSection])
        snapshot.appendItems(cells, toSection: .mainSection)
    }

    public func remove(_ cell: AnyHashable, animate: Bool = false) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems([cell])
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    public func makeDataSource() -> DiffableViewDataSource {
        return DiffableViewDataSource(tableView: tableView) { tableView, indexPath, item in
            if let labelCell = item as? LabelCell {
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: "LabelTableViewCell",
                    for: indexPath) as? LabelTableViewCell
                cell?.label.text = labelCell.labelText
                return cell
            } else if let textfieldCell = item as? TextfieldCell {
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: "TextFieldTableViewCell",
                    for: indexPath) as? TextFieldTableViewCell
                cell?.subtitleLabel.text = textfieldCell.subtitileText
                if self.childrenCellIndex <= 0 {
                    self.clearaAllInformationSubject.sink { _ in
                        cell?.clearTextFieldSubject.send()
                    }.store(in: &self.subscriptions)
                }
                return cell
            } else if item is LabelButtonCell {
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: "LabelButtonTableViewCell",
                    for: indexPath) as? LabelButtonTableViewCell
                if self.firstSubscribeAddChildFlag {
                    self.firstSubscribeAddChildFlag = false
                    cell?.pressSubject.sink(receiveValue: { [weak self] _ in
                        guard let childrenCellIndex = self?.childrenCellIndex else {
                            return
                        }
                        if childrenCellIndex < 5 {
                            self?.AddChildCells()
                        }
                    }).store(in: &self.subscriptions)
                }
                return cell
            } else if let textfieldButtonCell = item as? TextfieldButtonCell {
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: "TextFieldButtonTableViewCell",
                    for: indexPath) as? TextFieldButtonTableViewCell
                cell?.textfieldNameLabel.text = textfieldButtonCell.subtitileText
                return cell
            } else if item is SeparatorCell {
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: "SeparatorTableViewCell",
                    for: indexPath) as? SeparatorTableViewCell
                return cell
            } else if item is ButtonCell {
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: "ButtonTableViewCell",
                    for: indexPath) as? ButtonTableViewCell
                if self.firstSubscribeClearAllFlag {
                    self.firstSubscribeClearAllFlag = false
                    cell?.tapSubject.sink(receiveValue: { [weak self] _ in
                        self?.clearaAllInformationSubject.send()
                    }).store(in: &self.subscriptions)
                }
                return cell
            } else {
                fatalError("Unknown cell type")
            }
        }
    }

    func clearTextfieldCells() {

    }

    struct LabelCell: Hashable {
        var labelText: String
    }

    struct TextfieldCell: Hashable {
        var subtitileText: String
    }

    struct LabelButtonCell: Hashable {
    }

    struct TextfieldButtonCell: Hashable {
        var subtitileText: String
        var index: Int
    }

    struct SeparatorCell: Hashable {
        var index: Int
    }

    struct ButtonCell: Hashable {
    }
}
