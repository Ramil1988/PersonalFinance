

import Foundation
import UIKit

class ExpensesVC: UIViewController {
    
    //MARK: -Outlets
    @IBOutlet weak var typeOfExpenseLabel: UILabel!
    @IBOutlet weak var chartsOfPaymentSegue: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalAmountOfExpense: UILabel!
    @IBOutlet weak var addExpenseBtn: UIButton!
    
    // MARK: - Properties
    private let dbManager: DBManagerPaymentsProtocol  = DBManager()
    private let realm = DBManager().realm
    var category: PaymentCategoryObject?

    //MARK: - OverrideMethods
    override func viewDidLoad() {
        super.viewDidLoad()
        addExpenseBtn.layer.cornerRadius = 20
        setupTableView()
        tableView.reloadData()
        typeOfExpenseLabel.text = category?.name
        
        let object = category?.paymentObjects
        var totalSum = 0
        if object?.count != nil {
            for amount in object! {
                totalSum += amount.sum
            }
        }
        totalAmountOfExpense.text = String(Int(self.totalAmountOfExpense?.text ?? "")! + totalSum)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let chartsVC = segue.destination as! ChartsVC
        chartsVC.category = category
    }
    
    //MARK: - IBActions
    @IBAction func addExpenseActionBtn() {
        alertEnterExpense { [self] name, sum, date in
            self.addTypeOfExpense(name: name, categoryOfExpense: self.category?.name, sum: sum, date: date, type: .expense)
            guard let sum = Int(sum ?? "0") else { return }
            totalAmountOfExpense.text = String(Int(self.totalAmountOfExpense?.text ?? "")! + Int(sum))
                           //
        }
    }
    
    @IBAction func showChartsForExpensesCategory(_ sender: UIButton) {
        performSegue(withIdentifier: "showChartsForExpensesCategory1", sender: nil)
    }
    
    //MARK: - PublicMethods
    @objc func refresh(sender: UIRefreshControl) {
        
        tableView.reloadData()
        sender.endRefreshing()
    }
}
// MARK: - Extensions
private extension ExpensesVC {
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PaymentCell", bundle: nil), forCellReuseIdentifier: "PaymentCell")
    }
    
    func addTypeOfExpense(name: String?, categoryOfExpense: String?, sum: String?, date: String?, type: PaymentType) {
        guard let name = name, let sum = Int(sum ?? "0"), let date = date else { return }
        
        let paymentObject = PaymentObject()
        paymentObject.name = name
        paymentObject.category = categoryOfExpense!
        paymentObject.sum = sum
        paymentObject.date = date
        paymentObject.type = type.rawValue
        
        try! realm.write {
            category?.paymentObjects.append(paymentObject)
            tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDelegate
extension ExpensesVC: UITableViewDelegate {
}

// MARK: - UITableViewDataSource
extension ExpensesVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        category?.paymentObjects.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentCell", for: indexPath) as! PaymentCell
        if let currentPaymentObject = category?.paymentObjects[indexPath.row] {
            cell.configure(data: currentPaymentObject)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal,
                                        title: "Delete") { [weak self] (action, view, completionHandler) in
            completionHandler(true)
            
            self!.totalAmountOfExpense.text = String(Int(self!.totalAmountOfExpense?.text ?? "")! - (self!.category?.paymentObjects[indexPath.row].sum)!)
            
            try! self?.realm.write({
                let object = self?.category?.paymentObjects[indexPath.row]
                self!.category!.paymentObjects.remove(at: indexPath.row)
                self?.realm.delete(object!)
            })
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        action.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [action])
    }
}
