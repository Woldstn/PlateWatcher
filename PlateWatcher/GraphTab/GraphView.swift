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
    @Environment(\.colorScheme) var colorScheme
    @State var fromDate: Date = Calendar.current.startOfDay(for: Date().addingTimeInterval(-3600 * 24 * 7))
    @State var toDate: Date = Calendar.current.startOfDay(for: Date())
    
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
                GoalGraph(data: [5, 2, 4, 7, 3, 8, 6])
                    .aspectRatio(1.4, contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                    .cornerRadius(10)
                    .padding(10)
                HStack {
                    Spacer()
                    DatePicker(
                        "From",
                        selection: $fromDate,
                        displayedComponents: [.date]
                    )
                    .labelsHidden()
                    Text(" ~ ")
                    DatePicker(
                        "To",
                        selection: $toDate,
                        displayedComponents: [.date]
                    )
                    .labelsHidden()
                    Spacer()
                }
                List {
                    
                }
            }.navigationTitle("chart-header")
        }
    }
    
    var dateDataInPeriod: [DateData] {
        get { return dateData.filter { period.contains($0.datetime!) } }
    }
    
    var period: DateInterval {
        get { return DateInterval(start: fromDate, end: toDate) }
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            GraphView().preferredColorScheme($0)
        }
    }
}
