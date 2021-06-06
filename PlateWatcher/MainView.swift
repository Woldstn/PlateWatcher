//
//  MainView.swift
//  PlateWatcher
//
//  Created by Zachary Pierog on 2021/06/01.
//  Copyright © 2021 Zachary Pierog. All rights reserved.
//

import SwiftUI

extension Calendar {
    func startOfWeek(for date: Date) -> Date? {
        return Calendar.current.startOfDay(for: self.nextDate(
            after: self.startOfDay(for: date),
            matching: DateComponents(
                calendar: self,
                weekday: 1
            ),
            matchingPolicy: .previousTimePreservingSmallerComponents,
            direction: .backward
        )!)
    }
    
    func startOfMonth(for date: Date) -> Date? {
        return Calendar.current.startOfDay(for: self.nextDate(
            after: self.startOfDay(for: date),
            matching: DateComponents(
                calendar: self,
                day: 1
            ),
            matchingPolicy: .previousTimePreservingSmallerComponents,
            direction: .backward
        )!)
    }
}

struct MainView: View {
    init() {
        UINavigationBar.appearance().backgroundColor = UIColor(named: "TitleColor")
        let userSettings = UserDefaults.standard
        let startWeekday = userSettings.string(forKey: "start weekday")
        if startWeekday == nil {userSettings.set("日曜日", forKey: "start weekday")}
        let startDate = userSettings.integer(forKey: "month start")
        if startDate == 0 {userSettings.set(1, forKey: "month start")}
        let dataPeriod = userSettings.string(forKey: "data period")
        if dataPeriod == nil {userSettings.set("2週間", forKey: "data period")}
    }
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var selectedTab = "home"
    
    @FetchRequest(
        entity: DateData.entity(),
        sortDescriptors: [
            NSSortDescriptor(
                keyPath: \DateData.datetime,
                ascending: false
            )
        ]
    ) var dateData: FetchedResults<DateData>
    
    var body: some View {
        var todayData = getTodayData()
        
        TabView(selection: $selectedTab) {
            ContentView(dateData: todayData).tabItem {
                Image(systemName: "house.fill")
            }.tag("home")
            AddGoalForm(parent: self, dateData: todayData).tabItem {
                Image(systemName: "plus.circle.fill")
            }.tag("new goal")
            GraphView().tabItem {
                Image(systemName: "chart.bar.xaxis")
            }.tag("graph")
            SettingsView(parent: self).tabItem {
                Image(systemName: "gearshape.fill")
            }.tag("settings")
        }.onReceive(
            NotificationCenter.default.publisher(
                for: UIApplication.willEnterForegroundNotification
            ),
            perform: { _ in
                todayData = getTodayData()
            }
        )
    }
    
    func copyGoalData(_ sourceGoal: Goal) -> Goal {
        let newGoal = Goal(context: managedObjectContext)
        newGoal.title = sourceGoal.title
        newGoal.goal = sourceGoal.goal
        newGoal.goalPeriod = sourceGoal.goalPeriod
        newGoal.goalType = sourceGoal.goalType
        newGoal.image = sourceGoal.image
        newGoal.servings = sourceGoal.servings
        return newGoal
    }
    
    func newDateDataFromPrev(_ sourceDateData: DateData) -> DateData {
        // Create new DateData entity and set the date to today
        let newDateData = DateData(context: managedObjectContext)
        newDateData.datetime = Calendar.current.startOfDay(for: Date())
        // Copy each of the Goals from the source data
        for goal in (sourceDateData as DateData).goals ?? [] {
            if let sourceGoal = goal as? Goal {
                let newGoal = copyGoalData(sourceGoal)
                // Reset the servings attribute based on the goal period
                switch GoalPeriod(rawValue: newGoal.goalPeriod) {
                case .day:
                    newGoal.servings = 0
                case .week:
                    if let sourceDate = sourceDateData.datetime {
                        let sourceWeek = Calendar.current.startOfWeek(for: sourceDate)
                        let thisWeek = Calendar.current.startOfWeek(for: Date())
                        if sourceWeek == thisWeek {
                            newGoal.servings = 0
                        }
                    }
                case .month:
                    if let sourceDate = sourceDateData.datetime {
                        let sourceMonth = Calendar.current.startOfMonth(for: sourceDate)
                        let thisMonth = Calendar.current.startOfMonth(for: Date())
                        if sourceMonth == thisMonth {
                            newGoal.servings = 0
                        }
                    }
                case .none:
                    break
                }
                // Add the new Goal to the new DateData
                newDateData.addToGoals(newGoal)
            }
        }
        // Return the new DateData
        return newDateData
    }
    
    func getTodayData() -> DateData {
        if let lastDateData = dateData.first {
            // Assign today's date and the date of the last data to variables
            let lastDate = Calendar.current.startOfDay(for: lastDateData.datetime!)
            let todayDate = Calendar.current.startOfDay(for: Date())
            // If the dates are the same, use the most recent data
            if lastDate == todayDate {
                return lastDateData
            }
            // If they are different, copy the most recent data
            return newDateDataFromPrev(lastDateData)
        }
        // If no DateData was found, return an empty DateData object
        let dateObj = DateData(context: managedObjectContext)
        dateObj.datetime = Calendar.current.startOfDay(for: Date())
        return dateObj
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return MainView().environment(\.managedObjectContext, context)
    }
}
