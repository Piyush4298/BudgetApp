//
//  BudgetCategory+CoreDataClass.swift
//  BudgetApp
//
//  Created by Piyush Pandey on 31/03/24.
//

import Foundation
import CoreData

@objc(BudgetCategory)
public class BudgetCategory: NSManagedObject {
    
    public var totalTransactionAmount: Double {
        let transactionArray: [Transaction] = transactions?.toArray() ?? []
        return transactionArray.reduce(0){ next, transaction in
            next + transaction.amount
        }
    }
    
    public var remainingAmount: Double {
        return amount - totalTransactionAmount
    }
}
