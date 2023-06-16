//
//  SignInScreen.swift
//  Eventy
//
//  Created by Vraj Shah on 12/06/23.
//

import SwiftUI
import RealmSwift

struct SignInScreen: View {
    
    @Environment(\.dismiss) var dismiss: DismissAction
    
    @AppStorage(appString.isLoggedIn()) private var isLoggedIn: Bool = false
    @AppStorage(appString.rememberedEmail()) private var rememberedEmail: String = ""
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isRememberMeChecked: Bool = false
    @State private var shouldNavigateToSignUp: Bool = false
    @State private var shouldShowErrorToast: Bool = false
    @State private var credentialsError: String?
    
    @FocusState private var focusedTextField: TextField?
    
    var isNavigatedFromSignUp: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: 44)
            
            VStack(spacing: 20) {
                LeadingImageTextField(leadingImage: Image(appImage.mailIcon), titleKey: appString.emailPlaceholder(), text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .submitLabel(.next)
                    .focused($focusedTextField, equals: .email)
                    .onSubmit(of: .text) {
                        focusedTextField = .password
                    }
                
                LeadingImageTextField(leadingImage: Image(appImage.passwordIcon), titleKey: appString.passwordPlaceholder(), text: $password)
                    .keyboardType(.asciiCapable)
                    .textInputAutocapitalization(.never)
                    .submitLabel(.done)
                    .focused($focusedTextField, equals: .password)
                
                HStack(alignment: .center) {
                    CheckBox(isChecked: $isRememberMeChecked) {
                        Text(appString.rememberMe)
                            .padding(.leading, 8)
                            .font(.custom(appFont.robotoRegular, size: 14))
                            .foregroundColor(appColor.appTextColor.color)
                            .multilineTextAlignment(.center)
                    }
                    
                    Spacer()
                    
                    Text(appString.forgotPassword)
                        .font(.custom(appFont.robotoRegular, size: 14))
                        .foregroundColor(appColor.appBaseColor.color)
                        .underline()
                }
            }
            .padding(.top, 36)
            .padding(.bottom, 40)
            .padding(.horizontal, 20)
            .background(Color.white)
            .cornerRadius(20)
            .padding(.horizontal, 17)
            
            DefaultButton(text: appString.signInTitle()) {
                checkAndSignIn()
            }
            .padding(.horizontal, 20)
            .padding(.top, 30)
            
            HStack(spacing: 6) {
                Text(appString.dontHaveAnAccount)
                    .font(.custom(appFont.robotoRegular, size: 16))
                    .foregroundColor(appColor.appTextColor.color)
                
                Text(appString.signUpAttributed)
                    .font(.custom(appFont.robotoBold, size: 16))
                    .foregroundColor(appColor.appBaseColor.color)
                    .onTapGesture {
                        if isNavigatedFromSignUp {
                            dismiss()
                        } else {
                            shouldNavigateToSignUp = true
                        }
                    }
            }
            .padding(.top, 21)
            
            Spacer()
        }
        .defaultNavigationBar(title: appString.signInTitle()) {
            dismiss()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(appColor.appGrayColor.color)
        .navigationDestination(isPresented: $shouldNavigateToSignUp) {
            SignUpScreen(isNavigatedFromSignIn: true)
        }
        .onTapGesture { focusedTextField = nil }
        .overlay(content: {
            if shouldShowErrorToast {
                Toast(message: credentialsError ?? "",
                      backgroundColor: .red,
                      textColor: .white,
                      shouldShowToast: $shouldShowErrorToast)
            }
        })
    }
}

extension SignInScreen {
    
    private enum TextField {
        case email, password
    }
    
    private enum CredentialsError: String {
        case emptyCredentials = "All fields required"
        case invalidEmail = "Invalid email address"
    }
    
    private func checkAndSignIn() {
        if let credentialsError = validateCredentials() {
            self.credentialsError = credentialsError.rawValue
            withAnimation { shouldShowErrorToast = true }
            return
        }
        guard let userData: UserData = realmHelper.getFirst(UserData.emailPredicate, email) else {
            self.credentialsError = appString.userNotFound()
            withAnimation { shouldShowErrorToast = true }
            return
        }
        if userData.password != password {
            credentialsError = appString.wrongPassword()
            withAnimation { shouldShowErrorToast = true }
        } else {
            isLoggedIn = true
            rememberedEmail = isRememberMeChecked ? email : ""
            //TODO: Navigate to home screen
            credentialsError = "Login Success"
            withAnimation { shouldShowErrorToast = true }
        }
    }
    
    private func validateCredentials() -> CredentialsError? {
        switch true {
        case email.isEmpty, password.isEmpty:
            return .emptyCredentials
        case !email.isValidEmail:
            return .invalidEmail
        default:
            return nil
        }
    }
    
}//End of extension

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        SignInScreen()
    }
}
