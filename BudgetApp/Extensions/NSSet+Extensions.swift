//
//  NSSet+Extensions.swift
//  BudgetApp
//
//  Created by Piyush Pandey on 31/03/24.
//

import Foundation

extension NSSet {
    
    func toArray<T>() -> [T] {
        let array = self.map {$0 as! T}
        return array
    }
    
}
