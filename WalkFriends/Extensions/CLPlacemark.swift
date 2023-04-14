//
//  CLPlacemark.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/04/12.
//

import Foundation
import CoreLocation

extension CLPlacemark {

    var address: String? {
        if let name = administrativeArea {
            var result = name

            if let locality = locality {
                result += " \(locality)"
            }

            if let subLocality = subLocality {
                result += " \(subLocality)"
            }
            
            if let thoroughfare = thoroughfare {
                result += " \(thoroughfare)"
            }

            return result
        }

        return nil
    }

}
