//
//  UIViewController.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/05/19.
//

import Foundation
import UIKit
import Photos

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

// MARK: - ImageManager Method

extension UIViewController {
    
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
            
            let data = thumbnail.jpegData(compressionQuality: 0.7)
            
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
}
