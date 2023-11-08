//
//  LocationViewController.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/10/05.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa
import MapKit
import RxCoreLocation

final class LocationViewController: UIViewController {
    
    // MARK: - Properties
    
    private let locationViewModel: LocationViewModel
    private let disposeBag = DisposeBag()
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()
    var authorizationStatus: CLAuthorizationStatus!
    var currentLocation: CLLocation!
    
    private var searchCompleter: MKLocalSearchCompleter?
//    private var searchRegion: MKCoordinateRegion = MKCoordinateRegion(MKMapRect.world)
    var completerResults: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    
//    let testItem = BehaviorRelay(value: ["경기도 수원시 장안구 정자동"])
    
    // MARK: - UI Properties
    
    //    lazy var back_BarButtonItem: UIBarButtonItem = {
    //        let btn = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .done, target: nil, action: nil)
    //        btn.tintColor = .black
    //        return btn
    //    }()
    
    lazy var indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.backgroundColor = .clear
        view.tintColor = .gray
        view.hidesWhenStopped = true
        return view
    }()
    
    lazy var back_Btn: UIButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .clear
        config.image = UIImage(systemName: "chevron.backward")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        
        let btn = UIButton(configuration: config)
        return btn
    }()
    
    lazy var navigationBar: UINavigationBar = {
        let bar = UINavigationBar(frame: CGRect(x: 0, y: safeArea.top, width: view.frame.size.width, height: naviBarHeight))
        bar.shadowImage = UIImage()
        bar.setBackgroundImage(UIImage(), for: .default)
        return bar
    }()
    
//    let searchVC = UISearchController()
    
    //    lazy var searchBar: UISearchBar = {
    //        let sb = UISearchBar()
    //        sb.searchTextField.backgroundColor = .clear
    //        sb.searchTextField.font = UIFont.systemFont(ofSize: 14, weight: .light)
    //        sb.searchTextField.textColor = .black
    //        sb.searchTextField.autocapitalizationType = .none
    //        sb.setImage(UIImage(), for: UISearchBar.Icon.search, state: .normal)
    //        sb.layer.cornerRadius = 10
    //        sb.layer.borderWidth = 0.5
    //        sb.layer.borderColor = UIColor.black.cgColor
    //        sb.translatesAutoresizingMaskIntoConstraints = false
    //        return sb
    //    }()
    
    lazy var location_TextField: UITextField = {
        let tf = UITextField(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 0))
        tf.textColor = .black
        tf.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        tf.backgroundColor = .lightGray.withAlphaComponent(0.5)
        tf.borderStyle = .roundedRect
        tf.returnKeyType = .search
        return tf
    }()
    
    lazy var title_StackView: UIStackView = {
        let stView = UIStackView(arrangedSubviews: [back_Btn, location_TextField])
        stView.axis = .horizontal
        stView.distribution = .fill
        //        stView.alignment = .center
        stView.backgroundColor = .clear
        return stView
    }()
    
    lazy var title_Lbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "검색 결과"
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    lazy var location_TableView: UITableView = {
        let tbView = UITableView()
        tbView.backgroundColor = .clear
        tbView.register(LocationListCell.self, forCellReuseIdentifier: LocationListCell.identifier)
        tbView.separatorStyle = .none
        tbView.showsVerticalScrollIndicator = false
        tbView.keyboardDismissMode = .onDrag
        return tbView
    }()
    
    // MARK: - Initialize
    
    init(locationViewModel: LocationViewModel) {
        self.locationViewModel = locationViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureUI()
        binding()
        
//        locationManager.requestWhenInUseAuthorization()
        //        location_TextField.delegate = self
        searchCompleter = MKLocalSearchCompleter()
        searchCompleter?.delegate = self
        searchCompleter?.resultTypes = .address
        //        searchCompleter?.region = searchRegion
        
        //        searchVC.searchBar.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        searchCompleter = nil
    }
    
    deinit {
        print("\(self.description) - deinit")
    }
    
    // MARK: - Configure UI
    
    private func configureUI() {
        
        drawBackground()
        set_NaviBar()
        
        view.addSubview(title_Lbl)
        title_Lbl.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.safeAreaLayoutGuide.snp.bottom).offset(20)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(21)
        }
        
        view.addSubview(location_TableView)
        location_TableView.snp.makeConstraints { make in
            make.top.equalTo(title_Lbl.safeAreaLayoutGuide.snp.bottom).offset(10)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(21)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-21)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { make in
            make.center.equalTo(location_TableView.snp.center)
            make.width.height.equalTo(50)
        }
        //
        //        titleView.addSubview(title_StackView)
        //        title_StackView.snp.makeConstraints { make in
        //            make.bottom.equalTo(titleView.safeAreaLayoutGuide)
        //            make.left.right.equalTo(titleView)
        //            make.height.equalTo(naviBarHeight)
        //        }
        //
        //        back_Btn.snp.makeConstraints { make in
        //            make.width.height.equalToSuperview()
        //        }
    }
    
    private func set_NaviBar() {
        
        //        let naviBar = UINavigationBar(frame: CGRect(x: 0, y: safeArea.top, width: view.frame.size.width, height: naviBarHeight))
        //        naviBar.shadowImage = UIImage()
        //        naviBar.setBackgroundImage(UIImage(), for: .default)
        
        let naviItem = UINavigationItem()
        let left_CustomView = UIBarButtonItem(customView: back_Btn)
        
        naviItem.titleView = location_TextField
        naviItem.leftBarButtonItem = left_CustomView
        
        navigationBar.setItems([naviItem], animated: false)
        
        view.addSubview(navigationBar)
        
        
        //        navigationController?.navigationBar.shadowImage = UIImage()
        //        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //
        //        navigationItem.leftBarButtonItem = back_BarButtonItem
        //        location_TextField.frame = CGRect(x: back_BarButtonItem.width, y: 0, width: (navigationController?.navigationBar.frame.size.width)! - back_BarButtonItem.width, height: (navigationController?.navigationBar.frame.size.height)!)
        //        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: location_TextField)
    }
    
    // MARK: - Binding
    
    private func binding() {
        
        let textFieldObservable = location_TextField.rx.text.orEmpty
        
        let input = LocationViewModel.Input(toBack_Trigger: back_Btn.rx.tap.asObservable())
        let output = locationViewModel.transform(input: input)
        
        output.toBack
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                self?.locationViewModel.actions.toBack()
            }).disposed(by: disposeBag)

        
//        locationManager
//            .rx
//            .didChangeAuthorization
//            .subscribe(onNext: { [weak self] (_, status) in
//
//                guard let self = self else { return }
////                print("status: \(status)")
//                switch status {
//                case .denied:
//                    self.showPopup()
//                case .notDetermined:
////                    self.showPopup()
//                    break
//                case .restricted:
//                    print("Authorization: restricted")
//                case .authorizedAlways, .authorizedWhenInUse:
//                    print("authorizedAlways")
//                    self.locationManager.startUpdatingLocation()
//                default:
//                    break
//                }
//                self.authorizationStatus = status
//            }).disposed(by: disposeBag)
        
//        locationManager
//            .rx
//            .location
//            .compactMap { $0 }
//            .subscribe(onNext: { [weak self] location in
//                print("location: \(location)")
//                self?.search_CurrentLocation(location: location)
//            }).disposed(by: disposeBag)
        
//        locationManager
//            .rx
//            .didUpdateLocations
//            .take(1)
//            .subscribe(onNext: { [weak self] (_, location) in
////                print("locations: \(location)")
////                self?.completerResults.accept([])
////                self?.search_CurrentLocation(location: location.last!)
//            }).disposed(by: disposeBag)
        
        completerResults
            .bind(to: location_TableView.rx.items(cellIdentifier: LocationListCell.identifier, cellType: LocationListCell.self)) { (row, item, cell) in
                cell.location_Lbl.text = item
                cell.selectionStyle = .none
            }.disposed(by: disposeBag)
        
        location_TableView.rx.modelSelected(String.self)
            .bind(onNext: { [weak self] item in
                
                guard let self = self else { return }
//                print(item)
                self.locationViewModel.actions.showLoginViewController()
            }).disposed(by: disposeBag)
        
        location_TextField
            .rx
            .text.orEmpty
            .filter { $0.count >= 1 }
            .observe(on: MainScheduler.instance)
//            .map { $0.components(separatedBy: " ") }
//            .filter { !$0.contains("로") && !$0.contains("번길") }
//            .map { $0.joined(separator: " ") }
            .subscribe(onNext: { [weak self] str in

                guard let self = self else { return }
                
//                var filteredInput = str.components(separatedBy: " ")
//                if filteredInput.contains("로") || filteredInput.contains("번길") {
//                    filteredInput = [""]
//                }
//
//                print("filteredInput: \(filteredInput)")
//                let queryFragment = filteredInput.joined(separator: " ")
//                print("queryFragment: \(queryFragment)")
                self.searchCompleter?.queryFragment = str
                
//                if str.isEmpty {
//
//                    self.title_Lbl.text = "검색 결과"
//
//                } else {
//                    self.title_Lbl.text = "'\(str)'검색 결과"
//
//                }
                self.title_Lbl.text = "'\(str)'검색 결과"

//                self.setup_TableView_Placeholder()
            }).disposed(by: disposeBag)
            
        
//        NotificationCenter.default.rx.notification(UIApplication.didBecomeActiveNotification)
//            .subscribe(onNext: { [weak self] _ in
//                print("Active")
//                guard let self = self else { return }
//
//                switch self.authorizationStatus {
//                case .denied:
//                    self.locationManager.stopUpdatingLocation()
//                    self.showPopup()
//                case .notDetermined:
////                    self.showPopup()
//                    break
//                case .restricted:
//                    print("Authorization: restricted")
//                case .authorizedAlways, .authorizedWhenInUse:
//                    print("authorizedAlways")
//                    self.locationManager.startUpdatingLocation()
//                    self.completerResults.accept([])
//                    self.search_CurrentLocation(location: self.currentLocation)
//                default:
//                    break
//                }
//
//            }).disposed(by: disposeBag)
        
        //        searchVC.searchBar
        //            .rx
        //            .setDelegate(self)
        //            .disposed(by: disposeBag)
        //
        //        searchVC.searchBar
        //            .rx.text.orEmpty
        //            .filter { $0.count >= 1 }
        //            .asDriver(onErrorJustReturn: "")
        //            .drive(onNext: { [weak self] str in
        //
        //                guard let self = self else { return }
        //
        //                self.search_Text = str
        //                //                self.searchCompleter?.queryFragment = str
        //            }).disposed(by: disposeBag)
        //
        //        searchVC.searchBar
        //            .rx
        //            .textDidEndEditing
        //            .asDriver()
        //            .drive(onNext: { [weak self] in
        //
        //                guard let self = self else { return }
        //                self.title_Lbl.text = "'\(self.search_Text)'검색 결과"
        //                self.searchCompleter?.queryFragment = self.search_Text
        //
        //            }).disposed(by: disposeBag)
        
    }
}

// MARK: - Popup

extension LocationViewController {
    
    private func showPopup() {
        let popup = Location()
        popup.appear(sender: self)
    }
}

// MARK: - MKLocalSearch

extension LocationViewController {
    
//    private func search_CurrentLocation(location: CLLocation) {
//
//        let geocoder = CLGeocoder()
//        let locale = Locale(identifier: "Ko-kr")
//
//        geocoder.reverseGeocodeLocation(location, preferredLocale: locale) { [weak self] (placemark, error) in
//
//            guard let self = self else { return }
//
//            guard let placemarks = placemark, let placemarkInfo = placemarks.first else { return }
//            print(placemarkInfo)
//            self.completerResults.accept([placemarkInfo.address])
//
//
//        }
//    }
    
    private func searchForAddress(address: String) {
        print("searchForAddress address: \(address)")
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = address

        let search = MKLocalSearch(request: request)
        search.start { [weak self] (response, error) in
            guard let self = self else { return }
            guard let response = response else {
                if let error = error {
                    print("주소 검색 에러: \(error.localizedDescription)")
                }
                return
            }

            for mapItem in response.mapItems {
                let placemark = mapItem.placemark
//                print("placemark: \(placemark)")
                let address = placemark.address
                self.completerResults.accept(self.completerResults.value + [address])
            }
        }
    }
}

// MARK: - TableView Placeholder

extension LocationViewController {
    
    private func setup_TableView_Placeholder() {
        
        let bgView = BackgroundView(frame: CGRect(x: location_TableView.frame.origin.x, y: location_TableView.frame.origin.y, width: location_TableView.frame.size.width, height: location_TableView.frame.size.height))
//        print("completerResults: \(completerResults.value)")
        if completerResults.value.isEmpty {
            location_TableView.backgroundView = bgView
        }
        else {
            location_TableView.backgroundView = nil
        }
    }
}

//extension LocationViewController: UITextFieldDelegate {
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        print("textFieldDidEndEditing")
//    }
//
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        print("textFieldDidBeginEditing")
//    }
//
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        print("textFieldShouldEndEditing")
//        return true
//    }
//}

//extension LocationViewController: UISearchBarDelegate {
//
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        print("end")
//    }
//}

extension LocationViewController: MKLocalSearchCompleterDelegate {

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
//        print("completerDidUpdateResults")
//        let query = ["로", "번길"]
        completerResults.accept([])

        let items = completer.results.filter { $0.title.contains("대한민국") }
//            .map { $0.title.replacingOccurrences(of: "대한민국", with: "") }
        
        for item in items {

            if item.title.contains("로") || item.title.contains("번길") {
                continue
            } else {
                let newItem = item.title.replacingOccurrences(of: "대한민국", with: "")
                completerResults.accept(completerResults.value + [newItem])
            }
//            let filterd = item.components(separatedBy: " ").filter {
//                !$0.contains("로") && !$0.contains("번길")
//            }
//            let joined = filterd.joined(separator: " ")
            
        }
//
//        for item in items {
//            completerResults.accept(completerResults.value + [item])
//        }
        setup_TableView_Placeholder()
//
//
//        for item in items {
//            //            print("item: \(item)")
//            //            completerResults.accept(completerResults.value + [item.title])
//            let searchRequest = MKLocalSearch.Request(completion: item)
//            //            searchRequest.region = searchRegion
//            //            searchRequest.resultTypes =
//            let search = MKLocalSearch(request: searchRequest)
//            //
//            //
//            search.start { [weak self] (response, error) in
//
//                guard error == nil else {
//                    print("MKLocalSearch Error: \(error!.localizedDescription)")
//                    return
//                }
//                guard let placeMark = response?.mapItems[0].placemark else {
//                    return
//                }
//                //                print("placeMark: \(placeMark)")
//                let location = placeMark.title?.dropFirst(5)
//                self?.completerResults.accept((self?.completerResults.value)! + [String(location!)])
//                //                let coordinate = placeMark.coordinate
//                //                let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
//                //                let local: Locale = Locale(identifier: "Ko-kr") // Korea
//                //
//                //                let geocoder = CLGeocoder()
//                //                geocoder.reverseGeocodeLocation(location, preferredLocale: local) { (placeMarks, error) in
//                //
//                //                    if let placemark: [CLPlacemark] = placeMarks {
//                //                        let address = placemark.last?.address
//                //                        self?.completerResults.accept((self?.completerResults.value)! + [address!])
//                //                    }
//                //
//                //                }
//
//            }
//        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        if let error = error as NSError? {
            print("MKLocalSearchCompleter encountered an error: \(error.localizedDescription). The query fragment is: \"\(completer.queryFragment)\"")
        }
    }
}
