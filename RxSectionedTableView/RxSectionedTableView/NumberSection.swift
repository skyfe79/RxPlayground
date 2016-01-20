//
//  NumberSection.swift
//  RxSectionedTableView
//
//  Created by burt.k(Sungcheol Kim) on 2016. 1. 20..
//  Copyright © 2016년 burt. All rights reserved.
//

import Foundation
import RxDataSources

// MARK: Data

struct NumberSection {
    var header: String
    var numbers: [IntItem]
    var updated: NSDate
    
    init(header: String, numbers: [IntItem], updated: NSDate) {
        self.header = header
        self.numbers = numbers
        self.updated = updated
    }
}

struct IntItem {
    let number: Int
    let date: NSDate
}

// MARK: Just extensions to say how to determine identity and how to determine is entity updated

extension NumberSection : AnimatableSectionModelType {
    typealias Item = IntItem
    typealias Identity = String
    
    var identity: String {
        return header
    }
    
    var items: [IntItem] {
        return numbers
    }
    
    init(original: NumberSection, items: [Item]) {
        self = original
        self.numbers = items
    }
}

extension IntItem : IdentifiableType, Equatable {
    typealias Identity = Int
    
    var identity: Int {
        return number
    }
}



func == (lhs: IntItem, rhs: IntItem) -> Bool {
    return lhs.number == rhs.number && lhs.date.isEqualToDate(rhs.date)
}

extension IntItem : CustomDebugStringConvertible {
    var debugDescription: String {
        return "IntItem(number: \(number), data: date)"
    }
}