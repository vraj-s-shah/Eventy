//
//  BaseButton.swift
//  Eventy
//
//  Created by Vraj Shah on 08/06/23.
//

import SwiftUI

struct BaseButton: View {
    
    var text: String
    var onClick: () -> Void = { }
    
    var body: some View {
        VStack {
            Text(text)
                .foregroundColor(.white)
                .font(.custom(AppFont.robotoBold, size: 18))
                .frame(maxWidth: .infinity)
                .padding([.top, .bottom], 15)
                .background(AppColor.appBaseColor.color)
                .cornerRadius(25)
                .onTapGesture {
                    onClick()
                }
        }
    }
}

struct BaseButton_Previews: PreviewProvider {
    static var previews: some View {
        BaseButton(text: "Base Button")
    }
}
