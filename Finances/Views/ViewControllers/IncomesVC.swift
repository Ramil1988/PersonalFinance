

import Foundation
import UIKit

class IncomesVC: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var addIncomeBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalIncomes: UILabel!
    
    //MARK: - Properties
    private let dbManager: DBManagerCategoriesProtocol & DBManagerPaymentsProtocol = DBManager()
    private let realm = DBManager().realm
    private var incomes: [PaymentObject] = []
    private var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        return refreshControl
    }()
    
    //MARK: - OverrideMethods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addIncomeBtn.layer.cornerRadius = 20
        setupTableView()
        incomes = dbManager.getIncomes()
        tableView.refreshControl = refreshControl
        totalIncomes.text = dbManager.getTotalIncome()
        tableView.reloadData()
    }
    //MARK: - IBActions
    @IBAction func addIncomeBtnAction() {
        alertEnterIncome { name, sum, date in
            self.addIncome(name: name, sum: sum, date: date)
        }
    }
}
// MARK: - Extensions
private extension IncomesVC {
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PaymentCell", bundle: nil), forCellReuseIdentifier: "PaymentCell")
    }
    
    func addIncome(name: String?, sum: String?, date: String?) {
        guard let name = name, let sum = Int(sum ?? "0"), let date = date else { return }
        dbManager.saveIncome(sum: sum, name: name, date: date)
        incomes = dbManager.getIncomes()
        totalIncomes.text! = String(Int(exactly: sum)! + Int(self.totalIncomes?.text ?? "??")!)
        tableView.reloadData()
    }
}
// MARK: - UITableViewDelegate
extension IncomesVC: UITableViewDelegate {
}

// MARK: - UITableViewDataSource
extension IncomesVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        incomes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentCell", for: indexPath) as! PaymentCell
        cell.configure(data: incomes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal,
                                        title: "Delete") { [weak self] (action, view, completionHandler) in
            completionHandler(true)
            let editingRow = self?.incomes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            let closeAction = UIContextualAction(style: .normal, title:  "Close", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                    print("Copy")

                let cell = tableView.cellForRow(at: indexPath)
                UIPasteboard.general.string = cell?.textLabel?.text

                    success(true)
                })
                closeAction.title = "Copy"
                closeAction.backgroundColor = .purple
            
            
            self?.totalIncomes.text! = String(Int(self?.totalIncomes?.text ?? "")! - Int(exactly: editingRow?.sum ?? 01)!)
            
            try! self?.realm.write({
                self?.realm.delete(editingRow!)
            })
        }
        action.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    //MARK: - PublicMethods
    @objc func refresh(sender: UIRefreshControl) {
        totalIncomes.text = "\(dbManager.getTotalIncome())"
        incomes = dbManager.getIncomes()
        tableView.reloadData()
        sender.endRefreshing()
    }
}
