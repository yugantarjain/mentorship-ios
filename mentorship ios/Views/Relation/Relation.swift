//
//  Relation.swift
//  Created on 30/06/20
//  Created for AnitaB.org Mentorship-iOS 
//

import SwiftUI

struct Relation: View {
    var relationService = RelationAPI()
    @ObservedObject var relationViewModel = RelationViewModel()
    @State var showAlert = false
    
    var endDate: Date {
        return Date(timeIntervalSince1970: relationViewModel.currentRelation.endDate ?? 0)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Form {
                    //Top detail view
                    VStack(alignment: .leading, spacing: DesignConstants.Form.Spacing.minimalSpacing) {
                        //mentor/mentee name and end date
                        HStack {
                            Text(relationViewModel.personName).font(.title).fontWeight(.heavy)
                            Spacer()
                            Text(relationViewModel.personType).font(.title)//.fontWeight(.heavy)
                        }
                        .foregroundColor(DesignConstants.Colors.subtitleText)
                        
                        Text("Ends On: \(DesignConstants.DateFormat.mediumDate.string(from: endDate))")
                            .font(.callout)
                        
                        //divider, adds a line below name and date
                        Divider()
                            .background(DesignConstants.Colors.defaultIndigoColor)
                    }
                    .listRowBackground(DesignConstants.Colors.formBackgroundColor)
                    
                    //Tasks To Do List section
                    TasksToDoSection(tasksToDo: relationViewModel.toDoTasks) { task in
                        //set tapped task
                        RelationViewModel.taskTapped = task
                        //show alert for marking as complete confirmation
                        self.showAlert.toggle()
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text(LocalizableStringConstants.markComplete),
                            primaryButton: .cancel(),
                            secondaryButton: .default(Text(LocalizableStringConstants.confirm)) {
                                self.relationViewModel.markAsComplete()
                            })
                    }
                    
                    //Tasks Done List section
                    TasksDoneSection(tasksDone: relationViewModel.doneTasks)
                }
                
                //show activity spinner if in activity
                if relationViewModel.inActivity {
                    ActivityIndicator(isAnimating: $relationViewModel.inActivity, style: .medium)
                }
            }
            .environment(\.horizontalSizeClass, .regular)
            .navigationBarTitle("Current Relation")
            .navigationBarItems(trailing: Button(LocalizableStringConstants.addTask) {
                self.relationViewModel.addTask.toggle()
            })
            .sheet(isPresented: $relationViewModel.addTask) {
                AddTask(relationViewModel: self.relationViewModel)
            }
            .alert(isPresented: $relationViewModel.showErrorAlert) {
                Alert(
                    title: Text(self.relationViewModel.alertTitle),
                    message: Text(self.relationViewModel.alertMessage),
                    dismissButton: .default(Text(LocalizableStringConstants.okay)))
            }
            .onAppear {
                // for first time load set inactivity.
                if self.relationViewModel.firstTimeLoad {
                    self.relationViewModel.inActivity = true
                }
                
                // make api call to fetch current relation
                self.relationService.fetchCurrentRelation { response in
                    // map repsonse to view model
                    response.mapTo(viewModel: self.relationViewModel)
                    self.relationViewModel.inActivity = false
                    self.relationViewModel.firstTimeLoad = false
                    //chain api call. get current tasks using id from current relation
                    if let currentID = response.id {
                        self.relationService.fetchTasks(id: currentID) { tasks, success in
                            self.relationViewModel.handleFetchedTasks(tasks: tasks, success: success)
                        }
                    }
                }
            }
        }
    }
}

struct Relation_Previews: PreviewProvider {
    static var previews: some View {
        Relation()
    }
}
