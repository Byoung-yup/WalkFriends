//
//  AppAppearence.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/07/10.
//

import Foundation
import UIKit

final class AppAppearance {
    
    static func setupAppearance() {
        
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
//            let navigationBar = UINavigationBar()
            appearance.configureWithOpaqueBackground()
//            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, .font: UIFont(name: "LettersforLearners", size: 20)!]
            appearance.backgroundColor = .clear
//            navigationBar.standardAppearance = appearance
            UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
            UINavigationBar.appearance().shadowImage = UIImage()
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            UINavigationBar.appearance().standardAppearance = appearance
        }

        //네비게이션 바 색상 UIColor와 일치시키기
        UINavigationBar.appearance().isTranslucent = true
    }
}

extension UINavigationController {
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
}
