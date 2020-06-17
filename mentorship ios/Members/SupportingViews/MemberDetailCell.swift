//
//  MemberDetailCell.swift
//  Created on 09/06/20.
//  Created for AnitaB.org Mentorship-iOS
//

import SwiftUI

struct MemberDetailCell: View {
    let title: String
    let value: String?
    let hideEmptyFields: Bool

    var body: some View {
        guard !(value?.isEmpty ?? true) || !hideEmptyFields else {
            return AnyView(EmptyView())
        }
        return AnyView(
            HStack {
                Text(title).font(.subheadline)
                    .frame(width: DesignConstants.Width.listCellTitle)
                    .multilineTextAlignment(.center)
                Divider()
                Text(value ?? "-").font(.headline)
            }
        )
    }
}

struct MemberDetailCell_Previews: PreviewProvider {
    static var previews: some View {
        MemberDetailCell(title: "title", value: "value", hideEmptyFields: true)
    }
}
