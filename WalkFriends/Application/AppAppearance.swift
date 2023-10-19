//
//  AppAppearence.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/07/10.
//

import Foundation
import UIKit

final class AppAppearance {
    
    static var naviBarHeight: CGFloat!
    static var safeArea: UIEdgeInsets!
    
    static func setupAppearance() {
//        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
//        UINavigationBar.appearance().shadowImage = UIImage()
//        UINavigationBar.appearance().isTranslucent = true
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
//        if #available(iOS 15, *) {
//            let appearance = UINavigationBarAppearance()
//            appearance.configureWithOpaqueBackground()
//            UINavigationBar.appearance().standardAppearance = appearance
//            UINavigationBar.appearance().scrollEdgeAppearance = appearance
//        } else {
//            UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
//            UINavigationBar.appearance().shadowImage = UIImage()
//            //네비게이션 바 색상 UIColor와 일치시키기
//            UINavigationBar.appearance().isTranslucent = true
//        }
    }
}

extension UINavigationController {
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
}
