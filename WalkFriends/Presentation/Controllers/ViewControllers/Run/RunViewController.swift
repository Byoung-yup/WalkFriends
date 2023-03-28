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
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var runBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("시작하기", for: .normal)
        btn.backgroundColor = .white
        btn.titleLabel?.font = UIFont(name: "LettersforLearners", size: 15)
        btn.setTitleColor(.green, for: .normal)
        return btn
    }()
    
    lazy var stopBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("중단하기", for: .normal)
        btn.backgroundColor = .white
        btn.titleLabel?.font = UIFont(name: "LettersforLearners", size: 15)
        btn.setTitleColor(.red, for: .normal)
        btn.isHidden = true
        return btn
    }()
    
    // MARK: - Properties
    
    private let runViewModel: RunViewModel
    
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        manager.delegate = self
        return manager
    }()
    private var previousCoordinate: CLLocationCoordinate2D?
    
    private let disposeBag = DisposeBag()
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureUI()
        checkUserDeviceLocationServiceAuthorization()
        binding()
    }
    
    // MARK: - viewDidLayoutSubviews
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        contentView.layer.cornerRadius = 30
        
        runBtn.layer.borderColor = UIColor.green.cgColor
        runBtn.layer.borderWidth = 0.5
        stopBtn.layer.borderColor = UIColor.red.cgColor
        stopBtn.layer.borderWidth = 0.5
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
        
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mapView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(mapView.snp.height).dividedBy(3)
        }
        
        contentView.addSubview(runBtn)
        runBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-30)
            make.centerX.equalToSuperview()
        }
        
        contentView.addSubview(stopBtn)
        stopBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-30)
            make.centerX.equalToSuperview()
        }
        
    }
    
    // MARK: - Binding
    
    private func binding() {
        
        let input = RunViewModel.Input(run: runBtn.rx.tap.asDriver(),
                                       stop: stopBtn.rx.tap.asDriver())
        let output = runViewModel.transform(input: input)
        
        output.runTrigger
            .drive(onNext: { [weak self] _ in
                self?.checkForCLAuthorizationStatus()
            }).disposed(by: disposeBag)
        
        
    }
    
}

// MARK: - CLLocation

extension RunViewController {
    
    func checkUserDeviceLocationServiceAuthorization() {
        
        
        let authorizationStatus: CLAuthorizationStatus
        
        // 앱의 권한 상태 가져오는 코드 (iOS 버전에 따라 분기처리)
        if #available(iOS 14.0, *) {
            authorizationStatus = locationManager.authorizationStatus
        }else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        checkUserCurrentLocationAuthorization(authorizationStatus)
    }
    
    func checkUserCurrentLocationAuthorization(_ status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:
            // 사용자가 권한에 대한 설정을 선택하지 않은 상태
            
            // 권한 요청을 보내기 전에 desiredAccuracy 설정 필요
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            // 권한 요청을 보낸다.
            locationManager.requestWhenInUseAuthorization()
            
        case .denied, .restricted:
            // 사용자가 명시적으로 권한을 거부했거나, 위치 서비스 활성화가 제한된 상태
            // 시스템 설정에서 설정값을 변경하도록 유도한다.
            // 시스템 설정으로 유도하는 커스텀 얼럿
            showRequestLocationServiceAlert()
            
        case .authorizedWhenInUse:
            // 앱을 사용중일 때, 위치 서비스를 이용할 수 있는 상태
            // manager 인스턴스를 사용하여 사용자의 위치를 가져온다.
            break
        default:
            print("Default")
        }
    }
    
    func showRequestLocationServiceAlert() {
        let requestLocationServiceAlert = UIAlertController(title: "위치 정보 이용", message: "위치 서비스를 사용할 수 없습니다.\n디바이스의 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .default)
        
        requestLocationServiceAlert.addAction(cancel)
        requestLocationServiceAlert.addAction(goSetting)
        
        present(requestLocationServiceAlert, animated: true)
    }
    
    func checkForCLAuthorizationStatus() {
        
        let authorizationStatus: CLAuthorizationStatus
        
        // 앱의 권한 상태 가져오는 코드 (iOS 버전에 따라 분기처리)
        if #available(iOS 14.0, *) {
            authorizationStatus = locationManager.authorizationStatus
        }else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        if authorizationStatus == .authorizedWhenInUse  {
            setCurrentPosition()
            runBtn.isHidden = true
            stopBtn.isHidden = false
        } else {
            showRequestLocationServiceAlert()
        }
    }
    
    func setCurrentPosition() {
        
        guard let center = previousCoordinate else { return }
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
        setAnnotation()
    }
    
    private func setAnnotation() {
        
        guard let center = previousCoordinate else { return }
        
        let point = MKPointAnnotation()
        point.coordinate = center
        mapView.addAnnotation(point)
    }
}

extension RunViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {return}
        
        let latitude = location.coordinate.latitude
        let longtitude = location.coordinate.longitude
        
        if let previousCoordinate = self.previousCoordinate {
            
            var points: [CLLocationCoordinate2D] = []
            
            let point1 = CLLocationCoordinate2DMake(previousCoordinate.latitude, previousCoordinate.longitude)
            let point2: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longtitude)
            
            points.append(point1)
            points.append(point2)
            
            let lineDraw = MKPolyline(coordinates: points, count:points.count)
            self.mapView.addOverlay(lineDraw)
        }
        
        self.previousCoordinate = location.coordinate
        
    }
    
}

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
