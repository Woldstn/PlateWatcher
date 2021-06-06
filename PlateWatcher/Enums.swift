//
//  GoalEnums.swift
//  PlateWatcher
//
//  Created by Zachary Pierog on 2021/05/22.
//  Copyright © 2021 Zachary Pierog. All rights reserved.
//

import Foundation

enum GoalPeriod: Int16, CaseIterable {
    case day = 1, week, month
    
    func string() -> String {
        switch self {
        case .day:
            return "日間"
        case .week:
            return "週間"
        case .month:
            return "月間"
        }
    }
}

enum GoalType: Int16, CaseIterable {
    case lt = 1, le, eq, ge, gt, ne
    
    func string() -> String {
        switch self {
        case .lt:
            return "<"
        case .le:
            return "≦"
        case .eq:
            return "="
        case .ge:
            return "≧"
        case .gt:
            return ">"
        case .ne:
            return "≠"
        }
    }
}
