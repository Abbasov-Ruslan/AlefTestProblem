//
//  DiffableViewDataSource.swift
//  AlefTestProblem
//
//  Created by Ruslan Abbasov on 27.10.2022.
//

import UIKit

/// Subclass to help set up sections, etc.
class DiffableViewDataSource: UITableViewDiffableDataSource<Section, AnyHashable> {

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //Use the snapshot to evaluate the section title
        return snapshot().sectionIdentifiers[section].rawValue
    }

}
