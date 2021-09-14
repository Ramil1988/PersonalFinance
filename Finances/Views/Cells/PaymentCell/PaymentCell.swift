

import UIKit

class PaymentCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sumLabel: UILabel!
    
    // MARK: - Public
    func configure(data: PaymentObject) {
        nameLabel.text = data.name
        dateLabel.text = data.date
        sumLabel.text = "\(abs(data.sum))"
    }
}
