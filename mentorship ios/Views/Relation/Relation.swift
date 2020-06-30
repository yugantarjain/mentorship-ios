//
//  Relation.swift
//  Created on 30/06/20
//  Created for AnitaB.org Mentorship-iOS 
//

import SwiftUI

struct Relation: View {
    //sample data
    @ObservedObject var sampleData = HomeViewModel()
    @State var showAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                VStack {
                    HStack {
                        Text("Vatsal").font(.title).fontWeight(.heavy)
                        Spacer()
                        Text("Ends on: Aug 24, 2020").font(.callout)
                    }
                    .foregroundColor(DesignConstants.Colors.subtitleText)
                    
                    Divider()
                        .background(DesignConstants.Colors.defaultIndigoColor)
                }
                .listRowBackground(DesignConstants.Colors.formBackgroundColor)
                
                TasksToDoSection(tasksToDo: sampleData.homeResponseData.tasksToDo) {
                    self.showAlert.toggle()
                }
                
                TasksDoneSection(tasksDone: sampleData.homeResponseData.tasksDone)
            }
            .environment(\.horizontalSizeClass, .regular)
            .navigationBarTitle("Current Relation")
            .navigationBarItems(trailing: Button("Add Task") {
                //add action code
            })
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Mark as completed?"),
                    primaryButton: .cancel(),
                    secondaryButton: .default(Text("Confirm")))
            }
        }
    }
}

struct Relation_Previews: PreviewProvider {
    static var previews: some View {
        Relation()
    }
}
