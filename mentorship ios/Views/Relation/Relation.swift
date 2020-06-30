//
//  Relation.swift
//  Created on 30/06/20
//  Created for AnitaB.org Mentorship-iOS 
//

import SwiftUI

struct Relation: View {
    //sample data
    @ObservedObject var sampleData = HomeViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("With Isabel Costa").font(.title).fontWeight(.heavy)) {
                    EmptyView()
                }
                
                TasksDoneSection(tasksDone: sampleData.homeResponseData.tasksDone)
                    .environment(\.horizontalSizeClass, .regular)
            }
            .navigationBarTitle("Current Relation")
            .navigationBarItems(trailing: Button("Add Task") {
                //add action code
            })
        }
    }
}

struct Relation_Previews: PreviewProvider {
    static var previews: some View {
        Relation()
    }
}
