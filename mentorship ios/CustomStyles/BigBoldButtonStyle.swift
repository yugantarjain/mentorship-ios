//
//  BigBoldButton.swift
//  mentorship ios
//
//  Created by Yugantar Jain on 03/06/20.
//  Copyright © 2020 Yugantar Jain. All rights reserved.
//

import SwiftUI

struct BigBoldButtonStyle: ButtonStyle {
    var disabled: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 200)
            .padding(.vertical, DesignConstants.Padding.frameExpansionPadding)
            .background(DesignConstants.Colors.defaultIndigoColor)
            .foregroundColor(Color(.systemBackground))
            .cornerRadius(DesignConstants.CornerRadius.preferredCornerRadius)
            .opacity(configuration.isPressed ? DesignConstants.Opacity.tapHighlightingOpacity : 1.0)
            .opacity(disabled ? DesignConstants.Opacity.disabledViewOpacity : 1.0)
    }
}
