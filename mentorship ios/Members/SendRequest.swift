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
    @ObservedObject var membersModel = MembersModel()
    var memberID: Int
    var memberName: String
    @State private var pickerSelection = 1
    @State private var endDate = Date()
    @State private var notes = ""
    @State private var offsetValue: CGFloat = 0
    @State private var notesCellFrame = CGRect()
    @Environment(\.presentationMode) var presentationMode
    
    func sendRequest() {
        let myID = ProfileModel().getProfile().id
        let timestamp = Int(self.endDate.timeIntervalSince1970)
        var menteeID = myID
        var mentorID = memberID
        if pickerSelection == 2 {
            menteeID = memberID
            mentorID = myID
        }
        membersModel.sendRequest(menteeID: menteeID, mentorID: mentorID, endDate: timestamp, notes: notes)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                //Background Color
                DesignConstants.Colors.formBackgroundColor
                
                //Form
                SendRequestForm(
                    name: memberName,
                    pickerSelection: $pickerSelection,
                    endDate: $endDate,
                    notesText: $notes,
                    notesFrame: $notesCellFrame
                )
                
                //Send button and message text
                VStack(spacing: DesignConstants.Form.Spacing.bigSpacing) {
                    //Send button
                    Button(action: sendRequest) {
                        Text("Send")
                            .frame(width: 200)
                            .padding(.vertical, DesignConstants.Padding.textFieldFrameExpansion)
                            .overlay(
                                RoundedRectangle(cornerRadius: DesignConstants.CornerRadius.preferredCornerRadius, style: .circular)
                                    .strokeBorder(lineWidth: 2)
                            )
                    }
                    .disabled(notes.isEmpty ? true : false)
                    
                    //Activity Indicator or message
                    if self.membersModel.inActivity {
                        ActivityIndicator(isAnimating: $membersModel.inActivity, style: .medium)
                    } else {
                        Text(membersModel.sendRequestResponseData.message ?? "")
                            .font(DesignConstants.Fonts.userError)
                            .foregroundColor(DesignConstants.Colors.userError)
                    }
                }
                .position(x: notesCellFrame.midX, y: notesCellFrame.minY)
                .offset(y: DesignConstants.Form.Spacing.smallSpacing)
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
        SendRequest(memberID: 0, memberName: "ds")
    }
}
