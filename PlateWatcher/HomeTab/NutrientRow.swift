//
//  NutrientRow.swift
//  PlateWatcher
//
//  Created by Zachary Pierog on 2020/08/11.
//  Copyright © 2020 Zachary Pierog. All rights reserved.
//

import SwiftUI

struct NutrientRow: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var labelColor = Color.blue
    @ObservedObject var goal: Goal
    
    let critPass = Color.blue
    let critFail = Color.orange
    
    var body: some View {
        let title: String = goal.title ?? ""
        let goalType: GoalType = GoalType(rawValue: goal.goalType) ?? .eq
        
        HStack {
            if let image = GoalIcon(self.goal.image ?? "").getImage() {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                Text(title)
                    .lineLimit(1)
                    .frame(maxWidth: 100)
            } else {
                Text(title)
                    .lineLimit(1)
                    .frame(maxWidth: 160)
            }
            Stepper(
                value: self.$goal.servings,
                in: 0...99
            ) {
                HStack {
                    Spacer()
                    Text("\(goal.servings)")
                        .fontWeight(.bold)
                        .foregroundColor(labelColor)
                        .onAppear(
                            perform: {
                                self.editTextColor(
                                    goalType: goalType,
                                    goalQty: goal.goal
                                )
                            }
                        )
                    Text("(\(goalType.string())\(goal.goal))").lineLimit(1)
                }
            }
        }
        .padding(.all, 5)
        .onReceive(goal.objectWillChange, perform: { _ in
            editTextColor(goalType: goalType, goalQty: goal.goal)
            saveContext(errorMsg: "食数は変更できませんでした。")
        })
    }
    
    func editTextColor(goalType: GoalType, goalQty: Int16) {
        switch goalType {
        case .ge:
            labelColor = goal.servings >= goalQty ? critPass : critFail
            break
        case .gt:
            labelColor = goal.servings > goalQty ? critPass : critFail
            break
        case .le:
            labelColor = goal.servings <= goalQty ? critPass : critFail
            break
        case .lt:
            labelColor = goal.servings < goalQty ? critPass : critFail
            break
        case .eq:
            labelColor = goal.servings == goalQty ? critPass : critFail
            break
        case .ne:
            labelColor = goal.servings != goalQty ? critPass : critFail
            break
        }
    }
    
    func saveContext(errorMsg: String) {
        do {
            try managedObjectContext.save()
        } catch {
            print("\(errorMsg)\n\(error.localizedDescription)")
        }
    }
}

struct NutrientRow_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let goal = Goal(context: context)
        goal.title = "Vegetables"
        goal.goalType = GoalType.ge.rawValue
        goal.goal = 3
        goal.image = "PSI_vegetables"
        goal.servings = 0
        
        return NutrientRow(goal: goal)
    }
}
