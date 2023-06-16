//
//  LeadingImageTextField.swift
//  Eventy
//
//  Created by Vraj Shah on 11/06/23.
//

import SwiftUI

struct LeadingImageTextField: View {
    
    let leadingImage: Image
    let titleKey: String
    
    @Binding var text: String
    
    var body: some View {
        HStack(spacing: 15) {
            leadingImage
            
            TextField(titleKey, text: $text)
                .placeholder(shouldShow: text.isEmpty) {
                    Text(titleKey)
                        .font(.custom(appFont.robotoRegular, size: 16))
                        .foregroundColor(appColor.appTextColor.color)
                        .opacity(0.6)
                }
                .font(.custom(appFont.robotoRegular, size: 16))
                .foregroundColor(appColor.appTextColor.color)
                .autocorrectionDisabled()
        }
        .frame(height: 55)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 22)
        .background(appColor.appGrayColor.color)
        .cornerRadius(25)
    }
}

struct BaseTextField_Previews: PreviewProvider {
    static var previews: some View {
        LeadingImageTextField(leadingImage: Image(appImage.mailIcon),
                              titleKey: "Enter Text",
                              text: .constant(""))
        .previewLayout(.sizeThatFits)
    }
}
