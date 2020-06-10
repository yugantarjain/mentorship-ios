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
    @State private var notesCellFrame = CGRect()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                //Background Color
                DesignConstants.Colors.formBackgroundColor
                
                SendRequestForm(name: name, pickerSelection: $pickerSelection, endDate: $endDate, notesText: $notesText, notesFrame: $notesCellFrame)
                
                Button.init(action: {}) {
                    Text("Send")
                        .frame(width: 200)
                        .padding(.vertical, DesignConstants.Padding.textFieldFrameExpansion)
                        .overlay(
                            RoundedRectangle(cornerRadius: DesignConstants.CornerRadius.preferredCornerRadius, style: .circular)
                                .strokeBorder(lineWidth: 2)
                        )
                }
                .position(x: notesCellFrame.midX, y: notesCellFrame.minY)
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
