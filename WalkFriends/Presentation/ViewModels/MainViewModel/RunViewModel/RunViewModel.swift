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

protocol RunViewModelActionDelegate {
    func dismiss(with saved: Bool, snapshot: UIImage?)
}

final class RunViewModel: ViewModel {
    
    // MARK: - Input
    
    struct Input {
        let run: Driver<Void>
        let stop: Driver<Void>
        let startCoordinate: Observable<CLLocationCoordinate2D>
        let destinationCoordinate: Observable<CLLocationCoordinate2D>
        let saved: Observable<Bool>
        let test: Observable<CLLocationCoordinate2D>
    }
    
    // MARK: - Output
    
    struct Output {
        let runTrigger: Driver<Void>
        let stopTrigger: Driver<Void>
        let dismissTrigger: Observable<Void?>
        let test: Observable<CLLocationCoordinate2D>
    }
    
    // MARK: - Properties
    
    var coordinators: [CLLocationCoordinate2D]?
    var actionDelegate: RunViewModelActionDelegate?
    var size: CGSize = CGSize(width: 0, height: 0)
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        let runTrigger = input.run
        
        // Test 37.337425, -122.032116
        //        let testPoint = Observable.just(CLLocationCoordinate2D(latitude: 37.337425, longitude: -122.032116))
        
        let center = Observable.combineLatest(input.startCoordinate, input.destinationCoordinate)
            .map { [weak self] in
                self?.centerPoint(start: $0, des: $1)
            }
        
        let dismiss = Observable.combineLatest(input.saved, center) { [weak self] in
            self?.takeSnapshot(with: $0, coordinate: $1!)
        }
        
        
        
        return Output(runTrigger: runTrigger, stopTrigger: input.stop, dismissTrigger: dismiss, test: input.startCoordinate)
    }
    
    // MARK: - Center Coordinate2D
    
    func centerPoint(start: CLLocationCoordinate2D, des: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        
        let centerX = start.latitude + (des.latitude - start.latitude) / 2
        let centerY = start.longitude + (des.longitude - start.longitude) / 2
        
        print("centerX: \(centerX), centerY: \(centerY)")
        
        return CLLocationCoordinate2D(latitude: centerX, longitude: centerY)
    }
    
    // MARK: - MKMapSnapShotter
    
    func takeSnapshot(with saved: Bool, coordinate: CLLocationCoordinate2D) {
        
        guard saved == true else {
            actionDelegate?.dismiss(with: saved, snapshot: nil)
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
            self?.actionDelegate?.dismiss(with: saved, snapshot: image)
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
}

