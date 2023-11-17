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
//import FirebaseAuth
import CoreLocation

class HomeViewController: UIViewController {
    
    let homeViewModel: HomeViewModel
    
    let disposeBag = DisposeBag()
    
    // MARK: - Properties
    
    lazy var main_Label: UILabel = {
        let height = (navigationController?.navigationBar.frame.height)
        
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: height!))
        lbl.text = "Walk Friends"
        lbl.textColor = .black
        let length = lbl.text!.count
        let attribtuedString = NSMutableAttributedString(string: lbl.text ?? "")
        let range = (lbl.text! as NSString).range(of: "Friends")
        attribtuedString.addAttribute(.foregroundColor, value: UIColor(red: 0.98, green: 0.66, blue: 0.15, alpha: 1.00), range: range)
//        lbl.font = UIFont(name: "PartyConfetti-Regular", size: 30)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.attributedText = attribtuedString
        lbl.textAlignment = .left
        return lbl
    }()

    lazy var profile_Btn: UIButton = {
        let height = (navigationController?.navigationBar.frame.height)
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        let systemImage = UIImage(systemName: "person", withConfiguration: imageConfig)
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: height!, height: height!))
        btn.setImage(systemImage, for: .normal)
        btn.tintColor = .black
        return btn
    }()
    
    lazy var search_Btn: UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .medium)
        let systemImage = UIImage(systemName: "magnifyingglass", withConfiguration: imageConfig)
        let btn = UIButton(type: .system)
        btn.setImage(systemImage, for: .normal)
        btn.tintColor = .black
        return btn
    }()
    
//    lazy var map_Searchbar: UISearchBar = {
//        let margins = NSDirectionalEdgeInsets(top: 0, leading: 21, bottom: 0, trailing: 21)
//        let bar = UISearchBar()
//        bar.backgroundImage = UIImage()
//        bar.searchTextField.backgroundColor = .systemGray
//        bar.searchTextField.placeholder = "ex. 서린동"
//        bar.directionalLayoutMargins = margins
//        return bar
//    }()
    
    lazy var cateLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "카테고리"
        lbl.textColor = .black
        lbl.font = UIFont(name: "LettersforLearners", size: 20)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.textAlignment = .left
        return lbl
    }()
    
//    lazy var btn_StackView: UIStackView = {
//       let stackView = UIStackView(arrangedSubviews: [category_Default_Btn, category_Popular_Btn, category_time_Btn, category_Distance_Btn])
//        stackView.axis = .horizontal
//        stackView.backgroundColor = .clear
//        stackView.spacing = 10
//        stackView.distribution = .fillEqually
//        return stackView
//    }()
//
//    lazy var category_Default_Btn: UIButton = {
//        let btn = UIButton(type: .system)
//        btn.setTitle("최신순", for: .normal)
//        btn.titleLabel?.font = UIFont(name: "LettersforLearners", size: 15)
//        btn.setTitleColor(.white, for: .normal)
//        btn.backgroundColor = .main_Color
//        btn.layer.cornerRadius = 20
//        btn.layer.shadowColor = UIColor.gray.cgColor
//        btn.layer.shadowOpacity = 0.6
//        btn.layer.shadowOffset = CGSize(width: 0, height: 5)
//        btn.tag = 100
//        return btn
//    }()
//
//    lazy var category_Popular_Btn: UIButton = {
//        let btn = UIButton(type: .system)
//        btn.setTitle("인기순", for: .normal)
//        btn.titleLabel?.font = UIFont(name: "LettersforLearners", size: 15)
//        btn.setTitleColor(.black, for: .normal)
//        btn.backgroundColor = .white
//        btn.layer.cornerRadius = 20
//        btn.layer.shadowColor = UIColor.gray.cgColor
//        btn.layer.shadowOpacity = 0.6
//        btn.layer.shadowOffset = CGSize(width: 0, height: 5)
//        btn.tag = 101
//        return btn
//    }()
//
//    lazy var category_time_Btn: UIButton = {
//        let btn = UIButton(type: .system)
//        btn.setTitle("시간순", for: .normal)
//        btn.titleLabel?.font = UIFont(name: "LettersforLearners", size: 15)
//        btn.setTitleColor(.black, for: .normal)
//        btn.backgroundColor = .white
//        btn.layer.cornerRadius = 20
//        btn.layer.shadowColor = UIColor.gray.cgColor
//        btn.layer.shadowOpacity = 0.6
//        btn.layer.shadowOffset = CGSize(width: 0, height: 5)
//        btn.tag = 102
//        return btn
//    }()
//
//    lazy var category_Distance_Btn: UIButton = {
//        let btn = UIButton(type: .system)
//        btn.setTitle("거리순", for: .normal)
//        btn.titleLabel?.font = UIFont(name: "LettersforLearners", size: 15)
//        btn.setTitleColor(.black, for: .normal)
//        btn.backgroundColor = .white
//        btn.layer.cornerRadius = 20
//        btn.layer.shadowColor = UIColor.gray.cgColor
//        btn.layer.shadowOpacity = 0.6
//        btn.layer.shadowOffset = CGSize(width: 0, height: 5)
//        btn.tag = 103
//        return btn
//    }()
    
//    lazy var categoryView = CategoriView()
    
    
    lazy var mapListLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "산책코스"
        lbl.textColor = .black
        lbl.font = UIFont(name: "LettersforLearners", size: 20)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.textAlignment = .left
        return lbl
    }()
    
    lazy var categoryView = CategoryView()
    
    lazy var mapListTableView: UITableView = {
        let tbView = UITableView()
        tbView.backgroundColor = .clear
        tbView.separatorStyle = .none
        tbView.register(MapListViewCell.self, forCellReuseIdentifier: MapListViewCell.identifier)
        return tbView
    }()
    
//    lazy var mapListView = MapListView()
    
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
    
    // MARK: - LifeCycle
    
//    override func loadView() {
//        super.loadView()
//        print("loadView")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("viewDidLoad")
        view.backgroundColor = .red
        
//        drawBackground()
//        configureUI()
//        Binding()
        
//        let panGestureRecongnizer = UIPanGestureRecognizer(target: self, action: #selector(action))
//
//                panGestureRecongnizer.delegate = self
//
//                self.view.addGestureRecognizer(panGestureRecongnizer)
//        print("email: \(UserDefaults.standard.object(forKey: "email"))")
//        print("current user uid: \(FirebaseService.shard.currentUser?.uid)")
//        print("current user email: \(FirebaseService.shard.currentUser?.email)")
    }
    
//    @objc func action() {
//        navigationController?.hidesBarsOnSwipe = true
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        print("viewWillAppear")
//    }
//
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        print("viewWillLayoutSubviews")
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        print("viewDidLayoutSubviews")
//    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        print("viewDidAppear")
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        print("viewWillDisappear")
//    }
//
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        print("viewDidDisappear")
//    }
    
    deinit {
        print("deinit - \(self.description)")
    }
    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        print("didReceiveMemoryWarning")
//    }
    
    // MARK: - Configure UI
    
    private func configureUI() {

//        setNavigationbar()
//        setHeaderView()
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
        
//        view.addSubview(map_Searchbar)
//        map_Searchbar.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
//            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
//            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
//            make.height.equalTo(35)
//        }
        
//        view.addSubview(cateLbl)
//        cateLbl.snp.makeConstraints { make in
//            make.top.equalTo(map_Searchbar.safeAreaLayoutGuide.snp.bottom).offset(15)
//            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(21)
//        }
        
//        view.addSubview(btn_StackView)
//        btn_StackView.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
//            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(21)
//            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-21)
//            make.height.equalTo(40)
//        }
        
//        view.addSubview(mapListLbl)
//        mapListLbl.snp.makeConstraints { make in
//            make.top.equalTo(btn_StackView.safeAreaLayoutGuide.snp.bottom).offset(20)
//            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(21)
//        }
        
//        view.addSubview(categoryView)
//        categoryView.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
//            make.height.equalTo(55)
//            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
//            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
////            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
//        }
        
//        view.addSubview(mapListTableView)
//        mapListTableView.snp.makeConstraints { make in
//            make.top.equalTo(categoryView.safeAreaLayoutGuide.snp.bottom)
//            make.left.right.bottom.equalToSuperview()
//        }
        
//        categoryView.snp.makeConstraints { make in
//            make.width.equalToSuperview()
//            make.height.equalTo(55)
//        }
        
//        view.addSubview(runBtn)
//        runBtn.snp.makeConstraints { make in
//            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-21)
//            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
//            make.width.height.equalTo(70)
//        }
    }
    
    private func setNavigationbar() {
        
        let search_Button = UIBarButtonItem(customView: search_Btn)
        let profile_Buttion = UIBarButtonItem(customView: profile_Btn)
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: main_Label)
        navigationItem.rightBarButtonItems = [profile_Buttion, spacer, search_Button]
    }
    
    private func setHeaderView() {
        
//        mapListTableView.tableHeaderView = categoryView
    }
    
    // MARK: - Binding
    
    private func Binding() {
        
//        let category_Btns: [UIButton] = [categoryView.category_All_Btn,
//                                         categoryView.category_Popular_Btn,
//                                         categoryView.category_Time_Btn,
//                                         categoryView.category_Latest_Btn]
//
//        let input = HomeViewModel.Input(default_Btn: categoryView.category_All_Btn.rx.tap,
//                                        popular_Btn: categoryView.category_Popular_Btn.rx.tap,
//                                        time_Btn: categoryView.category_Time_Btn.rx.tap,
//                                        latest_Btn: categoryView.category_Latest_Btn.rx.tap)
//        let output = homeViewModel.transform(input: input)
//
//        output.toggle_Btn_Trigger
////            .observe(on: MainScheduler.asyncInstance)
//            .subscribe(onNext: { category in
//
////                print(category)
//                for btn in category_Btns {
//
//                    if btn.tag == category.rawValue {
//
//                        btn.backgroundColor = .main_Color
//                        btn.setTitleColor(.white, for: .normal)
//                        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .bold)
//                    } else {
////                        print("X tag: \(btn.tag)")
//
//                        btn.backgroundColor = .white
//                        btn.setTitleColor(.black, for: .normal)
//                        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .light)
//                    }
//                }
//
//            }).disposed(by: disposeBag)
//
//        output.fetch_MapLists
//            .map {
//                var x: [FinalMapList] = []
//                switch $0 {
//                case .success(let maplists):
//                    x.append(contentsOf: maplists)
//                case .failure(let err):
//                    break
//                }
//                return x
//            }
//            .bind(to: mapListTableView.rx.items(cellIdentifier: MapListViewCell.identifier, cellType: MapListViewCell.self)) { (row, element, cell) in
//                cell.mapList = element
////                print("maplist: \(element)")
//                cell.selectionStyle = .none
//            }.disposed(by: disposeBag)
//
////        output.mapListItems.bind(to: mapListView.mapListTableView.rx.items(cellIdentifier: MapListViewCell.identifier, cellType: MapListViewCell.self)) { (row, element, cell) in
////            cell.mapList = element
////            cell.selectionStyle = .none
////        }.disposed(by: disposeBag)
//
//        mapListTableView.rx.setDelegate(self)
//            .disposed(by: disposeBag)
//
//        mapListTableView
//            .rx
//            .modelSelected(FinalMapList.self)
//            .subscribe(onNext: { [weak self] mapList in
//
//                guard let self = self else { return }
//
//                // Test
////                let vc = MapListDetailViewController(mapListDetailViewModel: MapListDetailViewModel(dataUseCase: DefaultDataUseCase(dataBaseRepository: DatabaseManager(), storageRepository: StorageManager()), item: mapList, actions: MapListDetailViewModelActions()))
////                vc.modalPresentationStyle = .overFullScreen
////                self.present(vc, animated: false)
//                self.homeViewModel.actions.showMapListDetailViewController(mapList)
////                print("mapList: \(mapList)")
//
//            }).disposed(by: disposeBag)
//
//        runBtn
//            .rx
//            .tap
//            .subscribe(onNext: { [weak self] in
//
//                guard let strongSelf = self else { return }
//
//                strongSelf.homeViewModel.actions.showRunViewController()
//
//            }).disposed(by: disposeBag)
//
//
//        profile_Btn
//            .rx
//            .tap
//            .bind(onNext: { [weak self] in
//
//                guard let strongSelf = self else { return }
//
//                strongSelf.homeViewModel.actions.showInfoViewController()
//
//            }).disposed(by: disposeBag)
//
//        output.fetchTrigger
//            .observe(on: MainScheduler.instance)
//            .subscribe(onNext: { [weak self] result in
//                print("user Exist: \(result)")
//                guard let strongSelf = self else { return }
//
//                switch result {
//                case .success(_):
//                    break
//                case.failure(let err):
//
//                    if err == .NotFoundUserError {
//                        strongSelf.homeViewModel.actions.showSetupProfileViewController()
//                    } else {
//                        strongSelf.homeViewModel.actions.fetchError()
//                    }
//                }
//            })
//            .disposed(by: disposeBag)
//
////        output.fetch_MapLists
////            .subscribe(onNext: { [weak self] result in
////
////                guard let self = self else { return }
////
////                switch result {
////                case .success(let items):
////                    self.homeViewModel.mapListItems.accept(items)
////                case .failure(let err):
////                    break
////                }
////
////            }).disposed(by: disposeBag)
////        homeViewModel.items
////            .bind(to: homeListView.collectionView.rx.items(cellIdentifier: "HomeListCell", cellType: HomeListCell.self)) { (row, text, cell) in
////                cell.label.text = "\(text)"
////            }.disposed(by: disposeBag)
////
////        homeListView.collectionView.rx.setDelegate(self)
////            .disposed(by: disposeBag)
    
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
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        let headerView = categoryView
//        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 55)
//        return headerView
//    }
}
//
//extension HomeViewController: UIGestureRecognizerDelegate {
//
//    func gestureRecognizer(_: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith: UIGestureRecognizer) -> Bool {
//        return true
//    }
//}

extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let height = navigationController?.navigationBar.frame.height ?? 0
        let safeAreaInset = (navigationController?.navigationBar.safeAreaInsets.top)!
//        print("safeAreaInset: \(safeAreaInset)")
        let _offset = scrollView.contentOffset.y + height

        let offset = height - safeAreaInset

        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {


            UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions()) {
                self.navigationController?.navigationBar.layer.opacity = 0
                self.categoryView.snp.updateConstraints({ make in
                    make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(0.1)
                })


                self.view.layoutIfNeeded()
            }
        }
        else {


            UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions()) {
                self.navigationController?.navigationBar.layer.opacity = 1
                self.categoryView.snp.updateConstraints({ make in
                    make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                })


                self.view.layoutIfNeeded()
            }
        }
    }
    
}


