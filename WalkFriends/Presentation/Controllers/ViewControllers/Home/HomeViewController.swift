//
//  HomeViewController.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/02/14.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import FirebaseAuth
import CoreLocation

class HomeViewController: UIViewController, UIScrollViewDelegate {
    
    let homeViewModel: HomeViewModel
    
    let disposeBag = DisposeBag()
    
    // MARK: - Properties
    
    lazy var main_Label: UILabel = {
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        lbl.text = "Walk Friends"
        lbl.textColor = .black
        let length = lbl.text!.count
        let attribtuedString = NSMutableAttributedString(string: lbl.text ?? "")
        let range = (lbl.text! as NSString).range(of: "Friends")
        attribtuedString.addAttribute(.foregroundColor, value: UIColor(red: 0.98, green: 0.66, blue: 0.15, alpha: 1.00), range: range)
        lbl.font = UIFont(name: "PartyConfetti-Regular", size: 40)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.attributedText = attribtuedString
        lbl.textAlignment = .left
        return lbl
    }()

    lazy var profile_Btn: UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        let systemImage = UIImage(systemName: "person", withConfiguration: imageConfig)
        let btn = UIButton(type: .system)
        btn.setImage(systemImage, for: .normal)
        btn.tintColor = .black
        return btn
    }()
    
    lazy var map_Searchbar: UISearchBar = {
        let margins = NSDirectionalEdgeInsets(top: 0, leading: 21, bottom: 0, trailing: 21)
        let bar = UISearchBar()
        bar.backgroundImage = UIImage()
        bar.searchTextField.backgroundColor = .systemGray
        bar.searchTextField.placeholder = "ex. 서린동"
        bar.directionalLayoutMargins = margins
        return bar
    }()
    
    lazy var cateLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "카테고리"
        lbl.textColor = .black
        lbl.font = UIFont(name: "LettersforLearners", size: 20)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.textAlignment = .left
        return lbl
    }()
    
    lazy var btn_StackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [category_Default_Btn, category_Popular_Btn, category_time_Btn, category_Distance_Btn])
        stackView.axis = .horizontal
        stackView.backgroundColor = .white
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var category_Default_Btn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("최신순", for: .normal)
        btn.titleLabel?.font = UIFont(name: "LettersforLearners", size: 15)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .main_Color
        btn.layer.cornerRadius = 20
        btn.layer.shadowColor = UIColor.gray.cgColor
        btn.layer.shadowOpacity = 0.6
        btn.layer.shadowOffset = CGSize(width: 0, height: 5)
        btn.tag = 100
        return btn
    }()
    
    lazy var category_Popular_Btn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("인기순", for: .normal)
        btn.titleLabel?.font = UIFont(name: "LettersforLearners", size: 15)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 20
        btn.layer.shadowColor = UIColor.gray.cgColor
        btn.layer.shadowOpacity = 0.6
        btn.layer.shadowOffset = CGSize(width: 0, height: 5)
        btn.tag = 101
        return btn
    }()
    
    lazy var category_time_Btn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("시간순", for: .normal)
        btn.titleLabel?.font = UIFont(name: "LettersforLearners", size: 15)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 20
        btn.layer.shadowColor = UIColor.gray.cgColor
        btn.layer.shadowOpacity = 0.6
        btn.layer.shadowOffset = CGSize(width: 0, height: 5)
        btn.tag = 102
        return btn
    }()
    
    lazy var category_Distance_Btn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("거리순", for: .normal)
        btn.titleLabel?.font = UIFont(name: "LettersforLearners", size: 15)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 20
        btn.layer.shadowColor = UIColor.gray.cgColor
        btn.layer.shadowOpacity = 0.6
        btn.layer.shadowOffset = CGSize(width: 0, height: 5)
        btn.tag = 103
        return btn
    }()
    
    lazy var mapListLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "산책코스"
        lbl.textColor = .black
        lbl.font = UIFont(name: "LettersforLearners", size: 20)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.textAlignment = .left
        return lbl
    }()
    
    lazy var mapListView = MapListView()
    
    lazy var runBtn: UIButton = {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        let systemImage = UIImage(systemName: "figure.run", withConfiguration: symbolConfig)
        let btn = UIButton(type: .system)
        btn.backgroundColor = .main_Color
        btn.setImage(systemImage, for: .normal)
        btn.tintColor = .white
        btn.layer.cornerRadius = 35
        return btn
    }()
    
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()
    
    // MARK: - Initialize
    
    init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
//        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit - \(self.description)")
    }
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        drawBackground()
        configureUI()
        Binding()
        
        let userInfo = FirebaseAuth.Auth.auth().currentUser?.providerData[0]
        print("HomeVC - User: \(userInfo?.email)")
        
//        print("current user uid: \(FirebaseService.shard.currentUser?.uid)")
//        print("current user email: \(FirebaseService.shard.currentUser?.email)")
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
        
//        profileView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
//        profileView.layer.cornerRadius = 20
        
//        profileView.layer.shadowColor = UIColor.gray.cgColor
//        profileView.layer.shadowRadius = 20
//        profileView.layer.shadowOffset = CGSize(width: 0, height: 10)
//        profileView.layer.shadowOpacity = 0.5

//    }
    
    // MARK: - Configure UI
    
    private func configureUI() {
        
//        navigationController?.navigationBar.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: main_Label)
//        let barButtonItem = UIBarButtonItem()
//        barButtonItem.customView = profile_Btn
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: profile_Btn)

//        view.addSubview(main_Label)
//        main_Label.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
//            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(21)
//        }
//
//        view.addSubview(profile_Btn)
//        profile_Btn.snp.makeConstraints { make in
//            make.centerY.equalTo(main_Label.snp.centerY)
//            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-21)
////            make.width.height.equalTo(main_Label.snp.height)
//        }
        
        view.addSubview(map_Searchbar)
        map_Searchbar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.height.equalTo(35)
        }
        
        view.addSubview(cateLbl)
        cateLbl.snp.makeConstraints { make in
            make.top.equalTo(map_Searchbar.safeAreaLayoutGuide.snp.bottom).offset(15)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(21)
        }
        
        view.addSubview(btn_StackView)
        btn_StackView.snp.makeConstraints { make in
            make.top.equalTo(cateLbl.safeAreaLayoutGuide.snp.bottom).offset(20)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(21)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-21)
            make.height.equalTo(40)
        }
        
        view.addSubview(mapListLbl)
        mapListLbl.snp.makeConstraints { make in
            make.top.equalTo(btn_StackView.safeAreaLayoutGuide.snp.bottom).offset(20)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(21)
        }
        
        view.addSubview(mapListView)
        mapListView.snp.makeConstraints { make in
            make.top.equalTo(mapListLbl.safeAreaLayoutGuide.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview()
//            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(21)
//            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-21)
//            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        mapListView.addSubview(runBtn)
        runBtn.snp.makeConstraints { make in
            make.right.equalTo(mapListView.safeAreaLayoutGuide.snp.right).offset(-21)
            make.bottom.equalTo(mapListView.safeAreaLayoutGuide.snp.bottom).offset(-30)
            make.width.height.equalTo(70)
        }
        
//        view.addSubview(category_CollectionView)
//        category_CollectionView.snp.makeConstraints { make in
//            make.top.equalTo(cateLbl.safeAreaLayoutGuide.snp.bottom).offset(20)
//            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(11)
//            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-11)
//            make.height.equalTo(50)
//        }
    }
    
    // MARK: - Binding
    
    private func Binding() {
        
        let category_Btns: [UIButton] = [category_Default_Btn, category_Popular_Btn, category_time_Btn, category_Distance_Btn]
        
        let input = HomeViewModel.Input(default_Btn: category_Default_Btn.rx.tap.asObservable(),
                                        popular_Btn: category_Popular_Btn.rx.tap.asObservable(),
                                        time_Btn: category_time_Btn.rx.tap.asObservable(),
                                        distance_Btn: category_Distance_Btn.rx.tap.asObservable())
        let output = homeViewModel.transform(input: input)
        
        output.toggle_Btn_Trigger
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { category in
                
                for btn in category_Btns {
                    
                    if btn.tag == category.rawValue {
                        btn.backgroundColor = .main_Color
                        btn.setTitleColor(.white, for: .normal)
                    } else {
                        btn.backgroundColor = .white
                        btn.setTitleColor(.black, for: .normal)
                    }
                }
                
            }).disposed(by: disposeBag)
        
        homeViewModel.items.bind(to: mapListView.mapListTableView.rx.items(cellIdentifier: MapListViewCell.identifier, cellType: MapListViewCell.self)) { (row, element, cell) in
            cell.mapList = element
            cell.selectionStyle = .none
        }.disposed(by: disposeBag)
        
        mapListView.mapListTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        runBtn
            .rx
            .tap
            .subscribe(onNext: { [weak self] in
                
                guard let strongSelf = self else { return }
                
                strongSelf.checkUserDeviceLocationServiceAuthorization()
                
            }).disposed(by: disposeBag)
        
        
        profile_Btn
            .rx
            .tap
            .bind(onNext: { [weak self] in
                
                guard let strongSelf = self else { return }
                    
                strongSelf.homeViewModel.actions.showInfoViewController()
                
            }).disposed(by: disposeBag)
        
        output.fetchTrigger
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                
                guard let strongSelf = self else { return }
                
                switch result {
                case .success(_):
                    break
                case.failure(let err):
                    
                    if err == .NotFoundUserError {
                        strongSelf.homeViewModel.actions.showSetupProfileViewController()
                    } else {
                        strongSelf.homeViewModel.actions.fetchError()
                    }
                }
            })
            .disposed(by: disposeBag)
//
//        homeViewModel.items
//            .bind(to: homeListView.collectionView.rx.items(cellIdentifier: "HomeListCell", cellType: HomeListCell.self)) { (row, text, cell) in
//                cell.label.text = "\(text)"
//            }.disposed(by: disposeBag)
//
//        homeListView.collectionView.rx.setDelegate(self)
//            .disposed(by: disposeBag)
    
    }
    
//    // MARK: - loadUserProfile
//
//    private func loadUserProfile() {
//
//        homeViewModel.fetchMyProfileData()
//            .subscribe(onNext: { [weak self] result in
//
//                if result {
//                    
//                } else {
//                    self?.setupProfile()
//                }
//            }).disposed(by: disposeBag)
//
//    }
//
//    // MARK: - setupProfile
//
//    private func setupProfile() {
//        homeViewModel.setupProfileView()
//    }

}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }
}

extension HomeViewController {
    
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
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            // 권한 요청을 보낸다.
            locationManager.requestWhenInUseAuthorization()
            
        case .denied, .restricted:
            // 사용자가 명시적으로 권한을 거부했거나, 위치 서비스 활성화가 제한된 상태
            // 시스템 설정에서 설정값을 변경하도록 유도한다.
            // 시스템 설정으로 유도하는 커스텀 얼럿
            
            DispatchQueue.main.async { [weak self] in
                
                self?.showRequestLocationServiceAlert()
            }
            
        case .authorizedWhenInUse:
            break
            // 앱을 사용중일 때, 위치 서비스를 이용할 수 있는 상태
            // manager 인스턴스를 사용하여 사용자의 위치를 가져온다.
//            homeViewModel.actionDelegate?.run(locationManager: self.locationManager)
            
        default:
            print("Default")
        }
    }
}
