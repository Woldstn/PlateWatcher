//
//  ContentView.swift
//  PlateWatcher
//
//  Created by Zachary Pierog on 2020/08/11.
//  Copyright © 2020 Zachary Pierog. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    let dateData: DateData
    
    var body: some View {
        NavigationView {
            VStack (spacing: 0) {
                List {
                    Section(
                        header:
                            SectionHeader(
                                title: "日間ゴール",
                                reset: {resetGoals(period: .day)}
                            ).listRowInsets(EdgeInsets())
                    ) {
                        let dayGoals = getGoals(period: .day)
                        if dayGoals.count == 0 {
                            Text("日間ゴールはまだありません。")
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
                                title: "週間ゴール",
                                reset: {resetGoals(period: .week)}
                            ).listRowInsets(EdgeInsets())
                    ) {
                        let weekGoals = getGoals(period: .week)
                        if weekGoals.count == 0 {
                            Text("週間ゴールはまだありません。")
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
                                title: "月間ゴール",
                                reset: {resetGoals(period: .month)}
                            ).listRowInsets(EdgeInsets())
                    ) {
                        let monthGoals = getGoals(period: .month)
                        if monthGoals.count == 0 {
                            Text("月間ゴールはまだありません。")
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
                }.listStyle(PlainListStyle())
            }.navigationBarTitle("飲食記録")
        }
        .accentColor(Color.white)
        .navigationViewStyle(StackNavigationViewStyle())
    }

    func resetGoals(period: GoalPeriod) {
        for goal in getGoals(period: period) {
            goal.servings = 0
        }
        saveContext(errorMsg: "ゴールはリセットできませんでした。")
    }
    
    func deleteGoals(at offsets: IndexSet, goals: Array<Goal>) {
        for i in offsets {
            managedObjectContext.delete(goals[i])
        }
        saveContext(errorMsg: "ゴールは削除できませんでした。")
    }
    
    func getGoals(period: GoalPeriod) -> Array<Goal> {
        if let goals = dateData.goals {
            let pGoals = goals.filter { ($0 as! Goal).goalPeriod == period.rawValue }
            return pGoals.map { $0 as! Goal }
        }
        return []
    }

    func saveContext(errorMsg: String) {
        do {
            try managedObjectContext.save()
        } catch {
            print("\(errorMsg)\n\(error.localizedDescription)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let dateData = DateData(context: context)
        return Group {
            ContentView(dateData: dateData).environment(\.managedObjectContext, context)
            ContentView(dateData: dateData)
                .environment(\.managedObjectContext, context)
                .environment(\.colorScheme, .dark)
        }
    }
}
