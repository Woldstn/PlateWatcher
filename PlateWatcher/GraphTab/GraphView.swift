//
//  GraphView.swift
//  PlateWatcher
//
//  Created by Zachary Pierog on 2021/06/01.
//  Copyright © 2021 Zachary Pierog. All rights reserved.
//

import CoreData
import SwiftUI

struct GraphView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var fromDate: Date = Calendar.current.startOfDay(for: Date().addingTimeInterval(-3600 * 24 * 14))
    @State var toDate: Date = Calendar.current.startOfDay(for: Date())
    @State var selectedGoal: String = NSLocalizedString("Choose goal", comment: "")
    @State var showGraph: Bool = false
    @State var goalData: [Goal] = []
    
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
        NavigationView {
            VStack {
                Text("Date Range").padding(.top, 5)
                HStack {
                    Spacer()
                    DatePicker(
                        "From",
                        selection: $fromDate,
                        displayedComponents: [.date]
                    ).labelsHidden()
                    Text(" ~ ")
                    DatePicker(
                        "To",
                        selection: $toDate,
                        displayedComponents: [.date]
                    ).labelsHidden()
                    Spacer()
                }
                Menu(selectedGoal) {
                    ForEach(goalTypes, id: \.self) { gtype in
                        Button(gtype, action: {
                            selectedGoal = gtype
                            configureGraph()
                        })
                    }
                }
                .padding(.all, 10)
                .background(
                    RoundedRectangle(
                        cornerRadius: 5
                    ).stroke(
                        Color.blue,
                        lineWidth: 2
                    )
                )
                if showGraph {
                    GoalGraph(data: [1, 5, 3, 4])
                        .cornerRadius(10)
                        .padding(.horizontal, 10.0)
                        .aspectRatio(1.4, contentMode: .fit)
                }
                Spacer()
            }.navigationTitle("chart-header")
        }
    }
    
    func configureGraph() {
        showGraph = !(selectedGoal == NSLocalizedString("Choose goal", comment: ""))
        goalData.removeAll()
        for date in dateDataInPeriod {
            let goals = date.goals
            for goal in goals! {
                guard let goal = (goal as? Goal) else { continue }
                if goal.title == selectedGoal {
                    goalData.append(goal)
                }
            }
        }
    }
    
    var goalTypes: [String] {
        get {
            var goalArray = [
                NSLocalizedString("Choose goal", comment: "")
            ]
            dateData.forEach { date in
                guard let goals = date.goals else { return }
                goals.forEach { goal in
                    guard let newGoal = goal as? Goal else { return }
                    guard let title = newGoal.title else { return }
                    if !goalArray.contains(title) {
                        goalArray.append(title)
                    }
                }
            }
            return goalArray
        }
    }
    
    var dateDataInPeriod: [DateData] {
        get {
            return dateData.filter {
                period.contains($0.datetime!)
            }
        }
    }
    
    var period: DateInterval {
        get {
            return DateInterval(
                start: fromDate,
                end: toDate
            )
        }
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            GraphView().preferredColorScheme($0)
        }
    }
}
