//
//  ViewController.swift
//  AlefTestProblem
//
//  Created by Ruslan Abbasov on 25.10.2022.
//

import UIKit
import Combine

class RegistrationViewController: UIViewController {

    private var viewModel = RegistratioinViewModel()
    private var tableView: UITableView?
    private var subscriptions = Set<AnyCancellable>()

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

        viewModel.checkAllInformationClearSubject.sink { [weak self] in
            self?.showAlert()
        }.store(in: &subscriptions)

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView?.frame = view.bounds
        tableView?.separatorColor = UIColor.clear
    }

    private func showAlert() {
        let alert = UIAlertController(title: "Внимание",
              message: "Вы действительно хотите сбросить все данные?",
              preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Сбросить данные",
                             style: .default) { _ in
            self.viewModel.clearAllInformation()
        }
        let cancelAction = UIAlertAction(title: "Отмена",
                             style: .cancel) { _ in
        }
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)

        self.present(alert, animated: true, completion: nil)
    }
}
