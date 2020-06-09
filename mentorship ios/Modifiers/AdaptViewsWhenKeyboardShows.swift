////
////  AdaptToKeyboard.swift
////  mentorship ios
////
////  Created by Yugantar Jain on 09/06/20.
////  Copyright © 2020 Yugantar Jain. All rights reserved.
////
//
//import SwiftUI
//import Combine
//
//struct AdaptsToSoftwareKeyboard: ViewModifier {
//    @State var currentHeight: CGFloat = 0
//    
//    func body(content: Content) -> some View {
//        content
//            .padding(.bottom, currentHeight)
//            .edgesIgnoringSafeArea(.bottom)
//            .onAppear(perform: subscribeToKeyboardEvents)
//    }
//    
//    private func subscribeToKeyboardEvents() {
//        NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillShowNotification)
//            .compactMap { notification in
//                notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect
//        }
//        .map { rect in
//            rect.height
//        }
//        .subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
//        
//        NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillHideNotification)
//            .compactMap { notification in
//                CGFloat.zero
//        }
//        .subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
//    }
//}
//
//struct KeyboardAware: ViewModifier {
//    @ObservedObject private var keyboard = KeyboardInfo.shared
//
//    func body(content: Content) -> some View {
//        content
////            .padding(.bottom, self.keyboard.height)
//            .offset(x: 0, y: self.keyboard.height)
//            .edgesIgnoringSafeArea(self.keyboard.height > 0 ? .bottom : [])
//            .animation(.easeOut)
//    }
//}
//
//final class KeyboardResponder: ObservableObject {
//    private var notificationCenter: NotificationCenter
//    @Published private(set) var currentHeight: CGFloat = 0
//
//    init(center: NotificationCenter = .default) {
//        notificationCenter = center
//        notificationCenter.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        notificationCenter.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//
//    deinit {
//        notificationCenter.removeObserver(self)
//    }
//
//    @objc func keyBoardWillShow(notification: Notification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            currentHeight = keyboardSize.height
//        }
//    }
//
//    @objc func keyBoardWillHide(notification: Notification) {
//        currentHeight = 0
//    }
//}
