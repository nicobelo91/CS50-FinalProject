//
//  CellManager.swift
//  novence
//
//  Created by Nico Cobelo on 07/12/2020.
//

import Foundation

struct CellManager {
    
    var color: String
    
    mutating func chooseBackgroundColor(time: Double) -> String {
        if time < 0 {
            color = "39311d"
            return color
        } else if time < 259200.0 {
            color = "ac4b1c"
            return color
        } else if time < 604800.0 {
            color = "fca652"
            return color
        } else if time < 1296000.0 {
            color = "ffd57e"
            return color
        } else {
            color = "ffefa0"
            return color
        }
        
    }

    mutating func expirationDateText(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let formatteddate = formatter.string(from: date ?? Date(timeIntervalSinceReferenceDate: 0))
        return formatteddate
    }
}
