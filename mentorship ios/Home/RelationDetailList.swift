//
//  RelationDetailList.swift
//  Created on 16/06/20
//  Created for AnitaB.org Mentorship-iOS 
//

import SwiftUI

struct RelationDetailList: View {
    var index: Int
    var navigationTitle: String
    var homeResponseData: HomeModel.HomeResponseData
    @State private var pickerSelection = 1
    
    var sentData: [HomeModel.HomeResponseData.RequestStructure]? {
        if pickerSelection == 1 {
            let data1 = homeResponseData.asMentee?.sent
            switch index {
            case 0: return data1?.pending
            case 1: return data1?.accepted
            case 2: return data1?.rejected
            case 3: return data1?.cancelled
            case 4: return data1?.completed
            default: return []
            }
        } else {
            let data1 = homeResponseData.asMentor?.sent
            switch index {
            case 0: return data1?.pending
            case 1: return data1?.accepted
            case 2: return data1?.rejected
            case 3: return data1?.cancelled
            case 4: return data1?.completed
            default: return []
            }
        }
    }
    
    var receivedData: [HomeModel.HomeResponseData.RequestStructure]? {
        if pickerSelection == 1 {
            let data1 = homeResponseData.asMentee?.received
            switch index {
            case 0: return data1?.pending
            case 1: return data1?.accepted
            case 2: return data1?.rejected
            case 3: return data1?.cancelled
            case 4: return data1?.completed
            default: return []
            }
        } else {
            let data1 = homeResponseData.asMentor?.received
            switch index {
            case 0: return data1?.pending
            case 1: return data1?.accepted
            case 2: return data1?.rejected
            case 3: return data1?.cancelled
            case 4: return data1?.completed
            default: return []
            }
        }
    }
    
    var body: some View {
        VStack {
            Picker(selection: $pickerSelection, label: Text("")) {
                Text("As Mentee").tag(1)
                Text("As Mentor").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            .labelsHidden()
            .padding()
            
            List {
                //send data list
                Section(header: Text("Sent").font(.headline)) {
                    ForEach(sentData ?? []) { data in
                        DetailListCell(requestData: data, index: self.index)
                    }
                }
                
                //received data list
                Section(header: Text("Received").font(.headline)) {
                    ForEach(receivedData ?? []) { data in
                        DetailListCell(requestData: data, index: self.index)
                    }
                }
            }
        }
        .navigationBarTitle(navigationTitle)
    }
}

struct RelationDetailList_Previews: PreviewProvider {
    static var previews: some View {
        RelationDetailList(index: 0, navigationTitle: "", homeResponseData: HomeModel().homeResponseData)
    }
}
