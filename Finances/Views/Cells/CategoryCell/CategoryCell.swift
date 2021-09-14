

import Foundation
import UIKit

class CategoryCell: UITableViewCell {
    
    @IBOutlet weak var nameCategory: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    func configure(data: PaymentCategoryObject) {
        nameCategory.text = data.name
        var totalAmount: Int = 0
       
        for paymentObject in data.paymentObjects {
            totalAmount += paymentObject.sum
        }
        totalAmount = abs(totalAmount)
        totalAmountLabel.text = totalAmount.description
    }
}
