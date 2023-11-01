//
//  Toast.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/10/23.
//

import UIKit

struct Toast {
    static func show(_ text: String, keyboardHeight: CGFloat, duration: Double = 2) {
    
        let keyWindow = UIApplication.shared.keyWindow
        guard let window = keyWindow else { return }

        let view = UIView(frame: CGRect(x: 0, y: 0, width: window.bounds.width - 20, height: 44))
        view.backgroundColor = UIColor.black
        view.layer.cornerRadius = 10
        
        let label = UILabel(frame: CGRect(x: 13, y: 0, width: view.bounds.width, height: view.bounds.height))
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = text
        view.addSubview(label)

        view.center = CGPoint(x: window.center.x, y: window.center.y + (window.bounds.height / 2) - keyboardHeight)
        view.alpha = 0
        window.addSubview(view)
        UIView.animate(withDuration: 0.2) {
            view.alpha = 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            UIView.animate(withDuration: 0.5, animations: {
                view.alpha = 0
            }, completion: { _ in
                view.isHidden = true
                view.removeFromSuperview()
            })
        }
    }
}
