//
//  CLPlacemark.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/04/12.
//

import Foundation
import CoreLocation

extension CLPlacemark {

    var address: String {
        var result = ""
        if let administrativeArea = administrativeArea {
            result += "\(administrativeArea)"
            
//            if let name = name {
//                result += " name\(name)"
//            }
            
//            if let subAdministrativeArea = subAdministrativeArea {
//                result += " subAdministrativeArea\(subAdministrativeArea)"
//            }

            if let locality = locality {
                result += " \(locality)"
            }

            if let subLocality = subLocality {
                result += " \(subLocality)"
            }
            
//            if let country = country {
//                result += " country\(country)"
//            }
            
            if let thoroughfare = thoroughfare {
                result += " \(thoroughfare)"
            }
            
//            if let subThoroughfare = subThoroughfare {
//                result += " subThoroughfare\(subThoroughfare)"
//            }
            
//            if let inlandWater = inlandWater {
//                result += " inlandWater\(inlandWater)"
//            }
//
//            if let areasOfInterest = areasOfInterest {
//                result += " areasOfInterest\(areasOfInterest)"
//            }
//
//            if let postalCode = postalCode {
//                result += " postalCode\(postalCode)"
//            }
//
//            if let isoCountryCode = isoCountryCode {
//                result += " isoCountryCode\(isoCountryCode)"
//            }
//
//            if let ocean = ocean {
//                result += " ocean\(ocean)"
//            }
        }
        return result
    }

}
