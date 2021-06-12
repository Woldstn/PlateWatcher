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
                    TextField("title-label", text: $title)
                    HStack {
                        Text("period-label")
                        Spacer()
                        Text(LocalizedStringKey(self.goalPeriod.key()))
                        Text("⤵︎").foregroundColor(Color.gray)
                    }.onTapGesture {
                        self.showingPeriodPicker = true
                    }.actionSheet(isPresented: $showingPeriodPicker) {
                        ActionSheet(
                            title: Text("period-label"),
                            message: nil,
                            buttons: [
                                .default(Text("day-period")) {self.goalPeriod = .day},
                                .default(Text("week-period")) {self.goalPeriod = .week},
                                .default(Text("month-period")) {self.goalPeriod = .month},
                                .cancel()
                            ]
                        )
                    }
                    HStack {
                        Text("type-label")
                        Spacer()
                        Text("\(self.goalType.string())")
                        Text("⤵︎").foregroundColor(Color.gray)
                    }.onTapGesture {
                        self.showingTypePicker = true
                    }.actionSheet(isPresented: $showingTypePicker) {
                        ActionSheet(
                            title: Text("type-label"),
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
                            Text("serving-label")
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
                                Text("image-select").foregroundColor(Color.white)
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
                                    Text("create-goal-button").foregroundColor(Color.blue)
                                    Spacer()
                                }
                            }
                        ).alert(
                            isPresented: $showingAlert,
                            content: {
                                Alert(
                                    title: Text("title-alert-label"),
                                    message: Text("title-alert-msg")
                                )
                            }
                        )
                        Button(
                            action: returnHomeTab,
                            label: {
                                HStack {
                                    Spacer()
                                    Text("cancel-button").foregroundColor(Color.red)
                                    Spacer()
                                }
                            }
                        )
                    }
                }
            }.navigationTitle("new-goal-header")
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
        Group {
            AddGoalForm(parent: mainView, dateData: dateData)
            AddGoalForm(parent: mainView, dateData: dateData).environment(\.colorScheme, .dark)
        }
    }
}
