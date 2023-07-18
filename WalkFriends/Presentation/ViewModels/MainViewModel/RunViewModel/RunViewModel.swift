//
//  RunViewModel.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/03/23.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa
import MapKit
import RxCoreLocation

struct RunViewModelActions {
    let toBack: () -> Void
}

final class RunViewModel: ViewModel {
    
    // MARK: - Input
    
    struct Input {
//        let run: Driver<Void>
//        let stop: Driver<Void>
//        let startCoordinate: Observable<CLLocationCoordinate2D>
//        let destinationCoordinate: Observable<CLLocationCoordinate2D>
//        let saved: Observable<Bool>
    }
    
    // MARK: - Output
    
    struct Output {
        let didChangeAuthorization: ControlEvent<CLAuthorizationEvent>
        let didUpdateLocations: Observable<CLLocationsEvent>
        let location: Observable<CLLocationCoordinate2D?>
//        let currentLocation:
//        let runTrigger: Driver<Void>
//        let stopTrigger: Driver<Void>
//        let dismissTrigger: Observable<Void?>
    }
    
    // MARK: - Properties
    
    let actions: RunViewModelActions
    var coordinators: [CLLocationCoordinate2D]?
//    var actionDelegate: RunViewModelActionDelegate?
    var size: CGSize = CGSize(width: 0, height: 0)
    
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()
    
    // MARK: - Init
    init(actions: RunViewModelActions) {
        self.actions = actions
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        locationManager.requestWhenInUseAuthorization()
        
        let autorizationStatus = locationManager
            .rx
            .didChangeAuthorization
        
        let didUpdateLocations = locationManager
            .rx
            .didUpdateLocations
            .share(replay: 1)
        
        let location = didUpdateLocations
            .map { $1.first?.coordinate }
        
//        let currentLocation = didUpdateLocations
//            .map { $0 }
        
//        let center = Observable.combineLatest(input.startCoordinate, input.destinationCoordinate)
//            .map { [weak self] in
//                self?.centerPoint(start: $0, des: $1)
//            }
//
//        let dismiss = Observable.combineLatest(input.saved, center) { [weak self] in
//            self?.takeSnapshot(with: $0, coordinate: $1!)
//        }
        
        
        
        return Output(didChangeAuthorization: autorizationStatus, didUpdateLocations: didUpdateLocations, location: location)
    }
    
    // MARK: - Center Coordinate2D
    
    func centerPoint(start: CLLocationCoordinate2D, des: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        
        let centerX = start.latitude + (des.latitude - start.latitude) / 2
        let centerY = start.longitude + (des.longitude - start.longitude) / 2
        
//        print("centerX: \(centerX), centerY: \(centerY)")
        
        return CLLocationCoordinate2D(latitude: centerX, longitude: centerY)
    }
    
    // MARK: - MKMapSnapShotter
    
    func takeSnapshot(with saved: Bool, coordinate: CLLocationCoordinate2D) {
        
        guard saved == true else {
//            actionDelegate?.dismiss(with: saved, snapshot: nil, address: "")
            return
        }
        
        // MKMapSnapshot
        let mapSnapshotOptions = MKMapSnapshotter.Options()
        
        // Set the region of the map that is rendered. (by polyline)
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapSnapshotOptions.region = region
        
        // Set the scale of the image. We'll just use the scale of the current device, which is 2x scale on Retina screens.
        mapSnapshotOptions.scale = UIScreen.main.scale
        
        // Set the size of the image output.
        mapSnapshotOptions.size = size
        
        // Show buildings and Points of Interest on the snapshot
        mapSnapshotOptions.showsBuildings = true
        
        let snapShotter = MKMapSnapshotter(options: mapSnapshotOptions)
        
        snapShotter.start() { [weak self] snapshot, error in
            guard let snapshot = snapshot else {
                return
            }
            
            // Don't just pass snapshot.image, pass snapshot itself!
            let image = self?.drawLineOnImage(snapshot: snapshot)
            self?.reverseGeocoding(saved: saved, image: image!, coordinate: coordinate)
        }
        
    }
    
    func drawLineOnImage(snapshot: MKMapSnapshotter.Snapshot) -> UIImage {
        let image = snapshot.image
        
        // for Retina screen
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        
        // draw original image into the context
        image.draw(at: CGPoint.zero)
        
        // get the context for CoreGraphics
        let context = UIGraphicsGetCurrentContext()
        
        // set stroking width and color of the context
        context!.setLineWidth(2.0)
        context!.setStrokeColor(UIColor.orange.cgColor)
        
        // Here is the trick :
        // We use addLine() and move() to draw the line, this should be easy to understand.
        // The diificult part is that they both take CGPoint as parameters, and it would be way too complex for us to calculate by ourselves
        // Thus we use snapshot.point() to save the pain.
        
        if let coordinators = coordinators {
            context!.move(to: snapshot.point(for: coordinators[0]))
            for i in 0...coordinators.count-1 {
                context!.addLine(to: snapshot.point(for: coordinators[i]))
                context!.move(to: snapshot.point(for: coordinators[i]))
            }
        }
        
        // apply the stroke to the context
        context!.strokePath()
        
        // get the image from the graphics context
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // end the graphics context
        UIGraphicsEndImageContext()
        
        return resultImage!
    }
    
    // MARK: - Get Placemark city address
    
    private func reverseGeocoding(saved: Bool, image: UIImage, coordinate: CLLocationCoordinate2D) {
        
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        
        geocoder.reverseGeocodeLocation(location, preferredLocale: locale) { [weak self] placemark, error in
            
            guard let placemarks = placemark, let placemarkInfo = placemarks.last else { return }
            
//            self?.actionDelegate?.dismiss(with: saved, snapshot: image, address: placemarkInfo.address!)
            return
        }
    }
}

