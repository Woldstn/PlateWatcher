//
//  SettingsView.swift
//  PlateWatcher
//
//  Created by Zachary Pierog on 2021/06/03.
//  Copyright © 2021 Zachary Pierog. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var showingWeekdaySelection = false
    @State private var showingDataKeepPeriod = false
    @State private var showingDataSaveNotification = false
    @State private var showingDefaultSettingsAlert = false
    @State private var showingDataDeletionAlert = false
    @State var startWeekday = UserDefaults.standard.integer(forKey: "start weekday")
    @State var monthStart = UserDefaults.standard.integer(forKey: "month start")
    @State var dataPeriod = UserDefaults.standard.integer(forKey: "data period")
    var userSettings = UserDefaults.standard
    
    @FetchRequest(
        entity: DateData.entity(),
        sortDescriptors: [
            NSSortDescriptor(
                keyPath: \DateData.datetime,
                ascending: false
            )
        ]
    ) var dateData: FetchedResults<DateData>
    
    let parent: MainView
    
    var body: some View {
        NavigationView {
            VStack (spacing: 0) {
                Form {
                    Section {
                        HStack {
                            Text("start-of-week")
                            Spacer()
                            Text(LocalizedStringKey(Weekdays.init(rawValue: startWeekday)?.key() ?? "sunday"))
                            Text("⤵︎").foregroundColor(Color.gray)
                        }.onTapGesture {
                            self.showingWeekdaySelection = true
                        }.actionSheet(isPresented: $showingWeekdaySelection) {
                            ActionSheet(
                                title: Text("start-of-week"),
                                message: nil,
                                buttons: getWeekdayButtons()
                            )
                        }
                        Stepper(
                            onIncrement: {if monthStart < 31 {monthStart += 1}},
                            onDecrement: {if monthStart > 1 {monthStart -= 1}}
                        ) {
                            HStack {
                                Text("start-of-month")
                                Spacer()
                                Text("\(monthStart)")
                            }
                        }
                        HStack {
                            Text("data-period-label")
                            Spacer()
                            Text(LocalizedStringKey(DataPeriod.init(rawValue: dataPeriod)?.key() ?? "two-weeks"))
                            Text("⤵︎").foregroundColor(Color.gray)
                        }.onTapGesture {
                            self.showingDataKeepPeriod = true
                        }.actionSheet(isPresented: $showingDataKeepPeriod) {
                            ActionSheet(
                                title: Text("data-period-label"),
                                message: nil,
                                buttons: getDataPeriodButtons()
                            )
                        }
                    }
                    Section {
                        Button(
                            action: saveSettings,
                            label: {
                                HStack {
                                    Spacer()
                                    Text("save-changes")
                                    Spacer()
                                }
                            }
                        ).alert(
                            isPresented: $showingDataSaveNotification,
                            content: {
                                Alert(
                                    title: Text("save-alert-title"),
                                    message: Text("save-alert-msg")
                                )
                            }
                        )
                        Button(
                            action: discardChanges,
                            label: {
                                HStack {
                                    Spacer()
                                    Text("discard-changes")
                                        .foregroundColor(.orange)
                                    Spacer()
                                }
                            }
                        )
                    }
                    Section {
                        Button(
                            action: {showingDefaultSettingsAlert = true},
                            label: {
                                HStack {
                                    Spacer()
                                    Text("reset-settings").foregroundColor(.red)
                                    Spacer()
                                }
                            }
                        ).alert(
                            isPresented: $showingDefaultSettingsAlert,
                            content: {
                                Alert(
                                    title: Text("alert-title"),
                                    message: Text("reset-alert"),
                                    primaryButton: .destructive(
                                        Text("reset-settings-button"),
                                        action: setToDefault
                                    ),
                                    secondaryButton: .cancel(Text("cancel-button"))
                                )
                            }
                        )
                        Button(
                            action: {showingDataDeletionAlert = true},
                            label: {
                                HStack {
                                    Spacer()
                                    Text("delete-data").foregroundColor(.red)
                                    Spacer()
                                }
                            }
                        ).alert(
                            isPresented: $showingDataDeletionAlert,
                            content: {
                                Alert(
                                    title: Text("alert-title"),
                                    message: Text("delete-data-alert"),
                                    primaryButton: .destructive(
                                        Text("delete-data-button"),
                                        action: deleteAllDateData
                                    ),
                                    secondaryButton: .cancel(Text("cancel-button"))
                                )
                            }
                        )
                    }
                }
            }.navigationTitle("settings-header")
        }
    }
    
    func getWeekdayButtons() -> [ActionSheet.Button] {
        var buttons: [ActionSheet.Button] = []
        for day in Weekdays.allCases {
            buttons.append(.default(
                Text(LocalizedStringKey(day.key())),
                action: {startWeekday = day.rawValue}
            ))
        }
        buttons.append(.cancel())
        return buttons
    }
    
    func getDataPeriodButtons() -> [ActionSheet.Button] {
        var buttons: [ActionSheet.Button] = []
        for pd in DataPeriod.allCases {
            buttons.append(.default(
                Text(LocalizedStringKey(pd.key())),
                action: {dataPeriod = pd.rawValue}
            ))
        }
        buttons.append(.cancel())
        return buttons
    }
    
    func saveSettings() {
        userSettings.set(startWeekday, forKey: "start weekday")
        userSettings.set(monthStart, forKey: "month start")
        userSettings.set(dataPeriod, forKey: "data period")
        showingDataSaveNotification = true
        parent.selectedTab = "home"
    }
    
    func discardChanges() {
        startWeekday = userSettings.integer(forKey: "start weekday")
        monthStart = userSettings.integer(forKey: "month start")
        dataPeriod = userSettings.integer(forKey: "data period")
        parent.selectedTab = "home"
    }
    
    func setToDefault() {
        userSettings.set(1, forKey: "start weekday")
        userSettings.set(1, forKey: "month start")
        userSettings.set(2, forKey: "data period")
        startWeekday = 1
        monthStart = 1
        dataPeriod = 2
        parent.selectedTab = "home"
    }
    
    func deleteAllDateData() {
        for date in dateData {
            managedObjectContext.delete(date)
        }
        do {
            try managedObjectContext.save()
        } catch {
            print("ゴールは削除できませんでした。\n\(error.localizedDescription)")
        }
        
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SettingsView(parent: MainView())
            SettingsView(parent: MainView())
                .environment(\.colorScheme, .dark)
        }
    }
}
