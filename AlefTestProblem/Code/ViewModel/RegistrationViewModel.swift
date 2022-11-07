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
    private var clearChildAgeSubject = PassthroughSubject<UUID?, Never>()
    private var childrenCountSubject = PassthroughSubject<Void, Never>()
    private var agePassthroughSubjectDictionary: [UUID: PassthroughSubject<UUID?, Never>] = [:]
    private var subscriptions = Set<AnyCancellable>()
    private var childrenCellIndex = 0
    private var firstSubscribeAddChildFlag = true
    private var firstSubscribeClearAllFlag = true
    private var cellsList: [CellPrototype] = []

    public var clearaAllInformationSubject = PassthroughSubject<Void, Never>()
    public var checkAllInformationClearSubject = PassthroughSubject<Void, Never>()

    public var tableView: UITableView = RegisterTableView()

    init() {
        createCellList(cellList: cellsList)
        registerAllCells()
        tableView.dataSource = dataSource
        createSnapshot()
    }

    private func addChildCells() {
        let textfieldButtonCellPrototype = TextfieldButtonCellPrototype(subtitileText: "Имя")
        cellsList.insert(textfieldButtonCellPrototype,
                         at: cellsList.count - 1)

        let textfieldHalfCellPrototype = TextfieldHalfCellPrototype(subtitileText: "Возраст")
        textfieldHalfCellPrototype.linkedCellId = textfieldButtonCellPrototype.prototypeId
        cellsList.insert(textfieldHalfCellPrototype,
                         at: cellsList.count - 1)

        cellsList.insert(SeparatorCellPrototype(),
                         at: cellsList.count - 1)
        createSnapshot()
        increaseChildrenIndexNumber()
    }

    private func removeChildCells(childCellId: UUID) {
        for element in cellsList where element.prototypeId == childCellId {
            guard let index = cellsList.firstIndex(of: element) else { return }
            cellsList.remove(at: index + 2)
            cellsList.remove(at: index + 1)
            cellsList.remove(at: index)
        }

        createSnapshot()
        decreaseChildrenIndexNumber()
    }

    private func createSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.main])
        snapshot.appendItems(cellsList, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
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
                     ButtonCellPrototype()]
    }

    public func clearAllInformation() {
        clearaAllInformationSubject.send()
    }
}

extension RegistratioinViewModel {
    private func createCell(cellIdentifier: String, indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        return cell
    }

    private func getCellFor(prototype: AnyHashable,
                            indexPath: IndexPath,
                            tableVeiw: UITableView
    ) -> UITableViewCell {
        guard let cellPrototype = prototype as? CellPrototype else { fatalError("Unknown cell type") }
        let cell = createCell(cellIdentifier: cellPrototype.cellIdentifieer, indexPath: indexPath, tableView: tableView)
        return cell
    }

    private func setupCell(prototype: CellPrototype, cell: UITableViewCell) {
        switch cell {
        case is LabelTableViewCell:
            break
        case is TextFieldTableViewCell:
            setupTextfieldCell(textfieldCellPrototype: prototype, cell: cell)
        case is LabelButtonTableViewCell:
            break
        case is TextFieldHalfTableViewCell:
            break
        case is TextFieldButtonTableViewCell:
            break
        case is SeparatorTableViewCell:
            break
        case is ButtonTableViewCell:
            break
        default:
            break
        }
    }

    private func setupTextfieldCell(textfieldCellPrototype: CellPrototype, cell: UITableViewCell) {
        guard let cell = cell as? TextFieldTableViewCell,
              let textfieldCellPrototype = textfieldCellPrototype as? TextfieldCellPrototype else {
            return
        }
        cell.changeSubtitleLabel(text: textfieldCellPrototype.subtitileText)
        if !(cell.isSubscribedFlag) {
            cell.isSubscribedFlag = true
            self.clearaAllInformationSubject.sink { [weak cell] in
                cell?.clearTextfield()
            }.store(in: &self.subscriptions)
        }
    }

    private func setupLabelButtonCell(textfieldCellPrototype: CellPrototype, cell: UITableViewCell) {
        guard let cell = cell as? LabelButtonTableViewCell else { return }
        if self.firstSubscribeAddChildFlag {
            self.firstSubscribeAddChildFlag = false
            cell.pressSubject.sink(receiveValue: { [weak self] _ in
                guard let childrenCellIndex = self?.childrenCellIndex else { return }

                if childrenCellIndex < 5 {
                    self?.addChildCells()
                }
                if childrenCellIndex >= 4 {
                    cell.hideButton()
                }
            }).store(in: &self.subscriptions)

            self.childrenCountSubject.sink { [weak cell] in
                cell?.showButton()
            }.store(in: &self.subscriptions)
        }
    }

    private func makeDataSource() -> DiffableViewDataSource {
        return DiffableViewDataSource(tableView: tableView) { [weak self] tableView, indexPath, item in
            guard let self = self else { return UITableViewCell()}

            if item is LabelCellPrototype {
                let cell = self.createCell(cellIdentifier: "LabelTableViewCell", indexPath: indexPath, tableView: tableView)
                return cell
            } else if let textfieldCell = item as? TextfieldCellPrototype {
                let cell = self.createCell(cellIdentifier: "TextFieldTableViewCell", indexPath: indexPath, tableView: tableView) as? TextFieldTableViewCell
                cell?.changeSubtitleLabel(text: textfieldCell.subtitileText)
                if !(cell?.isSubscribedFlag ?? true ) {
                    cell?.isSubscribedFlag = true
                    self.clearaAllInformationSubject.sink { [weak cell] in
                        cell?.clearTextfield()
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
                        if childrenCellIndex >= 4 {
                            cell?.hideButton()
                        }
                    }).store(in: &self.subscriptions)

                    self.childrenCountSubject.sink { [weak cell] in
                        cell?.showButton()
                    }.store(in: &self.subscriptions)
                }
                return cell
            } else if let textfieldButtonCellPrototype = item as? TextfieldButtonCellPrototype {
                guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: "TextFieldButtonTableViewCell",
                        for: indexPath) as? TextFieldButtonTableViewCell else { return UITableViewCell()}

                cell.changeTextfieldNameLabel(text: textfieldButtonCellPrototype.subtitileText)
                cell.setID(textfieldButtonCellPrototype.prototypeId)

                if !(cell.isSubscribedFlag ) {
                    cell.isSubscribedFlag = true
                    self.agePassthroughSubjectDictionary[cell.getIDNumber()] = cell.pressSubject
                    cell.cancellable =  cell.pressSubject
                        .compactMap {$0}
                        .sink { [weak self, weak cell] cellId in
                            self?.agePassthroughSubjectDictionary.removeValue(forKey: cellId)
                            cell?.clearTextField()
                            self?.removeChildCells(childCellId: cellId)
                            if self?.childrenCellIndex ?? 0 < 5 {
                                self?.childrenCountSubject.send()
                            }
                        }

                    self.clearaAllInformationSubject.sink { [weak self] in
                        self?.agePassthroughSubjectDictionary.removeValue(forKey: cell.getIDNumber() )
                        cell.clearTextField()
                        self?.removeChildCells(childCellId: cell.getIDNumber())
                        self?.childrenCountSubject.send()
                    }.store(in: &self.subscriptions)
                }

                return cell
            } else if let textfieldHalfCell = item as? TextfieldHalfCellPrototype {
                guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: "TextFieldHalfTableViewCell",
                        for: indexPath) as? TextFieldHalfTableViewCell else { return UITableViewCell() }
                cell.changeSubtitleLabel(text: textfieldHalfCell.subtitileText)

                if !(cell.isSubscribedFlag ) {
                    cell.isSubscribedFlag = true
                    self.agePassthroughSubjectDictionary[
                        textfieldHalfCell.linkedCellId ?? UUID()]?
                        .sink(receiveValue: { _ in
                            cell.clearTextField()
                        }).store(in: &self.subscriptions)
                }

                self.clearaAllInformationSubject.sink { _ in
                    cell.clearTextField()
                }.store(in: &self.subscriptions)

                return cell
            } else if item is SeparatorCellPrototype {
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: "SeparatorTableViewCell",
                    for: indexPath) as? SeparatorTableViewCell
                return cell
            } else if item is ButtonCellPrototype {
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: "ButtonTableViewCell",
                    for: indexPath) as? ButtonTableViewCell
                if self.firstSubscribeClearAllFlag {
                    self.firstSubscribeClearAllFlag = false
                    cell?.tapSubject.sink(receiveValue: { [weak self] _ in
                        self?.checkAllInformationClearSubject.send()
                    }).store(in: &self.subscriptions)
                }
                return cell
            } else {
                fatalError("Unknown cell type")
            }
        }
    }
}
