//
//  MainView.swift
//  PlateWatcher
//
//  Created by Zachary Pierog on 2021/06/01.
//  Copyright © 2021 Zachary Pierog. All rights reserved.
//

import SwiftUI

extension Calendar {
    func startOfWeek(for date: Date) -> Date {
        var weekday = UserDefaults.standard.integer(forKey: "start weekday")
        if weekday == 0 { weekday = 1 }
        return self.startOfDay(for: self.nextDate(
            after: self.startOfDay(for: date),
            matching: DateComponents(
                calendar: self,
                weekday: weekday
            ),
            matchingPolicy: .previousTimePreservingSmallerComponents,
            direction: .backward
        )!)
    }
    
    func startOfMonth(for date: Date) -> Date {
        var day = UserDefaults.standard.integer(forKey: "month start")
        if day == 0 { day = 1 }
        return self.startOfDay(for: self.nextDate(
            after: self.startOfDay(for: date),
            matching: DateComponents(
                calendar: self,
                day: day
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
        let startWeekday = userSettings.integer(forKey: "start weekday")
        if startWeekday == 0 {userSettings.set(1, forKey: "start weekday")}
        let startDate = userSettings.integer(forKey: "month start")
        if startDate == 0 {userSettings.set(1, forKey: "month start")}
        let dataPeriod = userSettings.integer(forKey: "data period")
        if dataPeriod == 0 {userSettings.set(2, forKey: "data period")}
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
        TabView(selection: $selectedTab) {
            ContentView(parent: self).tabItem {
                Image(systemName: "house.fill")
            }.tag("home")
            AddGoalForm(parent: self).tabItem {
                Image(systemName: "plus.circle.fill")
            }.tag("new goal")
            GraphView().tabItem {
                Image(systemName: "chart.bar.xaxis")
            }.tag("graph")
            SettingsView(parent: self).tabItem {
                Image(systemName: "gearshape.fill")
            }.tag("settings")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return Group {
            MainView()
                .environment(\.managedObjectContext, context)
            MainView()
                .environment(\.managedObjectContext, context)
                .environment(\.colorScheme, .dark)
        }
    }
}
