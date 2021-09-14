

import Foundation
import UIKit
import RealmSwift

class CategoryOfExpensesVC: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var addCategoryOfExpense: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalExpenses: UILabel!
    
    //MARK: - PrivateProperties
    private let dbManager: DBManagerPaymentsProtocol & DBManagerCategoriesProtocol = DBManager()
    private let realm = DBManager().realm
    private var expensesCategory: [PaymentCategoryObject] = []
    
    private var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        return refreshControl
    }()
    
    //MARK: - OverrideMethods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addCategoryOfExpense.layer.cornerRadius = 20
        setupTableView()
        expensesCategory = dbManager.getCategories()
        tableView.refreshControl = refreshControl
        
        totalExpenses.text = "\(dbManager.getTotalExpense())"
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let expensesVC = segue.destination as! ExpensesVC
        expensesVC.modalPresentationStyle = .overCurrentContext
        expensesVC.category = sender as? PaymentCategoryObject
    }
    //MARK: - IBActions
    @IBAction func addNewExpenseAction() {
        alertEnterCategory { name in
            self.saveCategory(name: name)
        }
    }
}
// MARK: - Extensions
private extension CategoryOfExpensesVC {
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CategoryCell", bundle: nil), forCellReuseIdentifier: "CategoryCell")
    }
    
    func saveCategory(name: String?) {
        guard let name = name else {  return }
        dbManager.saveCategory(name: name)
        expensesCategory = dbManager.getCategories()
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate
extension CategoryOfExpensesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = expensesCategory[indexPath.row]
        performSegue(withIdentifier: "showTypeOfExpense", sender: selectedCategory)
    }
}

// MARK: - UITableViewDataSource
extension CategoryOfExpensesVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        expensesCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        cell.configure(data: expensesCategory[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal,
                                        title: "Delete") { [weak self] (action, view, completionHandler) in
            completionHandler(true)
            let editingRow = self?.expensesCategory.remove(at: indexPath.row)
            
            let payments = self!.realm.objects(PaymentObject.self)
            
            try! self?.realm.write({
                self?.realm.delete(payments.filter { $0.category == editingRow?.name })
                self?.realm.delete(editingRow!)
            })
            tableView.reloadData()
        }
        action.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .normal,
                                        title: "Edit") { [weak self] (action, view, completionHandler) in
            completionHandler(true)
            let alert = UIAlertController(title: "Type new expense category", message: nil, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { [self] _ in
                
                let editingRow = self?.expensesCategory[indexPath.row]
                
                try! self?.realm.write {
                    editingRow?.name = alert.textFields?[0].text ?? "Print text"
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }))
            
            alert.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
                textField.placeholder = "Change type of expense"
            })
            self?.present(alert, animated: true, completion: nil)
        }
        action.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    //MARK: - PublicMethods
    @objc func refresh(sender: UIRefreshControl) {
        totalExpenses.text = "\(dbManager.getTotalExpense())"
        expensesCategory = dbManager.getCategories()
        tableView.reloadData()
        sender.endRefreshing()
    }
}
