//
//  CustomCollectionViewFlowLayout.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/09/14.
//

import Foundation
import UIKit

class CustomCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect)

        layoutAttributes?.forEach { attribute in
            if attribute.representedElementKind == UICollectionView.elementKindSectionHeader {
                guard let collectionView = collectionView else { return }
                let contentOffsetY = collectionView.contentOffset.y
//                print("contentOffsetY:\(contentOffsetY)")
                if contentOffsetY < 0 {
                    let width = collectionView.frame.width
                    let height = attribute.frame.height - contentOffsetY
                    attribute.frame = CGRect(x: 0, y: contentOffsetY, width: width, height: height)
                }
                else {
                    let width = collectionView.frame.width
                    let height = attribute.frame.height - contentOffsetY
                    attribute.frame = CGRect(x: 0, y: contentOffsetY, width: width, height: height)
                    
                    if contentOffsetY > AppAppearance.naviBarHeight {
                        let default_Height = attribute.frame.height - AppAppearance.naviBarHeight
                        let dynamic_Height = AppAppearance.naviBarHeight - contentOffsetY
                        let transparent =  default_Height / (default_Height + abs(dynamic_Height))
                        attribute.alpha = transparent
                    }
                }
                
//                let default_Height = attribute.frame.height - AppAppearance.safeArea.top
//
////                let dynamic_Offset = (default_Height + abs(contentOffsetY))
//
//                let transparent = (abs(contentOffsetY) / default_Height)
//
////                attribute.alpha = attribute.frame.height / abs(contentOffsetY)
//                attribute.alpha = transparent
            }
        }
        
        return layoutAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
