//
//  ProfileEditField.swift
//  Created on 18/06/20
//  Created for AnitaB.org Mentorship-iOS 
//

import SwiftUI

struct ProfileEditField: View {
    var title: String
    @Binding var value: String
    
    var body: some View {
        HStack {
            Text(title).bold()
                .frame(width: DesignConstants.Width.listCellTitle)
                .multilineTextAlignment(.center)
            Divider()
            TextField(title, text: $value)
        }
    }
}

struct ProfileEditField_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditField(title: "title", value: .constant("value"))
    }
}
