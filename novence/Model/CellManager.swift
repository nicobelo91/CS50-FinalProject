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
        
        switch time {
        case _ where time < 0:
            return "39311d"
        case _ where time < 259200.0:
            return "ac4b1c"
        case _ where time < 604800.0:
            return "fca652"
        case _ where time < 1296000.0:
            return "ffd57e"
        default:
            return "ffefa0"
        }
        
    }

    mutating func expirationDateText(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let formatteddate = formatter.string(from: date)
        return formatteddate
    }
}
