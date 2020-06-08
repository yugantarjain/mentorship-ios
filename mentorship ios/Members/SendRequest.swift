//
//  SendRequest.swift
//  mentorship ios
//
//  Created by Yugantar Jain on 09/06/20.
//  Copyright © 2020 Yugantar Jain. All rights reserved.
//

import SwiftUI

struct SendRequest: View {
    @State private var pickerSelection = 1
    @State private var notesText = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("I will be a").font(.headline)) {
                    Picker(selection: $pickerSelection, label: Text("")) {
                        Text("Mentor").tag(1)
                        Text("Mentee").tag(2)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .labelsHidden()
                }
                
                Section(header: Text("End Date").font(.headline)) {
                    DatePicker(selection: /*@START_MENU_TOKEN@*/.constant(Date())/*@END_MENU_TOKEN@*/, label: { /*@START_MENU_TOKEN@*/Text("Date")/*@END_MENU_TOKEN@*/
                    })
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                }
                
                Section(header: Text("Notes").font(.headline)) {
                    TextView(text: $notesText, backgroundColor: DesignConstants.Colors.secondaryUIBackground, fontStyle: .preferredFont(forTextStyle: .body))
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: DesignConstants.Height.textViewHeight, maxHeight: .infinity)
                }
            }
            .padding(.vertical, DesignConstants.Screen.Padding.topPadding * 2)
            .navigationBarTitle("Send relation request", displayMode: .inline)
            .navigationBarItems(leading: Button.init("Cancel", action: {
                
            }))
        }
    }
}

struct SendRequest_Previews: PreviewProvider {
    static var previews: some View {
        SendRequest()
    }
}
