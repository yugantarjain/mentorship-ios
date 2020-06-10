//
//  SendRequestForm.swift
//  mentorship ios
//
//  Created by Yugantar Jain on 10/06/20.
//  Copyright © 2020 Yugantar Jain. All rights reserved.
//

import SwiftUI

struct SendRequestForm: View {
    var name: String
    @Binding var pickerSelection: Int
    @Binding var endDate: Date
    @Binding var notesText: String
    
    var body: some View {
        Form {
            //heading
            Section(header:
                Text("To \(name)")
                    .font(.title)
                    .fontWeight(.bold)
            ) {
                EmptyView()
            }
            
            //settings
            Section {
                VStack(alignment: .center) {
                    Text("My Role")
                    
                    Picker(selection: $pickerSelection, label: Text("My Role")) {
                        Text("Mentee").tag(1)
                        Text("Mentor").tag(2)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .labelsHidden()
                }
                
                DatePicker(selection: $endDate, displayedComponents: .date) {
                    Text("End Date")
                }
                
                TextField("Notes", text: $notesText)
            }
            .padding(.vertical, DesignConstants.Padding.listCellFrameExpansion)
        }
    }
}

struct SendRequestForm_Previews: PreviewProvider {
    static var previews: some View {
        SendRequestForm(name: "Yugantar", pickerSelection: .constant(1), endDate: .constant(Date()), notesText: .constant("Need mentorship for iOS"))
    }
}
