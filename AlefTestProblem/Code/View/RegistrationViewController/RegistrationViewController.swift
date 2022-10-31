//
//  ViewController.swift
//  AlefTestProblem
//
//  Created by Ruslan Abbasov on 25.10.2022.
//

import UIKit

class RegistrationViewController: UIViewController {

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

    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView?.frame = view.bounds
        tableView?.separatorColor = UIColor.clear
    }


}
