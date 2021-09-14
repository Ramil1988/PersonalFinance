

import RealmSwift

class PaymentCategoryObject: Object {
    @objc dynamic var name = ""
    let paymentObjects = List<PaymentObject>()
}

class TotalAmountObject: Object {
    @objc dynamic var amount = 0
}
