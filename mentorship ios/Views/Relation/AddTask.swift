//
//  AddTask.swift
//  Created on 01/07/20
//  Created for AnitaB.org Mentorship-iOS 
//

import SwiftUI

struct AddTask: View {
    @Binding var text: String
    var relationViewModel: RelationViewModel
    
    var body: some View {
        VStack(spacing: DesignConstants.Spacing.bigSpacing) {
            TextField("Task Description", text: $text)
                .textFieldStyle(RoundFilledTextFieldStyle())
                .border(Color.primary, width: 1)
                .cornerRadius(DesignConstants.CornerRadius.preferredCornerRadius)
                .shadow(color: .secondary, radius: DesignConstants.Spacing.bigSpacing)
            
            Button("Add") {
                self.relationViewModel.addNewTask()
            }
            .buttonStyle(BigBoldButtonStyle())
            
            Spacer()
        }
    }
}
