//
//  Home.swift
//  mentorship ios
//
//  Created by Yugantar Jain on 05/06/20.
//  Copyright © 2020 Yugantar Jain. All rights reserved.
//

import SwiftUI

struct Home: View {
    
    @State private var someNumber1 = "1000"
    @State private var someNumber2 = "2000"
    //bunch more
    
    @State private var enteredNumber = "Some Text at the Top"
    @State var value: CGFloat = 0
    
    var body: some View {
        Form {
            VStack {
                Spacer()
                Text("\(enteredNumber)")
                Spacer()
                
                Group { //1
                    TextField("Placeholder", text: $someNumber1)
                        .keyboardType(.default)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .background(GeometryReader { gp -> Color in
//                            let rect = gp.frame(in: .named("OuterV")) // < in specific container
                             let rect = gp.frame(in: .global) // < in window
                            // let rect = gp.frame(in: .local) // < own bounds
                            print("Origin: \(rect.origin)")
                            return Color.clear
                        })
                        
                        //this does not work
                        .onTapGesture {
                    }
                    
                    TextField("Placeholder", text: $someNumber2)
                        .keyboardType(.default)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }//group 1
                
                //bunch more
                
                Button(action: {
                    self.enteredNumber = self.someNumber1
                    self.someNumber1 = ""
                    //                    UIApplication.shared.endEditing()
                }) {
                    Text("Submit")
                }
                .padding(.bottom, 50)
                
            }//outer v
                .coordinateSpace(name: "OuterV") // << declare coord space
                .padding(.horizontal, 16)
                .padding(.top, 44)
            
        }//Scrollview or Form
        //        .modifier(AdaptsToSoftwareKeyboard())
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
