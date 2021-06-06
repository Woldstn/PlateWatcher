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
    @State var startWeekday = UserDefaults.standard.string(forKey: "start weekday")
    @State var startDate = UserDefaults.standard.integer(forKey: "month start")
    @State var dataPeriod = UserDefaults.standard.string(forKey: "data period")
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
                            Text("週の初曜日")
                            Spacer()
                            Text(startWeekday ?? "日曜日")
                            Text("⤵︎").foregroundColor(Color.gray)
                        }.onTapGesture {
                            self.showingWeekdaySelection = true
                        }.actionSheet(isPresented: $showingWeekdaySelection) {
                            ActionSheet(
                                title: Text("週の初曜日"),
                                message: nil,
                                buttons: [
                                    .default(Text("日曜日"), action: {startWeekday = "日曜日"}),
                                    .default(Text("月曜日"), action: {startWeekday = "月曜日"}),
                                    .default(Text("火曜日"), action: {startWeekday = "火曜日"}),
                                    .default(Text("水曜日"), action: {startWeekday = "水曜日"}),
                                    .default(Text("木曜日"), action: {startWeekday = "木曜日"}),
                                    .default(Text("金曜日"), action: {startWeekday = "金曜日"}),
                                    .default(Text("土曜日"), action: {startWeekday = "土曜日"}),
                                    .cancel()
                                ]
                            )
                        }
                        Stepper(
                            onIncrement: {if startDate < 31 {startDate += 1}},
                            onDecrement: {if startDate > 1 {startDate -= 1}}
                        ) {
                            HStack {
                                Text("月の初日")
                                Spacer()
                                Text("\(startDate)")
                            }
                        }
                        HStack {
                            Text("データ保存期間")
                            Spacer()
                            Text(dataPeriod ?? "2週間")
                            Text("⤵︎").foregroundColor(Color.gray)
                        }.onTapGesture {
                            self.showingDataKeepPeriod = true
                        }.actionSheet(isPresented: $showingDataKeepPeriod) {
                            ActionSheet(
                                title: Text("データ保存期間"),
                                message: nil,
                                buttons: [
                                    .default(Text("1週間"), action: {dataPeriod = "1週間"}),
                                    .default(Text("2週間"), action: {dataPeriod = "2週間"}),
                                    .default(Text("1ヶ月"), action: {dataPeriod = "1ヶ月"}),
                                    .default(Text("6ヶ月"), action: {dataPeriod = "6ヶ月"}),
                                    .default(Text("1年間"), action: {dataPeriod = "1年間"}),
                                    .default(Text("2年間"), action: {dataPeriod = "2年間"}),
                                    .default(Text("永久に"), action: {dataPeriod = "永久に"}),
                                    .cancel()
                                ]
                            )
                        }
                    }
                    Section {
                        Button(
                            action: saveSettings,
                            label: {
                                HStack {
                                    Spacer()
                                    Text("変更を保存")
                                    Spacer()
                                }
                            }
                        ).alert(
                            isPresented: $showingDataSaveNotification,
                            content: {
                                Alert(
                                    title: Text("成功"),
                                    message: Text("設定変更を終了しました。")
                                )
                            }
                        )
                        Button(
                            action: discardChanges,
                            label: {
                                HStack {
                                    Spacer()
                                    Text("変更を破棄").foregroundColor(.orange)
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
                                    Text("設置を初期化").foregroundColor(.red)
                                    Spacer()
                                }
                            }
                        ).alert(
                            isPresented: $showingDefaultSettingsAlert,
                            content: {
                                Alert(
                                    title: Text("注意"),
                                    message: Text("設定は初期化されます。よろしいでしょうか？"),
                                    primaryButton: .destructive(
                                        Text("初期化"),
                                        action: setToDefault
                                    ),
                                    secondaryButton: .cancel(Text("キャンセル"))
                                )
                            }
                        )
                        Button(
                            action: {showingDataDeletionAlert = true},
                            label: {
                                HStack {
                                    Spacer()
                                    Text("データを削除").foregroundColor(.red)
                                    Spacer()
                                }
                            }
                        ).alert(
                            isPresented: $showingDataDeletionAlert,
                            content: {
                                Alert(
                                    title: Text("注意"),
                                    message: Text("保存されたデータは全部削除されます。よろしいでしょうか？"),
                                    primaryButton: .destructive(
                                        Text("削除"),
                                        action: deleteAllDateData
                                    ),
                                    secondaryButton: .cancel(Text("キャンセル"))
                                )
                            }
                        )
                    }
                }
            }.navigationBarTitle("設定")
        }
    }
    
    func saveSettings() {
        userSettings.set(startWeekday, forKey: "start weekday")
        userSettings.set(startDate, forKey: "month start")
        userSettings.set(dataPeriod, forKey: "data period")
        showingDataSaveNotification = true
        parent.selectedTab = "home"
    }
    
    func discardChanges() {
        startWeekday = userSettings.string(forKey: "start weekday")
        startDate = userSettings.integer(forKey: "month start")
        dataPeriod = userSettings.string(forKey: "data period")
        parent.selectedTab = "home"
    }
    
    func setToDefault() {
        userSettings.set("日曜日", forKey: "start weekday")
        userSettings.set(1, forKey: "month start")
        userSettings.set("2週間", forKey: "data period")
        startWeekday = "日曜日"
        startDate = 1
        dataPeriod = "2週間"
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
        SettingsView(parent: MainView())
    }
}
