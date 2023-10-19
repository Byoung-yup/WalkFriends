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
    let showShareViewController: (MapInfo) -> Void
}

struct MapInfo {
    let address: String
    let imageData: Data
}

final class RunViewModel: ViewModel {
    
    // MARK: - Input
    
    struct Input {
        let toBack: Observable<Void>
        let stop: Observable<Void>
        //        let coordinators: BehaviorRelay<[CLLocationCoordinate2D]>
        //        let run: Driver<Void>
        //        let stop: Driver<Void>
        //        let startCoordinate: Observable<CLLocationCoordinate2D>
        //        let destinationCoordinate: Observable<CLLocationCoordinate2D>
        //        let saved: Observable<Bool>
    }
    
    // MARK: - Output
    
    struct Output {
        let toBack: Observable<Void>
        let didChangeAuthorization: ControlEvent<CLAuthorizationEvent>
        let didUpdateLocations: Observable<Void>
        let locations: BehaviorRelay<[CLLocationCoordinate2D]>
        let location: Observable<CLLocation?>
        let snapshot: Observable<Void>
        //        let placemark: Observable<String>
        //        let currentLocation:
        //        let runTrigger: Driver<Void>
        //        let stopTrigger: Driver<Void>
        //        let dismissTrigger: Observable<Void?>
    }
    
    // MARK: - Properties
     
    let actions: RunViewModelActions
    //    var coordinators: [CLLocationCoordinate2D]?
    
    //    var size: CGSize = CGSize(width: 0, height: 0)
    
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
        locationManager.startUpdatingLocation()
        
        let coordinators: BehaviorRelay<[CLLocationCoordinate2D]> = BehaviorRelay(value: [])
        
        let toBack = input.toBack
            .do(onNext: { [weak self] in
                self?.locationManager.stopUpdatingLocation()
            })
        
        let autorizationStatus = locationManager
            .rx
            .didChangeAuthorization
        
        
        let didUpdateLocations = locationManager
            .rx
            .didUpdateLocations
            .map { coordinators.accept(coordinators.value + [$1.last!.coordinate]) }
        
        
        let currentLocation = locationManager
            .rx
            .location
            .filter { $0 != nil }
        
//        let placemark_coordinators = locationManager
//            .rx
//            .placemark(preferredLocale: Locale(identifier: "Ko-kr"))
//            .map { $0.address }
        
        let stop = input.stop.withLatestFrom(coordinators) { [weak self] (_, coordinators) in
//            print("coordinators: \(coordinators)")
            guard let self = self else { return }
            
            guard let first_Coordinator = coordinators.first else { return }
            guard let last_Coordinator = coordinators.last else { return }
            
            self.locationManager.stopUpdatingLocation()
            
            let centerPoint = self.centerPoint(start: first_Coordinator, des: last_Coordinator)
            return self.takeSnapshot(center: centerPoint, coordinators: coordinators)
        }
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
        
        
        
        return Output(toBack: toBack, didChangeAuthorization: autorizationStatus, didUpdateLocations: didUpdateLocations, locations: coordinators, location: currentLocation, snapshot: stop)
    }
    
    // MARK: - Center Coordinate2D
    
    func centerPoint(start: CLLocationCoordinate2D, des: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        
        let centerX = start.latitude + (des.latitude - start.latitude) / 2
        let centerY = start.longitude + (des.longitude - start.longitude) / 2
        
        //        print("centerX: \(centerX), centerY: \(centerY)")
        
        return CLLocationCoordinate2D(latitude: centerX, longitude: centerY)
    }
    
    // MARK: - MKMapSnapShotter
    
    func takeSnapshot(center coordinate: CLLocationCoordinate2D, coordinators: [CLLocationCoordinate2D]) {
        
//        var image: UIImage?

        // MKMapSnapshot
        let mapSnapshotOptions = MKMapSnapshotter.Options()
        
        // Set the region of the map that is rendered. (by polyline)
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapSnapshotOptions.region = region
        
        // Set the scale of the image. We'll just use the scale of the current device, which is 2x scale on Retina screens.
        mapSnapshotOptions.scale = UIScreen.main.scale
        
        // Set the size of the image output.
        mapSnapshotOptions.size = UIScreen.main.bounds.size
        
        // Show buildings and Points of Interest on the snapshot
        mapSnapshotOptions.showsBuildings = true
        
        let snapShotter = MKMapSnapshotter(options: mapSnapshotOptions)
        print("Thread1: \(Thread.current)")
        snapShotter.start() { [weak self] (snapshot, error) in
            print("Thread2: \(Thread.current)")
            guard let self = self else { return }
            
            guard let snapshot = snapshot else { return }
            
            let image = self.drawLineOnImage(snapshot: snapshot, coordinators: coordinators)
//            print("image: \(image)")
            self.reverseGeocoding(imageData: image, coordinate: coordinators.first!)
            // Don't just pass snapshot.image, pass snapshot itself!
//            return self.drawLineOnImage(snapshot: snapshot, coordinators: coordinators)
//            self.reverseGeocoding(image: image!, coordinate: coordinators.first!)
        }
//        return snapshot
        
        //        return Observable.create { (observer) in
        //
        //            let task = Task { [weak self] in
        //
        //                do {
        //                    // MKMapSnapshot
        //                    let mapSnapshotOptions = MKMapSnapshotter.Options()
        //
        //                    // Set the region of the map that is rendered. (by polyline)
        //                    let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        //
        //                    mapSnapshotOptions.region = region
        //
        //                    // Set the scale of the image. We'll just use the scale of the current device, which is 2x scale on Retina screens.
        //                    mapSnapshotOptions.scale = await UIScreen.main.scale
        //
        //                    // Set the size of the image output.
        //                    mapSnapshotOptions.size = await UIScreen.main.bounds.size
        //
        //                    // Show buildings and Points of Interest on the snapshot
        //                    mapSnapshotOptions.showsBuildings = true
        //
        //                    let snapShotter = MKMapSnapshotter(options: mapSnapshotOptions)
        //
        //                    let snapshot = try await snapShotter.start()
        //
        //                    let image = await self?.drawLineOnImage(snapshot: snapshot, coordinator: coordinator)
        //
        //                    observer.onNext(.success(image!))
        //                    observer.onCompleted()
        //                } catch {
        //
        //                }
        //
        //            }
        //
        //            return Disposables.create()
        //        }
        
        
    }
    
    func drawLineOnImage(snapshot: MKMapSnapshotter.Snapshot, coordinators: [CLLocationCoordinate2D]) -> Data {
        let image = snapshot.image
        
        // for Retina screen
        UIGraphicsBeginImageContextWithOptions(UIScreen.main.bounds.size, true, 0)
        
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
        
        //        if let coordinators = coordinators {
        context!.move(to: snapshot.point(for: coordinators[0]))
        for i in 0...coordinators.count-1 {
            context!.addLine(to: snapshot.point(for: coordinators[i]))
            context!.move(to: snapshot.point(for: coordinators[i]))
        }
        //        }
        
        // apply the stroke to the context
        context!.strokePath()
        
        // get the image from the graphics context
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // end the graphics context
        UIGraphicsEndImageContext()
        
        let data = resultImage?.jpegData(compressionQuality: 0.7)
//        let newImage = UIImage(data: data!)
        
        return data!
    }
    
    // MARK: - Get Placemark city address
    
    private func reverseGeocoding(imageData: Data, coordinate: CLLocationCoordinate2D) {
        
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        
        geocoder.reverseGeocodeLocation(location, preferredLocale: locale) { [weak self] placemark, error in
            
            guard let self = self else { return }
            
            guard let placemarks = placemark, let placemarkInfo = placemarks.last else { return }
            
            self.actions.showShareViewController(MapInfo(address: placemarkInfo.address, imageData: imageData))
            return
        }
    }
}

