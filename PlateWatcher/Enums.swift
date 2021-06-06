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

enum Weekdays: Int, CaseIterable {
    case sun = 1, mon, tue, wed, thu, fri, sat
    
    func string() -> String {
        switch self {
        case .sun:
            return "日曜日"
        case .mon:
            return "月曜日"
        case .tue:
            return "火曜日"
        case .wed:
            return "水曜日"
        case .thu:
            return "木曜日"
        case .fri:
            return "金曜日"
        case .sat:
            return "土曜日"
        }
    }
}

enum DataPeriod: Int, CaseIterable {
    case oneWeek = 1, twoWeeks, oneMonth, sixMonths, oneYear, twoYears, forever
    
    func string() -> String {
        switch self {
        case .oneWeek:
            return "1週間"
        case .twoWeeks:
            return "2週間"
        case .oneMonth:
            return "1ヶ月"
        case .sixMonths:
            return "2ヶ月"
        case .oneYear:
            return "1年間"
        case .twoYears:
            return "2年間"
        case .forever:
            return "永久に"
        }
    }
}
