//
//  AddGoalForm.swift
//  PlateWatcher
//
//  Created by Zachary Pierog on 2020/08/13.
//  Copyright © 2020 Zachary Pierog. All rights reserved.
//

import SwiftUI

struct AddGoalForm: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    let parent: MainView
    let dateData: DateData
    
    @State private var title: String = ""
    @State private var goalPeriod: GoalPeriod = .day
    @State private var goalType: GoalType = .eq
    @State private var goal: Int16 = 0
    @State private var image: String? = nil
    @State private var showingPeriodPicker = false
    @State private var showingTypePicker = false
    @State private var showingImgPicker = false
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            VStack (spacing: 0) {
                Form {
                    TextField("タイトル", text: $title)
                    HStack {
                        Text("期間")
                        Spacer()
                        Text("\(self.goalPeriod.string())")
                        Text("⤵︎").foregroundColor(Color.gray)
                    }.onTapGesture {
                        self.showingPeriodPicker = true
                    }.actionSheet(isPresented: $showingPeriodPicker) {
                        ActionSheet(
                            title: Text("期間"),
                            message: nil,
                            buttons: [
                                .default(Text("日間")) {self.goalPeriod = .day},
                                .default(Text("週間")) {self.goalPeriod = .week},
                                .default(Text("月間")) {self.goalPeriod = .month},
                                .cancel()
                            ]
                        )
                    }
                    HStack {
                        Text("タイプ")
                        Spacer()
                        Text("\(self.goalType.string())")
                        Text("⤵︎").foregroundColor(Color.gray)
                    }.onTapGesture {
                        self.showingTypePicker = true
                    }.actionSheet(isPresented: $showingTypePicker) {
                        ActionSheet(
                            title: Text("タイプ"),
                            message: nil,
                            buttons: [
                                .default(Text("<")) {self.goalType = .lt},
                                .default(Text("≦")) {self.goalType = .le},
                                .default(Text("=")) {self.goalType = .eq},
                                .default(Text("≧")) {self.goalType = .ge},
                                .default(Text(">")) {self.goalType = .gt},
                                .default(Text("≠")) {self.goalType = .ne},
                                .cancel()
                            ]
                        )
                    }
                    Stepper(value: self.$goal, in: 0...99) {
                        HStack {
                            Text("食数")
                            Spacer()
                            Text("\(goal)")
                        }
                    }
                    HStack {
                        Spacer()
                        ZStack {
                            Rectangle()
                                .fill(Color.gray)
                                .frame(width: 200, height: 200)
                            if image != nil {
                                GoalIcon(image ?? "")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width:200, height: 200)
                            } else {
                                Text("イメージを選択").foregroundColor(Color.white)
                            }
                            NavigationLink(
                                destination: PresetImagePicker(
                                    showingImgPicker: $showingImgPicker,
                                    image: $image
                                ),
                                isActive: $showingImgPicker
                            ) {
                                EmptyView()
                            }
                        }
                        Spacer()
                    }
                    Section {
                        Button(
                            action: createNewGoal,
                            label: {
                                HStack {
                                    Spacer()
                                    Text("新規ゴールを作成").foregroundColor(Color.blue)
                                    Spacer()
                                }
                            }
                        ).alert(
                            isPresented: $showingAlert,
                            content: {
                                Alert(
                                    title: Text("不正確タイトル"),
                                    message: Text("新規ゴールのタイトルがなくてはダメです。")
                                )
                            }
                        )
                        Button(
                            action: returnHomeTab,
                            label: {
                                HStack {
                                    Spacer()
                                    Text("キャンセル").foregroundColor(Color.red)
                                    Spacer()
                                }
                            }
                        )
                    }
                }
            }.navigationBarTitle("新規ゴール")
        }
        .accentColor(Color.white)
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func createNewGoal() {
        if (title == "") {
            self.showingAlert = true
        } else {
            let newGoal = Goal(context: managedObjectContext)
            newGoal.title = title
            newGoal.goal = goal
            newGoal.servings = 0
            newGoal.goalPeriod = goalPeriod.rawValue
            newGoal.goalType = goalType.rawValue
            newGoal.image = image == "" ? nil : image
            dateData.addToGoals(newGoal)
            
            returnHomeTab()
        }
    }
    
    func returnHomeTab() {
        title = ""
        goalPeriod = .day
        goalType = .eq
        goal = 0
        image = nil
        
        parent.selectedTab = "home"
    }
}

struct AddGoalForm_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let dateData = DateData(context: context)
        let mainView = MainView()
        AddGoalForm(parent: mainView, dateData: dateData)
    }
}
