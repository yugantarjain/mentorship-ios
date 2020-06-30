//
//  AddTask.swift
//  Created on 01/07/20
//  Created for AnitaB.org Mentorship-iOS 
//

import SwiftUI

struct AddTask: View {
    @Binding var text: String
    
    var body: some View {
        VStack(spacing: DesignConstants.Spacing.bigSpacing) {
            TextField("Task Description", text: $text)
                .textFieldStyle(RoundFilledTextFieldStyle())
            
            Button("Add") {
            }
            .buttonStyle(BigBoldButtonStyle())
            
            Spacer()
        }
    }
}
