//
//  Home.swift
//  Created on 05/06/20.
//  Created for AnitaB.org Mentorship-iOS
//

import SwiftUI

struct Home: View {
    var homeService: HomeService = HomeAPI()
    var profileService: ProfileService = ProfileAPI()
    @ObservedObject var homeViewModel = HomeViewModel()
    @State private var isLoading = false
    private var relationsData: UIHelper.HomeScreen.RelationsListData {
        return homeViewModel.relationsListData
    }
    private var profile: ProfileModel.ProfileData {
        return homeViewModel.profileData
    }

    var body: some View {
        NavigationView {
            List {
                //Top space
                Section {
                    EmptyView()
                }

                //Relation dashboard list
                Section {
                    ForEach(0 ..< relationsData.relationTitle.count) { index in
                        NavigationLink(destination: RelationDetailList(
                            index: index,
                            navigationTitle: self.relationsData.relationTitle[index],
                            homeViewModel: self.homeViewModel
                        )) {
                            RelationListCell(
                                systemImageName: self.relationsData.relationImageName[index],
                                imageColor: self.relationsData.relationImageColor[index],
                                title: self.relationsData.relationTitle[index],
                                count: self.relationsData.relationCount[index]
                            )
                        }
                        .disabled(self.isLoading ? true : false)
                    }
                }

                //Tasks to do list section
                TasksToDoSection(tasksToDo: homeViewModel.homeResponseData.tasksToDo)

                //Tasks done list section
                TasksDoneSection(tasksDone: homeViewModel.homeResponseData.tasksDone ?? [])

            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .navigationBarTitle("Welcome \(profile.name?.capitalized ?? "")!")
            .navigationBarItems(trailing:
                NavigationLink(destination: ProfileSummary()) {
                        Image(systemName: ImageNameConstants.SFSymbolConstants.profileIcon)
                            .padding([.leading, .vertical])
                            .font(.system(size: DesignConstants.Fonts.Size.navBarIcon))
            })
            .onAppear {
                // make network request and set isLoading to true
                self.isLoading = true
                
                // fetch dashboard and map to home view model
                self.homeService.fetchDashboard { home in
                    home.mapTo(viewModel: self.homeViewModel)
                    self.isLoading = false
                }
                
                // fetch profile and map to home view model.
                self.profileService.getProfile { profile in
                    profile.mapTo(viewModel: self.homeViewModel)
                    ProfileViewModel().saveProfile(profile: profile)
                }
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
