//
//  DiffableViewDataSource.swift
//  AlefTestProblem
//
//  Created by Ruslan Abbasov on 27.10.2022.
//

import UIKit

class DiffableViewDataSource: UITableViewDiffableDataSource<Section, AnyHashable> {

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return snapshot().sectionIdentifiers[section].rawValue
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 52
        return UITableView.automaticDimension
    }
}

enum Section: String, CaseIterable, Hashable {
    case mainSection = ""
}
