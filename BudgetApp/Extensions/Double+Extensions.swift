//
//  Double+Extensions.swift
//  BudgetApp
//
//  Created by Piyush Pandey on 30/03/24.
//

import Foundation

extension Double {
    
    func formatAsCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: self)) ?? "0.00"
    }
}
