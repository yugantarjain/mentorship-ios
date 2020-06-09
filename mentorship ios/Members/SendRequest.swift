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
    @State private var notesText = ""
    @ObservedObject private var keyboardResponder = KeyboardResponder()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    AnyView(EmptyView())
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
                    DatePicker(selection: /*@START_MENU_TOKEN@*/.constant(Date())/*@END_MENU_TOKEN@*/, label: { /*@START_MENU_TOKEN@*/Text("Date")/*@END_MENU_TOKEN@*/
                    })
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                }
                
                Section(header: Text("Notes").font(.headline)) {
                    TextField("Optional", text: $notesText)
                }
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    Text("Send")
                }
            }
            .navigationBarTitle("Relation request")
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

final class KeyboardResponder: ObservableObject {
    
    @Published var keyboardHeight: CGFloat = 0
    
    private(set) var subscriptions = Set<AnyCancellable>()
    
    init() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)
            .compactMap { notification in
                (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height
        }
        .receive(on: DispatchQueue.main)
        .assign(to: \.keyboardHeight, on: self)
        .store(in: &subscriptions)
    }
}

//func abcd() {
//    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { key in
//        let value = key.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
//        self.value = value.height
//    }
//
//    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { key in
//        self.value = 0
//    }
//}
