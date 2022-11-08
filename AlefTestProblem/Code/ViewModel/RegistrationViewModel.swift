//
//  RegistrationViewModel.swift
//  AlefTestProblem
//
//  Created by Ruslan Abbasov on 26.10.2022.
//

import UIKit
import Combine

public class RegistratioinViewModel {

    private var clearChildAgeSubject = PassthroughSubject<UUID?, Never>()
    private var childrenCountSubject = PassthroughSubject<Void, Never>()
    private var agePassthroughSubjectDictionary: [UUID: PassthroughSubject<UUID?, Never>] = [:]
    private var subscriptions = Set<AnyCancellable>()
    private var firstSubscribeAddChildFlag = true
    private var firstSubscribeClearAllFlag = true

    private lazy var dataSource: DiffableViewDataSource = makeDataSource(viewModel: self)
    private var childrenCellIndex = 0
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

    public func clearAllInformation() {
        clearaAllInformationSubject.send()
    }
}

extension RegistratioinViewModel {
    private func createSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.main])
        snapshot.appendItems(cellsList, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: tableView.window != nil)
    }
}

extension RegistratioinViewModel {
    private func increaseChildrenIndexNumber() {
        childrenCellIndex += 1
    }

    private func decreaseChildrenIndexNumber() {
        childrenCellIndex -= 1
    }
}

extension RegistratioinViewModel {
    private func createCellList(cellList: [AnyHashable]) {
        cellsList = [LabelCellPrototype(labelText: "Персональные данные"),
                     TextfieldCellPrototype(subtitileText: "Имя"),
                     TextfieldCellPrototype(subtitileText: "Возраст"),
                     LabelButtonCellPrototype(),
                     ButtonCellPrototype()]
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
}

extension RegistratioinViewModel {
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
}

extension RegistratioinViewModel {
    private func makeDataSource(viewModel: RegistratioinViewModel) -> DiffableViewDataSource {
        return DiffableViewDataSource(tableView: tableView) { [weak self] tableView, indexPath, item in
            let cell = self?.getCellFor(prototype: item, indexPath: indexPath, tableVeiw: tableView)
            return cell
        }
    }

    private func createCell(cellIdentifier: String, indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        return cell
    }

    private func getCellFor(prototype: AnyHashable,
                            indexPath: IndexPath,
                            tableVeiw: UITableView
    ) -> UITableViewCell {
        guard let prototype = prototype as? CellPrototype else {
            fatalError("Unknown cell type")
        }
        let cell = createCell(cellIdentifier: prototype.cellIdentifieer, indexPath: indexPath, tableView: tableView)
        setupCell(prototype: prototype, cell: cell)
        return cell
    }

    private func setupCell(prototype: CellPrototype, cell: UITableViewCell) {
        switch cell {
        case is LabelTableViewCell:
            setupLabelCell(prototype: prototype, cell: cell)
        case is TextFieldTableViewCell:
            setupTextfieldCell(prototype: prototype, cell: cell)
        case is LabelButtonTableViewCell:
            setupLabelButtonCell(cell: cell)
        case is TextFieldButtonTableViewCell:
            setupTextFieldButtonCell(prototype: prototype, cell: cell)
        case is TextFieldHalfTableViewCell:
            setupTextFieldHalfCell(prototype: prototype, cell: cell)
        case is SeparatorTableViewCell:
            break
        case is ButtonTableViewCell:
            setupButtonCellPrototype(prototype: prototype, cell: cell)
        default:
            break
        }
    }

    private func setupLabelCell(prototype: CellPrototype, cell: UITableViewCell) {
        guard let cell = cell as? LabelTableViewCell,
              let prototype = prototype as? LabelCellPrototype else {
            return
        }
        cell.chageLabelText(text: prototype.labelText)
    }

    private func setupTextfieldCell(prototype: CellPrototype, cell: UITableViewCell) {
        guard let cell = cell as? TextFieldTableViewCell,
              let prototype = prototype as? TextfieldCellPrototype else {
            return
        }
        cell.changeSubtitleLabel(text: prototype.subtitileText)
        if !(cell.isSubscribedFlag) {
            cell.isSubscribedFlag = true
            self.clearaAllInformationSubject.sink { [weak cell] in
                cell?.clearTextfield()
            }.store(in: &self.subscriptions)
        }
    }

    private func setupLabelButtonCell(cell: UITableViewCell) {
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

    private func setupTextFieldButtonCell(prototype: CellPrototype, cell: UITableViewCell) {
        guard let cell = cell as? TextFieldButtonTableViewCell,
              let prototype = prototype as? TextfieldButtonCellPrototype else {
            return
        }

        cell.changeTextfieldNameLabel(text: prototype.subtitileText)
        cell.setID(prototype.prototypeId)

        if !cell.isSubscribedFlag {
            cell.isSubscribedFlag = true
            self.agePassthroughSubjectDictionary[cell.getIDNumber()] = cell.pressSubject
            cell.cancellable =  cell.pressSubject
                .compactMap {$0}
                .sink { [weak self, weak cell] cellId in
                    guard let self = self, let cell = cell else { return }
                    self.agePassthroughSubjectDictionary.removeValue(forKey: cellId)
                    cell.clearTextField()
                    self.removeChildCells(childCellId: cellId)
                    if self.childrenCellIndex < 5 {
                        self.childrenCountSubject.send()
                    }
                }
        }

        if !cell.isSubscribedToClearAll {
            cell.isSubscribedToClearAll = true

            self.clearaAllInformationSubject.sink { [weak self, weak cell] in
                guard let self = self, let cell = cell else {
                    return
                }
                self.agePassthroughSubjectDictionary.removeValue(forKey: cell.getIDNumber() )
                cell.clearTextField()
                self.removeChildCells(childCellId: cell.getIDNumber())
                self.childrenCountSubject.send()
            }.store(in: &self.subscriptions)
        }

    }

    private func setupTextFieldHalfCell(prototype: CellPrototype, cell: UITableViewCell) {
        guard let cell = cell as? TextFieldHalfTableViewCell,
              let prototype = prototype as? TextfieldHalfCellPrototype else {
            return
        }
        cell.changeSubtitleLabel(text: prototype.subtitileText)

        if !(cell.isSubscribedFlag ) {
            cell.isSubscribedFlag = true
            self.agePassthroughSubjectDictionary[
                prototype.linkedCellId ?? UUID()]?
                .sink(receiveValue: { _ in
                    cell.clearTextField()
                }).store(in: &self.subscriptions)
        }

        self.clearaAllInformationSubject.sink { _ in
            cell.clearTextField()
        }.store(in: &self.subscriptions)
    }

    private func setupButtonCellPrototype(prototype: CellPrototype, cell: UITableViewCell) {
        guard let cell = cell as? ButtonTableViewCell else {
            return
        }
        if self.firstSubscribeClearAllFlag {
            self.firstSubscribeClearAllFlag = false
            cell.tapSubject.sink(receiveValue: { [weak self] _ in
                self?.checkAllInformationClearSubject.send()
            }).store(in: &self.subscriptions)
        }
    }

}
