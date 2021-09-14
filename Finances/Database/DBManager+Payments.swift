

import RealmSwift

protocol DBManagerPaymentsProtocol {
    func saveIncome(sum: Int, name: String, date: String)
    func saveExpense(sum: Int, category: String, name: String, date: String)
    func saveTotalBalance(amount: Int)
    func getIncomes() -> [PaymentObject]
    func getExpenses() -> [PaymentObject]
    func getCategories() -> [PaymentCategoryObject]
}

extension DBManager: DBManagerPaymentsProtocol {

    func saveIncome(sum: Int, name: String, date: String) {
        let income = PaymentObject()
        income.sum = sum
        income.name = name
        income.date = date
        income.type = PaymentType.income.rawValue
        try? realm.write({ () -> Void in
            realm.add(income)
        })
    }

    func saveExpense(sum: Int, category: String, name: String, date: String) {
        let expense = PaymentObject()
        expense.sum = sum
        expense.category = category
        expense.name = name
        expense.date = date
        expense.type = PaymentType.expense.rawValue
        try? realm.write({ () -> Void in
            realm.add(expense)
        })
    }
    
    func saveTotalBalance(amount: Int) {
        let totalBalance = TotalAmountObject()
        totalBalance.amount = amount
        try? realm.write({ () -> Void in
            realm.add(totalBalance)
        })
    }

    func getIncomes() -> [PaymentObject] {
        let objects = realm.objects(PaymentObject.self).filter("type = %d", PaymentType.income.rawValue)
        return Array(objects)
    }

    func getExpenses() -> [PaymentObject] {
        let objects = realm.objects(PaymentObject.self).filter("type = %d", PaymentType.expense.rawValue)
        return Array(objects)
    }
    
    func getCategories() -> [PaymentCategoryObject] {
            let object = realm.objects(PaymentCategoryObject.self)
            return Array(object)
    }
}

enum PaymentType: String {
    case income = "income"
    case expense = "expense"
    case totalBalance = "totalBalance"
}
