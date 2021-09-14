

import UIKit

extension UIViewController {
    func alertEnterCategory(completion: @escaping (String?) -> Void) {
        let alert = UIAlertController(title: "Type new category", message: nil, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            completion(alert.textFields?[0].text)
        }))
        alert.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
            textField.placeholder = "Name of category"
        })
        self.present(alert, animated: true, completion: nil)
    }

    func alertEnterIncome(completion: @escaping (String?, String?, String?) -> Void) {
        let alert = UIAlertController(title: "Type new income", message: nil, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            completion(alert.textFields?[0].text, alert.textFields?[1].text, alert.textFields?[2].text)
        }))
        alert.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
            textField.placeholder = "Type of income"
        })
        alert.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
            textField.placeholder = "Amount"
        })
        alert.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
            textField.placeholder = "Date"
        })
        self.present(alert, animated: true, completion: nil)
    }

    func alertEnterExpense(completion: @escaping (String?, String?, String?) -> Void) {
        let alert = UIAlertController(title: "Type new expense", message: nil, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            completion(alert.textFields?[0].text, alert.textFields?[1].text, alert.textFields?[2].text)
        }))
        alert.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
            textField.placeholder = "Type of expense"
        })
        alert.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
            textField.placeholder = "Amount"
        })
        alert.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
            textField.placeholder = "Date"
        })
        self.present(alert, animated: true, completion: nil)
    }
}
