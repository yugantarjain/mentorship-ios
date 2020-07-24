//
//  DetailListCellViewModel.swift
//  Created on 22/07/20
//  Created for AnitaB.org Mentorship-iOS 
//

import Foundation
import Combine

class DetailListCellViewModel: ObservableObject {
    var requestData: RequestStructure
    var endDate: Date
    
    init(data: RequestStructure) {
        requestData = data
        endDate = Date(timeIntervalSince1970: requestData.endDate ?? 0)
    }
}
