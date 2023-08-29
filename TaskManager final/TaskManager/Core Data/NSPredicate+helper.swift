//
//  NSPredicate+helper.swift
//  TaskManager
//
//  Created by Karin Prater on 22.08.2023.
//

import Foundation

extension NSPredicate {
    
    static let all = NSPredicate(format: "TRUEPREDICATE")
    static let none = NSPredicate(format: "FALSEPREDICATE")
    
}
