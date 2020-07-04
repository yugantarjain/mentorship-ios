//
//  AddTask.swift
//  Created on 01/07/20
//  Created for AnitaB.org Mentorship-iOS 
//

import SwiftUI

struct AddTask: View {
    @ObservedObject var relationViewModel: RelationViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: DesignConstants.Spacing.bigSpacing) {
                TextField("Task Description", text: $relationViewModel.newTask.description)
                    .textFieldStyle(RoundFilledTextFieldStyle())
                
                Button("Add") {
                    self.relationViewModel.addNewTask()
                }
                .buttonStyle(BigBoldButtonStyle())
                
                Spacer()
            }
            .modifier(AllPadding())
            .navigationBarTitle("Add Task")
            .navigationBarItems(trailing: Button("Cancel") {
                self.presentationMode.wrappedValue.dismiss()
            })
            .onAppear {
                self.relationViewModel.newTask.description = ""
            }
        }
    }
}
