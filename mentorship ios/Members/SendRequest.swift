//
//  SendRequest.swift
//  mentorship ios
//
//  Created by Yugantar Jain on 09/06/20.
//  Copyright © 2020 Yugantar Jain. All rights reserved.
//

import SwiftUI
import Combine

struct SendRequest: View {
    var name: String
    @State private var pickerSelection = 1
    @State private var endDate = Date()
    @State private var notesText = ""
    @State private var offsetValue: CGFloat = 0
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                //Background Color
                DesignConstants.Colors.formBackgroundColor
                
                //Actual view
                VStack {
                    //Form
                    SendRequestForm(name: name, pickerSelection: $pickerSelection, endDate: $endDate, notesText: $notesText)
                    
                    //Send Button
                    Button.init(action: {}) {
                        Text("Send")
                    }
                    .buttonStyle(BigBoldButtonStyle())
                    
                    Spacer()
                }
            }
            .navigationBarTitle("Relation Request")
            .navigationBarItems(leading: Button.init("Cancel", action: {
                self.presentationMode.wrappedValue.dismiss()
            }))
        }
    }
}

struct SendRequest_Previews: PreviewProvider {
    static var previews: some View {
        SendRequest(name: "Yugantar Jain")
    }
}
