//
//  ViewController.swift
//  AlefTestProblem
//
//  Created by Ruslan Abbasov on 25.10.2022.
//

import UIKit

class RegistrationViewController: UIViewController, UITableViewDelegate {

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

        tableView.delegate = self

    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView?.frame = view.bounds
    }


}
