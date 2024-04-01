//
//  String+Extensions.swift
//  BudgetApp
//
//  Created by Piyush Pandey on 24/03/24.
//

import Foundation

extension String {
    
    var isNumeric: Bool {
        Double(self) != nil
    }
    
    func isGreaterThan(_ value: Double) -> Bool {
        guard self.isNumeric else {
            return false
        }
        return Double(self)! > value
    }
}
