

import RealmSwift

protocol DBManagerCategoriesProtocol {
    func saveCategory(name: String)
    func saveTotalBalance(amount: Int)
    func getCategories() -> [String]
    func getTotalBalance() -> Int
    func getTotalIncome() -> String
    func getTotalExpense() -> String
    func getMaxIncome() -> String
    func getDateForMaxIncome() -> String
    func getMaxExpense() -> String
    func getDateForMaxExpense() -> String
}

extension DBManager: DBManagerCategoriesProtocol {

    func saveCategory(name: String) {
        let category = PaymentCategoryObject()
        category.name = name
        try? realm.write({ () -> Void in
            realm.add(category)
        })
    }
    
    func saveTotalbalance(amount: Int) {
        let sum = TotalAmountObject()
        sum.amount = amount
        try? realm.write({ () -> Void in
            realm.add(sum)
        })
    }

    func getCategories() -> [String] {
        let objects = realm.objects(PaymentCategoryObject.self)
        var names: [String] = []
        objects.forEach {
            names.append($0.name)
        }
       
        return names
    }
    
    func getTotalBalance() -> Int {
        let payments = realm.objects(PaymentObject.self)
        let expense = payments.filter { $0.type == "expense" }
        let income = payments.filter { $0.type == "income" }
        
        return income.reduce(0, { $0 + $1.sum }) - expense.reduce(0, { $0 + $1.sum })
    }
        
    func getTotalIncome() -> String {
        var totalIncome = ""
        let payments = realm.objects(PaymentObject.self)
        let incomes = payments.filter { $0.type == "income" }
        totalIncome = String(incomes.reduce(0, { $0 + $1.sum }))
    
        return totalIncome
    }
    
    func getTotalExpense() -> String {
        var totalExpense = ""
        let payments = realm.objects(PaymentObject.self)
        let expenses = payments.filter { $0.type == "expense" }
        totalExpense = String(expenses.reduce(0, { $0 + $1.sum }))
        
        return totalExpense
    }
    
    func getMaxIncome() -> String {
        var maxNumber: Int
        let dbManager: DBManagerPaymentsProtocol & DBManagerCategoriesProtocol = DBManager()
        let numbers = dbManager.getIncomes().map { $0.sum }
        
        if numbers.max() != nil {
            maxNumber = numbers.max()!
        } else {
            maxNumber = 0
        }
        return String(maxNumber)
    }
    
    func getDateForMaxIncome() -> String {
        let dbManager: DBManagerPaymentsProtocol & DBManagerCategoriesProtocol = DBManager()
        let numbers = dbManager.getIncomes().map { $0.sum }
        let numbers1 = dbManager.getIncomes().map { $0.date }
        var maxDate = ""
        var maxNumber = 0
        
        if numbers.count != 0 {
            maxNumber = (numbers[0])
        }
        
       
        var indexForDate = 0
        
        for index in 0..<numbers.count {
            if maxNumber <= numbers[index] {
                maxNumber = numbers[index]
                indexForDate = index
                maxDate = String(numbers1[indexForDate])
            }
        }
        return maxDate
    }
    
    func getMaxExpense() -> String {
        var maxNumber: Int
        let dbManager: DBManagerPaymentsProtocol & DBManagerCategoriesProtocol = DBManager()
        let numbers = dbManager.getExpenses().map { $0.sum }
        
        if numbers.max() != nil {
            maxNumber = numbers.max()!
        } else {
            maxNumber = 0
        }
        return String(maxNumber)
    }
    
    func getDateForMaxExpense() -> String {
        let dbManager: DBManagerPaymentsProtocol & DBManagerCategoriesProtocol = DBManager()
        let numbers: [Int]? = dbManager.getExpenses().map { $0.sum }
        let numbers1 = dbManager.getExpenses().map { $0.date }
        var maxDate = ""
        var indexForDate = 0
        var maxNumber = 0
        
        if numbers?.count != 0 {
            maxNumber = (numbers?[0])!
        }
        for index in 0..<numbers!.count {
            if maxNumber <= numbers![index] {
                maxNumber = numbers![index]
                indexForDate = index
                maxDate = String(numbers1[indexForDate])
            }
        }
        return maxDate
    }
}
