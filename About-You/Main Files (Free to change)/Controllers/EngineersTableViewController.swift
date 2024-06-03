import UIKit

protocol OrderByDelegate: AnyObject {
    func didSelectOrderBy(_ order: OrderBy)
}

enum OrderBy {
    case years
    case coffees
    case bugs
}

class EngineersTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate, OrderByDelegate {
    var engineers: [Engineer] = Engineer.testingData()
    var selectedEngineer: Engineer?
    var currentOrder: OrderBy = .years
    var profileImageView: UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Engineers at Glucode"
        tableView.backgroundColor = .white
        registerCells()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationController()
    }

    private func setupNavigationController() {
        navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Order by",
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(orderByTapped))
        navigationItem.rightBarButtonItem?.tintColor = .black
    }

    @objc func orderByTapped() {
        guard let from = navigationItem.rightBarButtonItem else { return }
        let controller = OrderByTableViewController(style: .plain)
        controller.delegate = self
        controller.selectedRowIndex = nil
        let size = CGSize(width: 200,
                          height: 150)

        present(popover: controller,
             from: from,
             size: size,
             arrowDirection: .up)
    }

    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
            return .none
        }

    private func registerCells() {
        tableView.register(UINib(nibName: String(describing: GlucodianTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: GlucodianTableViewCell.self))
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return engineers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: GlucodianTableViewCell.self), for: indexPath) as! GlucodianTableViewCell
        let engineer = engineers[indexPath.row]
        cell.setUp(with: engineer)
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEngineer = engineers[indexPath.row]
        let controller = QuestionsViewController.loadController(with: engineers[indexPath.row].questions)
        controller.profilePictureDelegate = self
        controller.selectedEngineer = selectedEngineer
        controller.nameLabel.text = selectedEngineer.name
        controller.roleLabel.text = selectedEngineer.role
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - OrderByDelegate
    func didSelectOrderBy(_ order: OrderBy) {
        currentOrder = order
        switch order {
        case .years:
            engineers.sort { $0.quickStats.years > $1.quickStats.years }
        case .coffees:
            engineers.sort { $0.quickStats.coffees > $1.quickStats.coffees }
        case .bugs:
            engineers.sort { $0.quickStats.bugs > $1.quickStats.bugs }
        }
        tableView.reloadData()
    }
}

extension EngineersTableViewController: ProfilePictureDelegate {
    func didUpdateProfilePicture(_ image: UIImage?, for engineer: Engineer) {
        if let index = engineers.firstIndex(where: { $0.name == engineer.name }) {
            engineers[index].profileImage = image
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
    }
}
