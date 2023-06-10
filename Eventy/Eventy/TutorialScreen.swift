//
//  TutorialView.swift
//  Eventy
//
//  Created by Vraj Shah on 08/06/23.
//

import SwiftUI
import SwiftUIPager

struct TutorialScreen: View {
    
    @StateObject var pageIndex = Page.first()
    @State var shouldNavigateToWelcomeScreen: Bool = false
    let pageData = Array(0..<3)
    
    var body: some View {
        NavigationStack {
            Pager(page: pageIndex, data: pageData, id: \.self) { index in
                getTutorialPage(index: index) {
                    shouldNavigateToWelcomeScreen = true
                }
            }
            .pagingPriority(.simultaneous)
            .sensitivity(.high)
            .itemSpacing(25)
            .background(AppColor.tutorialBackgroundColor.color)
            .ignoresSafeArea()
            .navigationDestination(isPresented: $shouldNavigateToWelcomeScreen) {
                welcomeScreen()
            }
        }
    }
}

private func getTutorialPage(index: Int, onGetStartedClicked: @escaping () -> Void) -> some View {
    switch index {
    case 0:
        return AnyView(tutorialPage(title: AppString.welcomeToOnlineEventAppTitle(),
                            description: AppString.welcomeToOnlineEventAppDescription(),
                            onGetStartedClicked: onGetStartedClicked) { metrics in
            Image(AppImage.welcomeToOnlineEventAppInitialLogo)
                .resizable()
                .frame(width: metrics.size.width * 0.9, height: metrics.size.width * 0.9)
        })
    case 1:
        return AnyView(tutorialPage(title: AppString.findAndBookAEventTitle(),
                            description: AppString.findAndBookAEventDescription(),
                            onGetStartedClicked: onGetStartedClicked) { metrics in
            ZStack(alignment: .top) {
                Image(AppImage.findAndBookAEventLogoBackground)
                    .padding(.top, 35)
                Image(AppImage.findAndBookAEventLogoForeground)
            }
            .offset(y: 10)
            .frame(width: metrics.size.width * 0.9, height: metrics.size.width * 0.9)
        })
    case 2:
        return AnyView(tutorialPage(title: AppString.organizedAPremiumEventTitle(),
                            description: AppString.organizedAPremiumEventDescription(),
                            onGetStartedClicked: onGetStartedClicked) { metrics in
            ZStack(alignment: .top) {
                Image(AppImage.organizedAPremiumEventLogoBackground)
                    .padding(.top, 48)
                Image(AppImage.organizedAPremiumEventLogoForeground)
            }
            .offset(y: 10)
            .frame(width: metrics.size.width * 0.9, height: metrics.size.width * 0.9)
        })
    default:
        return AnyView(EmptyView())
    }
}

private func tutorialPage<Content: View>(title: String,
                                         description: String,
                                         onGetStartedClicked: @escaping () -> Void,
                                         @ViewBuilder imageView: @escaping (GeometryProxy) -> Content) -> some View {
    GeometryReader { metrics in
        ZStack(alignment: .bottom) {
            AppColor.tutorialBackgroundColor.color
            
            VStack(spacing: 0) {
                imageView(metrics)
                
                VStack {
                    Text(title)
                        .font(.custom(AppFont.robotoBold, size: 30))
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                        .frame(height: 9)
                    
                    Text(description)
                        .font(.custom(AppFont.robotoRegular, size: 18))
                        .foregroundColor(AppColor.tutorialDescriptionColor.color)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                        .frame(height: 39)
                    
                    BaseButton(text: AppString.getStarted()) {
                        onGetStartedClicked()
                    }
                    .padding([.leading, .trailing], 40)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 48)
                .padding(.bottom, 100)
                .background(.white)
                .clipShape(RoundedCorner(radius: 50, corners: [.topLeft, .topRight]))
                .shadow(color: AppColor.tutorialCardShadowColor.color, radius: 50, x: 0, y: 25)
            }
        }
    }
}

private func welcomeScreen() -> some View {
    GeometryReader { metrics in
        ZStack(alignment: .bottom) {
            AppColor.tutorialBackgroundColor.color
            
            VStack(spacing: 0) {
                ZStack(alignment: .top) {
                    Image(AppImage.welcomeToOnlineEventAppLogoBackground)
                        .resizable()
                        .scaledToFit()
                        .padding(.top, 48)
                        .padding(.trailing, 40)
                    Image(AppImage.welcomeToOnlineEventAppLogoForeground)
                }
                .offset(y: 10)
                .frame(width: metrics.size.width * 0.9, height: metrics.size.width * 0.9)
                
                VStack {
                    Text(AppString.welcomeToOnlineEventAppTitle)
                        .font(.custom(AppFont.robotoBold, size: 30))
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                        .frame(height: 31)
                    
                    VStack(spacing: 20) {
                        BaseButton(text: AppString.getStarted()) {
                            
                        }
                        
                        StrokeButton(text: AppString.registerByNo()) {
                            
                        }
                    }
                    .padding([.leading, .trailing], 40)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 69)
                .padding(.bottom, 79)
                .background(.white)
                .clipShape(RoundedCorner(radius: 50, corners: [.topLeft, .topRight]))
                .shadow(color: AppColor.tutorialCardShadowColor.color, radius: 50, x: 0, y: 25)
            }
        }
    }
    .ignoresSafeArea()
    .toolbar(.hidden, for: .navigationBar)
}

struct TutorialScreen_Previews: PreviewProvider {
    static var previews: some View {
        TutorialScreen()
    }
}
