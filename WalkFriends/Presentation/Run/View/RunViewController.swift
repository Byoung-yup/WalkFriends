//
//  FavoriteListViewController.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/14.
//

import UIKit
import SnapKit
import MapKit
import RxSwift
import RxCocoa

class RunViewController: UIViewController {
    
    // MARK: - UI Properties
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.mapType = .standard
        mapView.delegate = self
        return mapView
    }()
    
//    lazy var contentView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .white
//        return view
//    }()
//
//    lazy var runBtn: UIButton = {
//        let btn = UIButton(type: .system)
//        btn.setTitle("시작하기", for: .normal)
//        btn.backgroundColor = .white
//        btn.titleLabel?.font = UIFont(name: "LettersforLearners", size: 15)
//        btn.setTitleColor(.green, for: .normal)
//        return btn
//    }()
    private let backBtn: UIButton = {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .medium)
        let image = UIImage(systemName: "xmark", withConfiguration: symbolConfig)
        let btn = UIButton(type: .system)
        btn.tintColor = .black
        btn.backgroundColor = .white
        btn.setImage(image, for: .normal)
        return btn
    }()
    
//
    private let stopBtn: UIButton = {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .medium)
        let image = UIImage(systemName: "stop.circle.fill", withConfiguration: symbolConfig)
        let btn = UIButton(type: .system)
        btn.tintColor = .red
        btn.backgroundColor = .clear
        btn.setImage(image, for: .normal)
        btn.isEnabled = false
        return btn
    }()
    
    // MARK: - Properties
    
    private let runViewModel: RunViewModel
    
    //    let locationManager: CLLocationManager
    
//    private var previousCoordinate: CLLocationCoordinate2D?
//    private var startCoordinate = BehaviorRelay<CLLocationCoordinate2D>(value: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0))
//    private var destinationCoordinate = BehaviorRelay<CLLocationCoordinate2D>(value: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0))
//    private var coordinators: [CLLocationCoordinate2D] = []
//
//    private var isSavedStatus: PublishSubject = PublishSubject<Bool>()
    
    private let disposeBag = DisposeBag()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configureUI()
        binding()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        backBtn.layer.cornerRadius = backBtn.frame.width / 2
        backBtn.clipsToBounds = true
    }
    
    
    
    // MARK: - Initialize
    
    init(viewModel: RunViewModel) {
        self.runViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("RunViewController - deinit")
    }
    
    // MARK: - Configure UI
    
    private func configureUI() {
        
//        navigationController?.navigationBar.backgroundColor = .clear
        
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.top.left.right.bottom.equalToSuperview()
        }
        
        mapView.addSubview(backBtn)
        backBtn.snp.makeConstraints { make in
            make.top.equalTo(mapView.safeAreaLayoutGuide.snp.top).offset(21)
            make.left.equalTo(mapView.safeAreaLayoutGuide.snp.left).offset(21)
            make.width.height.equalTo(30)
        }
        
        mapView.addSubview(stopBtn)
        stopBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(mapView.safeAreaLayoutGuide.snp.bottom).offset(-50)
        }
        
        //        mapView.addSubview(contentView)
        //        contentView.snp.makeConstraints { make in
        //            make.left.right.bottom.equalToSuperview()
        //            make.height.equalTo(mapView.snp.height).dividedBy(3)
        //        }
        //
        //        contentView.addSubview(runBtn)
        //        runBtn.snp.makeConstraints { make in
        //            make.bottom.equalToSuperview().offset(-30)
        //            make.centerX.equalToSuperview()
        //        }
        //
        //        contentView.addSubview(stopBtn)
        //        stopBtn.snp.makeConstraints { make in
        //            make.bottom.equalToSuperview().offset(-30)
        //            make.centerX.equalToSuperview()
        //        }
        
    }
    
    // MARK: - Binding
    
    private func binding() {
        
//        var points: [CLLocationCoordinate2D] = []
        
        let input = RunViewModel.Input(toBack: backBtn.rx.tap.asObservable(),
                                       stop: stopBtn.rx.tap.asObservable())
        let output = runViewModel.transform(input: input)
        
        output.toBack
            .subscribe(onNext: { [weak self] in
                
                guard let self = self else { return }
                
                self.runViewModel.actions.toBack()
            })
            .disposed(by: disposeBag)
        
        output.didChangeAuthorization
//            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (_, status) in
                
                guard let strongSelf = self else { return }
                
                switch status {
                case .denied:
                    strongSelf.showRequestLocationServiceAlert()
                case .notDetermined:
                    break
                case .restricted:
                    print("Authorization: restricted")
                case .authorizedAlways, .authorizedWhenInUse:          
                   break
                default:
                    break
                }
                
            }).disposed(by: disposeBag)
        
        output.didUpdateLocations
            .subscribe()
            .disposed(by: disposeBag)
        
        output.locations
            .subscribe(onNext: { [weak self] locations in
//                print("locations: \(locations)")
                guard let strongSelf = self else { return }
                
                let lineDraw = MKPolyline(coordinates: locations, count:locations.count)
                strongSelf.mapView.addOverlay(lineDraw)

            }).disposed(by: disposeBag)
        
        output.location
            .take(1)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] location in
//                print("location: \(location)")
                guard let strongSelf = self else { return }
                guard let currentLocation = location?.coordinate else { return }
                
                let region = CLLocationCoordinate2D(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
                let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                strongSelf.mapView.setRegion(MKCoordinateRegion(center: region, span: span), animated: true)
                
                let point = MKPointAnnotation()
                point.coordinate = currentLocation
                strongSelf.mapView.addAnnotation(point)
                
                strongSelf.stopBtn.isEnabled = true
                
            }).disposed(by: disposeBag)
        
        output.snapshot
            .subscribe()
            .disposed(by: disposeBag)
        
        
        //        let input = RunViewModel.Input(run: runBtn.rx.tap.asDriver(),
        //                                       stop: stopBtn.rx.tap.asDriver(),
        //                                       startCoordinate: startCoordinate.asObservable(),
        //                                       destinationCoordinate: destinationCoordinate.asObservable(),
        //                                       saved: isSavedStatus.asObservable())
        //        let output = runViewModel.transform(input: input)
        //
        //        output.runTrigger
        //            .drive(onNext: { [weak self] _ in
        //
        ////                self?.setCurrentPosition()
        ////                self?.checkForCLAuthorizationStatus()
        //            }).disposed(by: disposeBag)
        //
        //        output.stopTrigger
        //            .drive(onNext: { [weak self] _ in
        //                self?.stop()
        //            }).disposed(by: disposeBag)
        //
        //        output.dismissTrigger
        //            .subscribe()
        //            .disposed(by: disposeBag)
        
        
    }
    
}

// MARK: - CLLocation

//extension RunViewController {
    
    //    func checkUserDeviceLocationServiceAuthorization() {
    //
    //        let authorizationStatus: CLAuthorizationStatus
    //
    //        // 앱의 권한 상태 가져오는 코드 (iOS 버전에 따라 분기처리)
    //        if #available(iOS 14.0, *) {
    //            authorizationStatus = locationManager.authorizationStatus
    //        }else {
    //            authorizationStatus = CLLocationManager.authorizationStatus()
    //        }
    //
    //        checkUserCurrentLocationAuthorization(authorizationStatus)
    //    }
    //
    //    func checkUserCurrentLocationAuthorization(_ status: CLAuthorizationStatus) {
    //
    //        switch status {
    //        case .notDetermined:
    //            // 사용자가 권한에 대한 설정을 선택하지 않은 상태
    //
    //            // 권한 요청을 보내기 전에 desiredAccuracy 설정 필요
    //            locationManager.desiredAccuracy = kCLLocationAccuracyBest
    //
    //            // 권한 요청을 보낸다.
    //            locationManager.requestWhenInUseAuthorization()
    //
    //        case .denied, .restricted:
    //            // 사용자가 명시적으로 권한을 거부했거나, 위치 서비스 활성화가 제한된 상태
    //            // 시스템 설정에서 설정값을 변경하도록 유도한다.
    //            // 시스템 설정으로 유도하는 커스텀 얼럿
    //            showRequestLocationServiceAlert()
    //
    //        case .authorizedWhenInUse:
    //            // 앱을 사용중일 때, 위치 서비스를 이용할 수 있는 상태
    //            // manager 인스턴스를 사용하여 사용자의 위치를 가져온다.
    //            break
    //        default:
    //            print("Default")
    //        }
    //    }
    //
    //
    //    func showInfoAlert() {
    //
    //        let alert = UIAlertController(title: "안내", message: "기념 풍경 사진을 남겨두세요!", preferredStyle: .alert)
    //
    //        alert.addAction(UIAlertAction(title: "확인", style: .cancel))
    //
    //        present(alert, animated: true)
    //    }
    //
    //    func checkForCLAuthorizationStatus() {
    //
    //        let authorizationStatus: CLAuthorizationStatus
    //
    //        // 앱의 권한 상태 가져오는 코드 (iOS 버전에 따라 분기처리)
    //        if #available(iOS 14.0, *) {
    //            authorizationStatus = locationManager.authorizationStatus
    //        }else {
    //            authorizationStatus = CLLocationManager.authorizationStatus()
    //        }
    //
    //        if authorizationStatus == .authorizedWhenInUse  {
    //            setCurrentPosition()
    //        } else {
    //            showRequestLocationServiceAlert()
    //        }
    //    }
    
//    func setCurrentPosition() {
//
////        runBtn.isHidden = true
////        stopBtn.isHidden = false
//
//        guard let startPoint = previousCoordinate else { return }
//        startCoordinate.accept(startPoint)
//
//        let region = MKCoordinateRegion(center: startPoint, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
//        mapView.setRegion(region, animated: true)
//
//        setAnnotation(startPoint)
//
//        //        showInfoAlert()
//    }
//
//    private func setAnnotation(_ coordinate: CLLocationCoordinate2D) {
//
//        let point = MKPointAnnotation()
//        point.coordinate = coordinate
//        mapView.addAnnotation(point)
//    }
//
//    private func stop() {
//
//        // Test 37.337425, -122.032116
//        let testStartPoint1 = CLLocationCoordinate2D(latitude: 37.33233141, longitude: -122.0312186)
//        let testDesPoint1 = CLLocationCoordinate2D(latitude: 37.337425, longitude: -122.032116)
//
//        // Test 37.291298, 126.995740 / 37.294380, 126.993895
//        let testStartPoint2 = CLLocationCoordinate2D(latitude: 37.291298, longitude: 126.995740)
//        let testDesPoint2 = CLLocationCoordinate2D(latitude: 37.294380, longitude: 126.993895)
//
//        if let previousCoordinate = self.previousCoordinate {
//            runViewModel.coordinators = coordinators
//            runViewModel.size = mapView.frame.size
//            destinationCoordinate.accept(previousCoordinate)
//            //            runViewModel.coordinators?.append(testStartPoint2)
//            //            runViewModel.coordinators?.append(testDesPoint2)
//        }
//
//        //        locationManager.stopUpdatingLocation()
//
//        // 저장 여부 결정
//
//        let alert = UIAlertController(title: "안내", message: "해당 코스를 공유 하시겠습니까?", preferredStyle: .alert)
//
//        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { [weak self] _ in
//            self?.isSavedStatus.onNext(true)
//        }))
//        alert.addAction(UIAlertAction(title: "취소", style: .default, handler: { [weak self] _ in
//            self?.isSavedStatus.onNext(false)
//        }))
//
//        present(alert, animated: true)
//    }
//}

// MARK: - CLLocationManagerDelegate

//extension RunViewController: CLLocationManagerDelegate {
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//        guard let location = locations.last else {return}
//
//        let latitude = location.coordinate.latitude
//        let longtitude = location.coordinate.longitude
//        print("location: \(location)")
//        coordinators.append(CLLocationCoordinate2D(latitude: latitude, longitude: longtitude))
//
//        if let previousCoordinate = self.previousCoordinate {
//
//            var points: [CLLocationCoordinate2D] = []
//
//            let point1 = CLLocationCoordinate2DMake(previousCoordinate.latitude, previousCoordinate.longitude)
//            let point2: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longtitude)
//
//            points.append(point1)
//            points.append(point2)
//
//            let lineDraw = MKPolyline(coordinates: points, count:points.count)
//            self.mapView.addOverlay(lineDraw)
//        }
//
//        previousCoordinate = location.coordinate
//    }
//
//}

// MARK: - MKMapViewDelegate

extension RunViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        guard let polyLine = overlay as? MKPolyline else {
            print("can't draw polyline")
            return MKOverlayRenderer()
        }
        
        let renderer = MKPolylineRenderer(polyline: polyLine)
        
        renderer.strokeColor = .orange
        renderer.lineWidth = 5.0
        renderer.alpha = 1.0
        
        return renderer
    }
}
