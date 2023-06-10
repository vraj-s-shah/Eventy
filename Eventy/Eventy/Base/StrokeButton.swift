//
//  StrokeButton.swift
//  Eventy
//
//  Created by Vraj Shah on 09/06/23.
//

import SwiftUI

struct StrokeButton: View {
    
    var text: String
    var onClick: () -> Void = { }
    
    var body: some View {
        VStack {
            Text(text)
                .foregroundColor(AppColor.appBaseColor.color)
                .font(.custom(AppFont.robotoBold, size: 18))
                .frame(maxWidth: .infinity)
                .padding([.top, .bottom], 15)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(AppColor.appBaseColor.color)
                )
                .onTapGesture {
                    onClick()
                }
        }
    }
}

struct StrokeButton_Previews: PreviewProvider {
    static var previews: some View {
        StrokeButton(text: "Stroke Button")
    }
}
