
import RealmSwift
import UIKit

class MainScreenVC: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var totalBalance: UILabel!
    @IBOutlet weak var mainStackview: UIStackView!
    @IBOutlet weak var firstCellView: UIView!
    @IBOutlet weak var firstCellLabel: UILabel!
    @IBOutlet weak var secondCellView: UIView!
    @IBOutlet weak var secondCellLabel: UILabel!
    @IBOutlet weak var thirdCellView: UIView!
    @IBOutlet weak var thirdCellIncomeLabel: UILabel!
    @IBOutlet weak var thirdCellDateLabel: UILabel!
    @IBOutlet weak var fourthCellView: UIView!
    @IBOutlet weak var fourthCellExpenseLabel: UILabel!
    @IBOutlet weak var fourthCellDateLabel: UILabel!
    
    //MARK: - Properties
    private let dbManager: DBManagerPaymentsProtocol & DBManagerCategoriesProtocol = DBManager()
    private let realm = DBManager().realm
    
    // MARK: - OverrideMethods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainStackview.layer.cornerRadius = 10
        firstCellView.layer.cornerRadius = 10
        secondCellView.layer.cornerRadius = 10
        thirdCellView.layer.cornerRadius = 10
        fourthCellView.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        totalBalance.text = String(dbManager.getTotalBalance())
        firstCellLabel.text = dbManager.getTotalIncome()
        secondCellLabel.text = dbManager.getTotalExpense()
        thirdCellIncomeLabel.text = dbManager.getMaxIncome()
        thirdCellDateLabel.text = dbManager.getDateForMaxIncome()
        fourthCellExpenseLabel.text = dbManager.getMaxExpense()
        fourthCellDateLabel.text = dbManager.getDateForMaxExpense()
    }
    
    //MARK: - IBActions
    @IBAction func firstCellButtonAction() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let secondVc = storyboard.instantiateViewController(withIdentifier: "IncomesVC") as! IncomesVC
        present(secondVc, animated: true, completion: nil)
    }
}
