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
    
    func key() -> String {
        switch self {
        case .day:
            return "day-period"
        case .week:
            return "week-period"
        case .month:
            return "month-period"
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

enum Weekdays: Int, CaseIterable {
    case sun = 1, mon, tue, wed, thu, fri, sat
    
    func key() -> String {
        switch self {
        case .sun:
            return "sunday"
        case .mon:
            return "monday"
        case .tue:
            return "tuesday"
        case .wed:
            return "wednesday"
        case .thu:
            return "thursday"
        case .fri:
            return "friday"
        case .sat:
            return "saturday"
        }
    }
}

enum DataPeriod: Int, CaseIterable {
    case oneWeek = 1, twoWeeks, oneMonth, sixMonths, oneYear, twoYears, forever
    
    func key() -> String {
        switch self {
        case .oneWeek:
            return "one-week"
        case .twoWeeks:
            return "two-weeks"
        case .oneMonth:
            return "one-month"
        case .sixMonths:
            return "six-months"
        case .oneYear:
            return "one-year"
        case .twoYears:
            return "two-years"
        case .forever:
            return "forever"
        }
    }
}
