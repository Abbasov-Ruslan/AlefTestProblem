//
//  ViewController.swift
//  AlefTestProblem
//
//  Created by Ruslan Abbasov on 25.10.2022.
//

import UIKit

class RegistrationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let tableView = RegisterTableView()
    private lazy var dataSource: DiffableViewDataSource = makeDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.register(UINib(nibName: "LabelTableViewCell", bundle: nil), forCellReuseIdentifier: "LabelTableViewCell")
        tableView.register(UINib(nibName: "TextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "TextFieldTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self

        tableView.separatorColor = UIColor.clear

        tableView.dataSource = dataSource

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AppleCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "OrangeCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "EmptyDataCell")

        getData()
    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        self.tableView.estimatedRowHeight = 52
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCell", for: indexPath) as! TextFieldTableViewCell

        //        cell.label.text = "Персональные данные"

        return cell
    }

}

enum Section: String, CaseIterable, Hashable {
    case emptySection = ""
}


extension RegistrationViewController {
    /// Update the table with some "real" data (1 apple and 1 orange for now)
    private func getData() {
        DispatchQueue.global().async {
            //Pretend we're getting some data asynchronously
            let apples = [Apple(name: "Granny Smith", coreThickness: 12)]
            let oranges = [Orange(name: "Navel", peelThickness: 3)]
            let labelCell = [LabelCell(labelText: "Персональные данные")]
            DispatchQueue.main.async {
                //Have data
                self.updateTable(apples: apples, oranges: oranges, cells: labelCell)
            }
        }
    }

    /// Update the data source snapshot
    /// - Parameters:
    ///   - apples: Apples if any
    ///   - oranges: Oranges if any
    private func updateTable(apples: [Apple], oranges: [Orange], cells: [LabelCell]) {
        // Create a new snapshot on each load. Normally you might pull
        // the existing snapshot and update it.
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        defer {
            dataSource.apply(snapshot)
        }

        // If we have no data, just show the empty view
        //        guard !apples.isEmpty || !oranges.isEmpty else {
        //            snapshot.appendSections([.empty])
        //            snapshot.appendItems([EmptyData()], toSection: .empty)
        //            return
        //        }

        // We have either apples or oranges, so update the snapshot with those
        snapshot.appendSections([.emptySection])
        //        snapshot.appendItems(apples)
        //        snapshot.appendItems(oranges)
        snapshot.appendItems(apples, toSection: .emptySection)
        snapshot.appendItems(oranges, toSection: .emptySection)
        snapshot.appendItems(cells, toSection: .emptySection)
    }

    /// Create our diffable data source
    /// - Returns: Diffable data source
    private func makeDataSource() -> DiffableViewDataSource {
        return DiffableViewDataSource(tableView: tableView) { tableView, indexPath, item in
            if let apple = item as? Apple {
                //Apple
                let cell = tableView.dequeueReusableCell(withIdentifier: "AppleCell", for: indexPath)
                cell.textLabel?.text = "\(apple.name), core thickness: \(apple.coreThickness)mm"
                return cell
            } else if let orange = item as? Orange {
                //Orange
                let cell = tableView.dequeueReusableCell(withIdentifier: "OrangeCell", for: indexPath)
                cell.textLabel?.text = "\(orange.name), peel thickness: \(orange.peelThickness)mm"
                return cell
            } else if let emptyData = item as? EmptyData {
                //Empty
                let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyDataCell", for: indexPath)
                cell.textLabel?.text = emptyData.emptyMessage
                return cell
            } else if let labelCell = item as? LabelCell {
                //LabelTableViewCell
                let cell = tableView.dequeueReusableCell(withIdentifier: "LabelTableViewCell", for: indexPath) as? LabelTableViewCell
                cell?.label.text = labelCell.labelText
                return cell
            } else {
                fatalError("Unknown cell type")
            }
        }
    }

    /// Subclass to help set up sections, etc.
    class DiffableViewDataSource: UITableViewDiffableDataSource<Section, AnyHashable> {

        override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            //Use the snapshot to evaluate the section title
            return snapshot().sectionIdentifiers[section].rawValue
        }

    }


    /// Data to show if we have nothing returned from whatever API we use
    struct EmptyData: Hashable {
        let emptyMessage = "We're sorry! The fruit stand is closed due to inclement weather!"
        let emptyImage = "cloud.bold.rain.fill"
    }

    /// One type of data
    struct Apple: Hashable {
        var name: String
        var coreThickness: Int
    }

    /// Another type of data
    struct Orange: Hashable {
        var name: String
        var peelThickness: Int
    }

    struct LabelCell: Hashable {
        var labelText: String
    }

}
