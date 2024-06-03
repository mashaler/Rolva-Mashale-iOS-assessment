import UIKit

class OrderByTableViewController: UITableViewController {

    weak var delegate: OrderByDelegate?
    var selectedRowIndex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Years"
        case 1:
            cell.textLabel?.text = "Coffees"
        case 2:
            cell.textLabel?.text = "Bugs"
        default:
            break
        }
        cell.accessoryType = (indexPath == selectedRowIndex) ? .checkmark : .none
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedRowIndex = indexPath
        tableView.reloadData()

        let order: OrderBy
        switch indexPath.row {
        case 0:
            order = .years
        case 1:
            order = .coffees
        case 2:
            order = .bugs
        default:
            return
        }

        delegate?.didSelectOrderBy(order)
        dismiss(animated: true, completion: nil)
    }
}
