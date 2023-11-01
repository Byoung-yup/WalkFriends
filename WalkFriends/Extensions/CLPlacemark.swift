//
//  CLPlacemark.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/04/12.
//

import Foundation
//import CoreLocation
import MapKit

extension MKPlacemark {

    var address: String {
        var result = ""
        if let country = country {
            result += "\(country)"
            
            if let administrativeArea = administrativeArea {
                result += " \(administrativeArea)"
            }
            
            if let locality = locality {
                result += " \(locality)"
            }

            if let subLocality = subLocality {
                result += " \(subLocality)"
            }
        }
//        if let administrativeArea = administrativeArea {
//            result += "\(administrativeArea)"
//
////            if let name = name {
////                result += " 1\(name)"
////            }
////
////            if let subAdministrativeArea = subAdministrativeArea {
////                result += " 2\(subAdministrativeArea)"
////            }
//
//            if let locality = locality {
//                result += " \(locality)"
//            }
//
//            if let subLocality = subLocality {
//                result += " \(subLocality)"
//            }
            
            
//
//            if let thoroughfare = thoroughfare {
//                result += " 6\(thoroughfare)"
//            }
//
//            if let subThoroughfare = subThoroughfare {
//                result += " 7\(subThoroughfare)"
//            }
//
//            if let inlandWater = inlandWater {
//                result += " 8\(inlandWater)"
//            }
//
//            if let areasOfInterest = areasOfInterest {
//                result += " 9\(areasOfInterest)"
//            }
//
//            if let postalCode = postalCode {
//                result += " 10\(postalCode)"
//            }
//
//            if let isoCountryCode = isoCountryCode {
//                result += " 11\(isoCountryCode)"
//            }
//
//            if let ocean = ocean {
//                result += " 12\(ocean)"
//            }
        
        return result
    }

}
