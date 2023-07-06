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

class HomeViewController: UIViewController, UIScrollViewDelegate {
    
    let homeViewModel: HomeViewModel
    
    let disposeBag = DisposeBag()
    
    // MARK: - Properties
    
    lazy var main_Label: UILabel = {
       let lbl = UILabel()
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
//        btn.backgroundColor = .white
        return btn
    }()
    
    lazy var map_Searchbar: UISearchBar = {
        let margins = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        let bar = UISearchBar()
        bar.backgroundImage = UIImage()
        bar.searchTextField.backgroundColor = .lightGray
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
    
//    lazy var category_CollectionView: UICollectionView = {
//        let flowLayout = UICollectionViewFlowLayout()
//        flowLayout.scrollDirection = .horizontal
//        flowLayout.itemSize = CGSize(width: (UIScreen.main.bounds.width) / 5, height: 40)
////        flowLayout.minimumLineSpacing = 20
//        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
//        collectionView.backgroundColor = .white
//        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
//        collectionView.showsHorizontalScrollIndicator = false
//        return collectionView
//    }()
    
//    lazy var homeListView: HomeListView = {
//        let view = HomeListView()
//        view.backgroundColor = .blue
//        return view
//    }()
    
    // MARK: - Initialize
    
    init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
//        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
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
        
//        view.addSubview(profileView)
//        profileView.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
//            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
//            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
//            make.height.equalTo(200)
//        }
        
//        view.addSubview(homeListView)
//        homeListView.snp.makeConstraints { make in
//            make.left.right.equalToSuperview()
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(80)
//            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
//        }
        
        view.addSubview(main_Label)
        main_Label.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(21)
        }
        
        view.addSubview(profile_Btn)
        profile_Btn.snp.makeConstraints { make in
            make.centerY.equalTo(main_Label.snp.centerY)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-21)
//            make.width.height.equalTo(main_Label.snp.height)
        }
        
        view.addSubview(map_Searchbar)
        map_Searchbar.snp.makeConstraints { make in
            make.top.equalTo(main_Label.safeAreaLayoutGuide.snp.bottom).offset(20)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.height.equalTo(35)
        }
        
        view.addSubview(cateLbl)
        cateLbl.snp.makeConstraints { make in
            make.top.equalTo(map_Searchbar.safeAreaLayoutGuide.snp.bottom).offset(20)
            make.left.equalTo(main_Label.safeAreaLayoutGuide.snp.left)
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
        
//        category_CollectionView.rx.setDelegate(self)
//            .disposed(by: disposeBag)
//
//        homeViewModel.category_Items.bind(to: category_CollectionView.rx.items(cellIdentifier: CategoryCollectionViewCell.identifier, cellType: CategoryCollectionViewCell.self)) { (row, text, cell) in
//            print("bind Cell")
//            cell.category_Btn.setTitle(text, for: .normal)
//        }.disposed(by: disposeBag)
        
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
//
//        output.trigger
//            .drive()
//            .disposed(by: disposeBag)
//
//        output.fetchTrigger
//            .drive(onNext: { [weak self] result in
//
//                guard let strongSelf = self else { return }
//
//                switch result {
//                case .success(_):
//                    break
//                case .failure(let err):
//
//                    if err == .NotFoundUserError {
////                        strongSelf.homeViewModel.actionDelegate?.setupProfile()
//                    }
//                    else {
//                        strongSelf.homeViewModel.actionDelegate?.error()
//                        strongSelf.showAlert(error: err)
//                    }
//                }
//
//            }).disposed(by: disposeBag)
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
