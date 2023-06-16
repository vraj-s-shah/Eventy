//
//  SignUpScreen.swift
//  Eventy
//
//  Created by Vraj Shah on 13/06/23.
//

import SwiftUI

struct SignUpScreen: View {
    
    var isNavigatedFromSignIn: Bool = false
    
    @AppStorage(appString.isLoggedIn()) private var isLoggedIn: Bool = false
    @AppStorage(appString.rememberedEmail()) private var rememberedEmail: String = ""
    
    @Environment(\.dismiss) var dismiss: DismissAction
    
    @State private var fullName: String = ""
    @State private var phoneNumber: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isTermsChecked: Bool = false
    @State private var shouldNavigateToSignIn: Bool = false
    @State private var shouldShowErrorToast: Bool = false
    @State private var credentialsError: String?
    
    @FocusState private var focusedTextField: TextField?
    
    private var userData: UserData {
        let userData = UserData()
        userData.fullname = fullName
        userData.phoneNumber = phoneNumber
        userData.email = email
        userData.password = password
        return userData
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    ZStack {
                        Image(appImage.cameraIcon)
                    }
                    .frame(width: 100, height: 100)
                    .background(appColor.appGrayColor.color)
                    .clipShape(Circle())
                    
                    FloatingLabelTextField(titleKey: appString.fullName(), text: $fullName)
                        .padding(.top, 20)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.asciiCapable)
                        .focused($focusedTextField, equals: .fullName)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedTextField = .phoneNumber
                        }
                    
                    FloatingLabelTextField(titleKey: appString.phoneNumber(), text: $phoneNumber)
                        .padding(.top, 15)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.asciiCapableNumberPad)
                        .focused($focusedTextField, equals: .phoneNumber)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedTextField = .email
                        }
                    
                    FloatingLabelTextField(titleKey: appString.email(), text: $email)
                        .padding(.top, 15)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .focused($focusedTextField, equals: .email)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedTextField = .password
                        }
                    
                    FloatingLabelTextField(titleKey: appString.password(),
                                           isPasswordTextField: true,
                                           text: $password)
                    .padding(.top, 15)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.asciiCapable)
                    .focused($focusedTextField, equals: .password)
                    .submitLabel(.next)
                    .onSubmit {
                        focusedTextField = .confirmPassword
                    }
                    
                    FloatingLabelTextField(titleKey: appString.confirmPassword(),
                                           isPasswordTextField: true,
                                           text: $confirmPassword)
                    .padding(.top, 15)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.asciiCapable)
                    .focused($focusedTextField, equals: .confirmPassword)
                    .submitLabel(.done)
                    
                    CheckBox(isChecked: $isTermsChecked) {
                        Text(appString.termsOfServiceAndPrivacyPolicy)
                            .font(.custom(appFont.robotoRegular, size: 16))
                            .foregroundColor(appColor.appTextColor.color)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 28)
                    
                    DefaultButton(text: appString.signUpTitle()) {
                        checkAndSignUp()
                    }
                    .padding(.top, 24)
                    
                    HStack(spacing: 6) {
                        Text(appString.alreadyHaveAnAccount)
                            .font(.custom(appFont.robotoRegular, size: 16))
                            .foregroundColor(appColor.appTextColor.color)
                        
                        Text(appString.signInAttributed)
                            .font(.custom(appFont.robotoBold, size: 16))
                            .foregroundColor(appColor.appBaseColor.color)
                            .onTapGesture {
                                if isNavigatedFromSignIn {
                                    dismiss()
                                } else {
                                    shouldNavigateToSignIn = true
                                }
                            }
                    }
                    .padding(.top, 21)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 25)
                .padding(.bottom, 20)
                .padding(.horizontal, 20)
                .background(Color.white)
                .cornerRadius(15)
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .padding(.top, 37)
            .defaultNavigationBar(title: appString.signUpTitle()) {
                dismiss()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(appColor.appGrayColor.color)
        .scrollDismissesKeyboard(.interactively)
        .scrollBounceBehavior(.basedOnSize)
        .navigationDestination(isPresented: $shouldNavigateToSignIn) {
            SignInScreen(isNavigatedFromSignUp: true)
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

extension SignUpScreen {
    
    private enum TextField {
        case fullName, phoneNumber, email, password, confirmPassword
    }
    
    private enum CredentialsError: String {
        case emptyCredentials = "All fields required"
        case invalidEmail = "Invalid email address"
        case invalidPhone = "Invalid phone number"
        case passwordNotMatching = "Password does not match"
    }
    
    private func checkAndSignUp() {
        if let credentialsError = validateCredentials() {
            self.credentialsError = credentialsError.rawValue
            withAnimation { shouldShowErrorToast = true }
        } else if !isTermsChecked {
            credentialsError = appString.termsNotChecked()
            withAnimation { shouldShowErrorToast = true }
        } else {
            realmHelper.set(object: userData)
            isLoggedIn = true
            rememberedEmail = email
            credentialsError = "Signup success"
            withAnimation { shouldShowErrorToast = true }
        }
    }
    
    private func validateCredentials() -> CredentialsError? {
        switch true {
        case fullName.isEmpty, phoneNumber.isEmpty, email.isEmpty, password.isEmpty, confirmPassword.isEmpty:
            return .emptyCredentials
        case !email.isValidEmail:
            return .invalidEmail
        case phoneNumber.count != 10:
            return .invalidPhone
        case password != confirmPassword:
            return .passwordNotMatching
        default:
            return nil
        }
    }
    
}//End of extension

struct SignUpScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignUpScreen()
    }
}
