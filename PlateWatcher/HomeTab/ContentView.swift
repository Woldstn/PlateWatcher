//
//  ContentView.swift
//  PlateWatcher
//
//  Created by Zachary Pierog on 2020/08/11.
//  Copyright © 2020 Zachary Pierog. All rights reserved.
//

import AVFoundation
import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    let parent: MainView
    
    var body: some View {
        NavigationView {
            VStack (spacing: 0) {
                List {
                    Section(
                        header:
                            SectionHeader(
                                title: "daily-goals",
                                reset: {resetGoals(period: .day)}
                            )
                            .textCase(nil)
                            .listRowInsets(EdgeInsets())
                    ) {
                        let dayGoals = getGoals(period: .day)
                        if dayGoals.count == 0 {
                            Text("no-daily-goal-msg")
                        } else {
                            ForEach(dayGoals, id: \.self) { goal in
                                NutrientRow(goal: goal)
                            }
                            .onDelete(perform: { indexSet in
                                deleteGoals(at: indexSet, goals: dayGoals)
                            })
                            .listRowInsets(EdgeInsets())
                        }
                    }
                    Section(
                        header:
                            SectionHeader(
                                title: "weekly-goals",
                                reset: {resetGoals(period: .week)}
                            )
                            .textCase(nil)
                            .listRowInsets(EdgeInsets())
                    ) {
                        let weekGoals = getGoals(period: .week)
                        if weekGoals.count == 0 {
                            Text("no-weekly-goal-msg")
                        } else {
                            ForEach(weekGoals, id: \.self) { goal in
                                NutrientRow(goal: goal)
                            }
                            .onDelete(perform: { indexSet in
                                deleteGoals(at: indexSet, goals: weekGoals)
                            })
                            .listRowInsets(EdgeInsets())
                        }
                    }
                    Section(
                        header:
                            SectionHeader(
                                title: "monthly-goals",
                                reset: {resetGoals(period: .month)}
                            )
                            .textCase(nil)
                            .listRowInsets(EdgeInsets())
                    ) {
                        let monthGoals = getGoals(period: .month)
                        if monthGoals.count == 0 {
                            Text("no-monthly-goal-msg")
                        } else {
                            ForEach(monthGoals, id: \.self) { goal in
                                NutrientRow(goal: goal)
                            }
                            .onDelete(perform: { indexSet in
                                deleteGoals(at: indexSet, goals: monthGoals)
                            })
                            .listRowInsets(EdgeInsets())
                        }
                    }
                }.listStyle(GroupedListStyle())
            }.navigationTitle("PlateWatcher")
        }
        .accentColor(Color.white)
        .navigationViewStyle(StackNavigationViewStyle())
    }

    func resetGoals(period: GoalPeriod) {
        for goal in getGoals(period: period) {
            goal.servings = 0
        }
        AudioServicesPlaySystemSound(1123)
        saveContext(context: managedObjectContext, errorMsg: "ゴールはリセットできませんでした。")
    }
    
    func deleteGoals(at offsets: IndexSet, goals: Array<Goal>) {
        for i in offsets {
            managedObjectContext.delete(goals[i])
        }
        saveContext(context: managedObjectContext, errorMsg: "ゴールは削除できませんでした。")
    }
    
    func getGoals(period: GoalPeriod) -> Array<Goal> {
        if let goals = getTodayData(dateData: parent.dateData, context: managedObjectContext).goals {
            let pGoals = goals.filter { ($0 as! Goal).goalPeriod == period.rawValue }
            return pGoals.map { $0 as! Goal }
        }
        return []
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let parent = MainView()
        return Group {
            ContentView(parent: parent)
                .environment(\.managedObjectContext, context)
            ContentView(parent: parent)
                .environment(\.managedObjectContext, context)
                .environment(\.colorScheme, .dark)
        }
    }
}
