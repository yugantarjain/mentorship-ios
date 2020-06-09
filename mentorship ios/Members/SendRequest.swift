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
    @State private var pickerSelection = 1
    @State private var endDate = Date()
    @State private var notesText = ""
    @State private var offsetValue: CGFloat = 0
    @ObservedObject private var keyboardManager = KeyboardManager()

    var body: some View {
        NavigationView {
            Form {
                //top empty space
                Section {
                    EmptyView()
                }

                Section(header: Text("I'll Be The").font(.headline)) {
                    Picker(selection: $pickerSelection, label: Text("")) {
                        Text("Mentee").tag(1)
                        Text("Mentor").tag(2)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .labelsHidden()
                }

                Section(header: Text("End Date").font(.headline)) {
                    DatePicker(selection: $endDate, displayedComponents: .date) {
                        EmptyView()
                    }
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                    .padding(.leading, DesignConstants.Padding.listCellFrameExpansion)
                }

                Section(header: Text("Notes").font(.headline)) {
                    TextField("Optional", text: $notesText)
                        .padding(.vertical, DesignConstants.Padding.textFieldFrameExpansion)
                }

                Button(action: {}) {
                    Text("Send")
                }
            }
            .offset(y: self.keyboardManager.keyboardHeight > 0 ? -self.keyboardManager.keyboardHeight : 0)
            .background(DesignConstants.Colors.formBackgroundColor)
            .animation(.default)
            .onAppear {
                self.keyboardManager.observeKeyboardHeight()
            }
            //DEBUG COMMENT: actual nav title preference is large, inline chosen temporarily due to SwiftUI bug
            .navigationBarTitle("Relation request", displayMode: .inline)
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
