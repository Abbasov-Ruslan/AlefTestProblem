//
//  RegistrationViewModel.swift
//  AlefTestProblem
//
//  Created by Ruslan Abbasov on 26.10.2022.
//

import UIKit
import Combine

class RegistratioinViewModel {

    private lazy var dataSource: DiffableViewDataSource = makeDataSource()
    private var clearaAllInformationSubject = PassthroughSubject<Void, Never>()
    private var clearChildAgeSubject = PassthroughSubject<Void, Never>()
    private var subscriptions = Set<AnyCancellable>()
    private var childrenCellIndex = 0
    private var firstSubscribeAddChildFlag = true
    private var firstSubscribeClearAllFlag = true
    private var cellsList: [CellTypePrototype] = []

    public var tableView: UITableView = RegisterTableView()

    init() {
        createCellList(cellList: cellsList)
        registerAllCells()
        tableView.dataSource = dataSource
        createSnapshot()
    }

    private func addChildCells() {
        cellsList.insert(TextfieldButtonCellPrototype(subtitileText: "Имя"),
                                             at: cellsList.count - 1)

        cellsList.insert(TextfieldHalfCellPrototype(subtitileText: "Возраст"),
                                           at: cellsList.count - 1)

        cellsList.insert(SeparatorCellPrototype(),
                         at: cellsList.count - 1)
        createSnapshot()
        increaseChildrenIndexNumber()
    }

    private func removeChildCells(id: UUID) {
        for element in cellsList {
            if element.id == id {
                guard let index = cellsList.firstIndex(of: element) else { return }
                cellsList.remove(at: index + 2)
                cellsList.remove(at: index + 1)
                cellsList.remove(at: index)
            }
        }

        createSnapshot()
        decreaseChildrenIndexNumber()
    }

    private func createSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.Main])
        snapshot.appendItems(cellsList,toSection:.Main)
        dataSource.apply(snapshot, animatingDifferences:false)
    }

    private func increaseChildrenIndexNumber() {
        childrenCellIndex += 1
    }

    private func decreaseChildrenIndexNumber() {
        childrenCellIndex -= 1
    }

    private func registerAllCells() {
        registerCell(nibName: "LabelTableViewCell", reuseIdentifier: "LabelTableViewCell")
        registerCell(nibName: "LabelButtonTableViewCell", reuseIdentifier: "LabelButtonTableViewCell")
        registerCell(nibName: "TextFieldButtonTableViewCell", reuseIdentifier: "TextFieldButtonTableViewCell")
        registerCell(nibName: "SeparatorTableViewCell", reuseIdentifier: "SeparatorTableViewCell")
        registerCell(nibName: "ButtonTableViewCell", reuseIdentifier: "ButtonTableViewCell")
        registerCell(nibName: "TextFieldHalfTableViewCell", reuseIdentifier: "TextFieldHalfTableViewCell")
        registerCell(nibName: "TextFieldTableViewCell", reuseIdentifier: "TextFieldTableViewCell")
    }

    private func registerCell(nibName: String, reuseIdentifier: String) {
        tableView.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
    }

    private func createCellList(cellList: [AnyHashable]) {
        cellsList = [LabelCellPrototype(labelText: "Персональные данные"),
                     TextfieldCellPrototype(subtitileText: "Имя"),
                     TextfieldCellPrototype(subtitileText: "Возраст"),
                     LabelButtonCellPrototype(),
                     ButtonCellRenamePrototype()]
    }
}


extension RegistratioinViewModel {
    private func makeDataSource() -> DiffableViewDataSource {
        return DiffableViewDataSource(tableView: tableView) { tableView, indexPath, item in
            if let labelCell = item as? LabelCellPrototype {
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: "LabelTableViewCell",
                    for: indexPath) as? LabelTableViewCell
                cell?.label.text = labelCell.labelText
                return cell
            } else if let textfieldCell = item as? TextfieldCellPrototype {
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
            } else if item is LabelButtonCellPrototype {
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
                            self?.addChildCells()
                        }
                    }).store(in: &self.subscriptions)
                }
                return cell
            } else if let textfieldButtonCellPrototype = item as? TextfieldButtonCellPrototype {
                guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: "TextFieldButtonTableViewCell",
                        for: indexPath) as? TextFieldButtonTableViewCell else { return UITableViewCell()}

                cell.changeTextfieldNameLabel(text: textfieldButtonCellPrototype.subtitileText)
                cell.setID(id: textfieldButtonCellPrototype.id)

                if !(cell.isSubscribedFlag ) {
                    cell.isSubscribedFlag = true
                    cell.cancellable =  cell.pressSubject
                        .compactMap{$0}
                        .sink { [weak self] id in
                            cell.clearTextField()
                            self?.clearChildAgeSubject.send()
//                            self?.removeChildCells(id: id)
                    }
                }

                return cell
            }  else if let textfieldHalfCell = item as? TextfieldHalfCellPrototype {
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: "TextFieldHalfTableViewCell",
                    for: indexPath) as? TextFieldHalfTableViewCell
                cell?.changeSubtitleLabel(text: textfieldHalfCell.subtitileText)
                return cell
            } else if item is SeparatorCellPrototype {
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: "SeparatorTableViewCell",
                    for: indexPath) as? SeparatorTableViewCell
                return cell
            } else if item is ButtonCellRenamePrototype {
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
}
