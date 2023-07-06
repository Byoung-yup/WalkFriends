//
//  UIViewController.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/05/19.
//

import Foundation
import UIKit
import Photos
import BSImagePicker

extension UIViewController {
    
    // MARK: - Firebase Auth Alert
    
    // MARK: Success
    func showFBAuthAlert() {
        
        let alert = UIAlertController(title: "계정 등록 안내", message: "이메일 인증을 완료 해주시기 바랍니다.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "확인", style: .cancel))
        
        present(alert, animated: false)
    }
    
    // MARK: Error
    func showFBAuthErrorAlert(error: FirebaseAuthError) {
        
        var title: String = ""
        var message: String = ""
        
        switch error {
        case .AlreadyEmailError:
            title = "계정 등록 안내"
            message = "이미 등록된 계정입니다."
        case .InvalidEmailError:
            title = "계정 등록 안내"
            message = "유효하지 않는 이메일 주소입니다."
        case .WeakPasswordError:
            title = "계정 등록 안내"
            message = "비밀번호 등급이 낮습니다."
        case .WrongPasswordError:
            title = "로그인 안내"
            message = "올바르지 않는 비밀번호 입니다."
        case .UserNotFoundError:
            title = "로그인 안내"
            message = "유효하지 않는 이메일 주소입니다."
        case .AuthenticationError:
            title = "로그인 안내"
            message = "계정 인증을 완료 해주시기 바랍니다."
        case .NetworkError:
            title = "네트워크 오류 안내"
            message = "네트워크 통신이 원활하지 않습니다."
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "확인", style: .cancel))
        
        present(alert, animated: false)
    }
    
    // MARK: - Firebase Database Alert
    
    func showAlert(error: DatabaseError) {
        
        var title: String = ""
        var message: String = ""
        
        switch error {
        case .DatabaseFetchError:
            title = "네트워크 오류 안내"
            message = "네트워크 통신이 원활하지 않습니다."
        default:
            title = "오류 안내"
            message = "알 수 없는 오류가 발생하였습니다."
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "확인", style: .cancel))
        
        present(alert, animated: false)
    }
}

// MARK: - ImagePickerManager

extension UIViewController {
    
    func configureImagePicker(_ picker: inout ImagePickerController, selection num: Int) {
        
        picker.settings.selection.max = num
        picker.settings.theme.selectionStyle = .numbered
        picker.settings.fetch.assets.supportedMediaTypes = [.image]
        picker.settings.selection.unselectOnReachingMax = true
        picker.doneButtonTitle = "확인"
        picker.settings.theme.selectionStyle = .checked
        picker.settings.theme.selectionFillColor = .white
        picker.settings.theme.selectionStrokeColor = .orange
        picker.settings.theme.backgroundColor = .white
        picker.navigationBar.tintColor = .orange
        picker.cancelButton = UIBarButtonItem(title: "닫기", style: .done, target: nil, action: nil)

    }
    
    func convertAssetToImage(_ assetImages: [PHAsset], size: CGSize) -> [UIImage] {
        
        guard assetImages.count != 0 else {
            fatalError("Asset Images not found")
        }
        
        var images: [UIImage] = []
        
        for i in 0..<assetImages.count {
            
            var thumbnail = UIImage()
            
            let imageManager = PHImageManager.default()
            
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            
            imageManager.requestImage(for: assetImages[i], targetSize: size, contentMode: .aspectFit, options: options) { (result, info) in
                
                guard let result = result else {
                    return
                }
                thumbnail = result
            }
            
            let data = thumbnail.jpegData(compressionQuality: 1.0)
            
            guard let data = data else {
                fatalError("Data not found")
            }
            
            guard let image = UIImage(data: data) else {
                fatalError("Image not found")
            }
            
            images.append(image)
        }
        
        return images
    }
    
    // MARK: - Draw Background
    
    func drawBackground() {
        
        draw_Large_CircleBackground()
        draw_Little_CircleBackground()
        
    }
    
    func draw_Large_CircleBackground() {
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: CGFloat(UIScreen.main.bounds.width) / 2, y: -100))
        path.addArc(withCenter: CGPoint(x: UIScreen.main.bounds.width / 2, y: -100), radius: CGFloat(UIScreen.main.bounds.width) / 2 + 100, startAngle: .pi, endAngle: CGFloat(Double.pi * 2), clockwise: false)
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor(red: 0.98, green: 0.66, blue: 0.15, alpha: 0.25).cgColor
        
        view.layer.addSublayer(shapeLayer)
    }
    
    func draw_Little_CircleBackground() {
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: CGFloat(UIScreen.main.bounds.width) + 20, y: -20))
        path.addArc(withCenter: CGPoint(x: CGFloat(UIScreen.main.bounds.width) + 20, y: -20), radius: CGFloat(UIScreen.main.bounds.width) / 2, startAngle: .pi, endAngle: CGFloat(Double.pi / 2), clockwise: false)
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor(red: 0.98, green: 0.66, blue: 0.15, alpha: 0.25).cgColor
        
        view.layer.addSublayer(shapeLayer)
    }
}
