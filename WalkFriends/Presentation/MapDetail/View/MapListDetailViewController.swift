//
//  MapListDetailViewController.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/04/18.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit
import FirebaseStorageUI

enum Items {
    case standard
    case important
}

struct human {
    let level: Items
    let name: String
    let age: Int
}

class MapListDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private let mapListDetailViewModel: MapListDetailViewModel
    
    let disposeBag = DisposeBag()
    
    // MARK: - UI Properties
    
    private let height = UIScreen.main.bounds.height / 2.5
    
    //    private var statusFrame: CGRect {
    //        let statusBarFrame: CGRect
    //        if #available(iOS 13.0, *) {
    //            statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
    //        } else {
    //            statusBarFrame = UIApplication.shared.statusBarFrame
    //        }
    //        return statusBarFrame
    //    }
    
    private lazy var main_ScrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .white
        view.bounces = false
        //        view.isPagingEnabled = true
        view.contentInsetAdjustmentBehavior = .never
        view.indicatorStyle = .black
        return view
    }()
    
    private lazy var main_ContentView: MapListDetailView = {
        let view = MapListDetailView()
        view.backgroundColor = .white
        return view
    }()
    
    //    private lazy var mapList_TableView = MapListTableView()
    
    private lazy var mapList_TableView: UITableView = {
        let tbView = UITableView()
        tbView.backgroundColor = .white
        //        tbView.register(MapListDetailViewCell.self, forCellReuseIdentifier: MapListDetailViewCell.identifier)
        tbView.register(InfoCell.self, forCellReuseIdentifier: InfoCell.identifier)
        //        tbView.register(ProfileCell.self, forCellReuseIdentifier: ProfileCell.identifier)
        tbView.bounces = false
        tbView.sectionHeaderTopPadding = .zero
        tbView.contentInsetAdjustmentBehavior = .never
        tbView.indicatorStyle = .black
        tbView.separatorStyle = .none
        //        tbView.separatorInset = UIEdgeInsets(top: 0, left: 21, bottom: 0, right: -21)
        return tbView
    }()
    
    private lazy var mapList_CollectionView: UICollectionView = {
        let layout = CustomCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        //        layout.sectionHeadersPinToVisibleBounds = true
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.bounces = false
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        collectionView.register(CustomCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CustomCollectionHeaderView.identifier)
        return collectionView
    }()
    
    private lazy var image_ScrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .white
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0)
        return view
    }()
    
    //    private lazy var navigationBar_inputView: UIView = {
    //        let view = UIView()
    //        view.backgroundColor = .red
    //        return view
    //    }()
    
    //    private lazy var back_Button: UIButton = {
    //        var config = UIButton.Configuration.plain()
    //        config.image = UIImage(systemName: "chevron.backward")
    //        config.baseForegroundColor = .black
    //        config.background.backgroundColor = .white
    //        config.background.cornerRadius = (AppAppearance.naviBarHeight / 1.5) / 2
    //        config.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3)
    //
    //        let btn = UIButton(type: .system)
    //        btn.configuration = config
    //        btn.layer.shadowColor = UIColor.gray.cgColor
    //        btn.layer.shadowOpacity = 0.5
    //        btn.layer.shadowOffset = CGSize(width: 0, height: 3)
    //        btn.layer.shadowPath = UIBezierPath(roundedRect: btn.bounds, cornerRadius: btn.layer.cornerRadius).cgPath
    //        return btn
    //    }()
    
    private lazy var back_Button = CircleButtion(systemName: "chevron.backward")
    private lazy var save_Button = CircleButtion(systemName: "heart")
    
    //    private lazy var save_Button: UIButton = {
    ////        var imageConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .semibold)
    ////        let image = UIImage(systemName: "suit.heart", withConfiguration: imageConfig)
    //
    //        var config = UIButton.Configuration.plain()
    //        config.image = UIImage(systemName: "suit.heart")
    //        config.baseForegroundColor = .black
    //        config.background.backgroundColor = .white
    //        config.background.cornerRadius = (AppAppearance.naviBarHeight / 1.5) / 2
    //
    //        let btn = UIButton(configuration: config)
    //        btn.layer.shadowColor = UIColor.gray.cgColor
    //        btn.layer.shadowOpacity = 0.5
    //        btn.layer.shadowOffset = CGSize(width: 0, height: 3)
    //        btn.layer.shadowPath = UIBezierPath(roundedRect: btn.bounds, cornerRadius: btn.layer.cornerRadius).cgPath
    //        return btn
    //    }()
    
    lazy var bgImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = .white
        imgView.contentMode = .scaleAspectFill
        imgView.image = UIImage(named: "Register_View_Bg")
        return imgView
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        confgureUI()
        setDelegate()
        binding()
    }
    
    //    override func viewDidAppear(_ animated: Bool) {
    //        super.viewDidAppear(animated)
    //        navigationController?.navigationBar.subviews.forEach {
    //            $0.clipsToBounds = false
    //        }
    //    }
    
    //    override func viewDidLayoutSubviews() {
    //        super.viewDidLayoutSubviews()
    //
    //        back_Button.layer.cornerRadius = back_Button.frame.height / 2
    //        save_Button.layer.cornerRadius = save_Button.frame.height / 2
    //    }
    
    // MARK: - Initialize
    
    init(mapListDetailViewModel: MapListDetailViewModel) {
        self.mapListDetailViewModel = mapListDetailViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure UI
    
    private func confgureUI() {
        
        //        let height = (navigationController?.navigationBar.frame.height) ?? 0
        //                main_ScrollView.delegate = self
        //        setNavigationBar()
        //        print(naviBarHeight)
        //        let window = UIApplication.shared.windows.first
        //        let top = window?.safeAreaInsets.top
        //        print("top: \(safeArea.top)")
        
        view.addSubview(mapList_TableView)
        mapList_TableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        
        
        //
        //        main_ScrollView.addSubview(main_ContentView)
        //        main_ContentView.snp.makeConstraints { make in
        //            make.top.equalToSuperview().offset(height)
        //            make.centerX.equalToSuperview()
        //            make.left.right.equalTo(main_ScrollView)
        //            make.bottom.equalToSuperview()
        //        }
        //
        //        main_ScrollView.addSubview(image_ScrollView)
        //        image_ScrollView.snp.makeConstraints { make in
        //            make.top.centerX.equalToSuperview().offset(0)
        //            make.left.right.equalTo(main_ScrollView)
        //            make.height.equalTo(height)
        //            make.bottom.equalTo(main_ContentView.snp.top)
        //        }
        
        //        view.addSubview(image_ScrollView)
        //        image_ScrollView.snp.makeConstraints { make in
        //            make.top.left.right.equalTo(view)
        //            make.bottom.equalTo(main_ContentView.snp.top)
        //        }
        //        view.addSubview(back_Button)
        //        back_Button.snp.makeConstraints { make in
        //            make.left.equalTo(view.safeAreaLayoutGuide).offset(21)
        //            make.top.equalTo(view).offset(top!)
        //            make.width.height.equalTo(height)
        //        }
        
        //        view.addSubview(containerView)
        //        containerView.snp.makeConstraints { make in
        //            make.top.left.right.equalTo(view)
        //            make.height.equalTo(AppAppearance.safeArea.top + AppAppearance.naviBarHeight)
        //        }
        ////
        //        containerView.addSubview(back_Button)
        //        back_Button.snp.makeConstraints { make in
        //            make.left.equalTo(containerView.safeAreaLayoutGuide.snp.left).offset(21)
        //            make.bottom.equalTo(containerView.safeAreaLayoutGuide.snp.bottom).offset(-5)
        //            make.width.height.equalTo(AppAppearance.naviBarHeight / 1.5)
        //        }
        //
        //        containerView.addSubview(save_Button)
        //        save_Button.snp.makeConstraints { make in
        //            make.right.equalTo(containerView.safeAreaLayoutGuide.snp.right).offset(-21)
        //            make.bottom.equalTo(containerView.safeAreaLayoutGuide.snp.bottom).offset(-5)
        //            make.width.height.equalTo(AppAppearance.naviBarHeight / 1.5)
        //        }
        
//        mapList_TableView.tableHeaderView = image_ScrollView
//        mapList_TableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: height)
//        ////
//        setup_HeaderView()
        
    }
    
    private func setup_HeaderView() {
        
        for index in 1...(mapListDetailViewModel.item.reference.count - 1) {
            
            let reference = mapListDetailViewModel.item.reference[index]
            
            let imageView = UIImageView()
            imageView.contentMode = .scaleToFill
            imageView.sd_setImage(with: reference)
            
            let xPosition = UIScreen.main.bounds.width * CGFloat(index - 1)
            imageView.frame = CGRect(x: xPosition,
                                     y: 0,
                                     width: UIScreen.main.bounds.width,
                                     height: UIScreen.main.bounds.height / 2)
            image_ScrollView.contentSize.width = UIScreen.main.bounds.width * CGFloat(index)
            image_ScrollView.addSubview(imageView)
        }
    }
    
    private func setNavigationBar() {
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = .white.withAlphaComponent(0)
        
        //        navigationController?.navigationBar.tintColor = .black
        //        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        //        navigationController?.navigationBar.alpha = 0
        
        //        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //        navigationController?.navigationBar.shadowImage = UIImage()
        //        navigationController?.navigationBar.alpha = 0
        //        let back_BarButtionItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: nil, action: nil)
        //        back_BarButtionItem.imageInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        //        navigationItem.leftBarButtonItem?.imageInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: back_Button)
        //        navigationItem.leftBarButtonItem?.customView?.alpha = 1
        //        navigationItem.rightBarButtonItem?.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -15)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: save_Button)
        //        navigationItem.rightBarButtonItem?.customView?.alpha = 1
        
        //        navigationItem.hidesBackButton = true
    }
    
    // MARK: - Set Delegate
    
    private func setDelegate() {
        main_ScrollView.delegate = self
    }
    
    // MARK: - Binding
    
    private func binding() {
        
        //        main_ContentView.mapData = mapListDetailViewModel.item
        
        let input = MapListDetailViewModel.Input()
        let output = mapListDetailViewModel.transform(input: input)
        
        //        output.userData
        //            .observe(on: MainScheduler.instance)
        //            .subscribe(onNext: { [weak self] data in
        //
        //                guard let self = self else { return }
        //                self.main_ContentView.items = data
        //            }).disposed(by: disposeBag)
        
        //        output.userData
        //            .observe(on: MainScheduler.instance)
        //            .subscribe(onNext: { [weak self] data in
        //
        //                guard let self = self else { return }
        //                self.main_ContentView.userData = data
        ////                self.main_ScrollView.updateContentSize()
        //            }).disposed(by: disposeBag)
        
        //        mapList_TableView.storageRef = mapListDetailViewModel.item.reference
        
        mapList_TableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        //
        output.userData
            .map { CollectionOfOne($0) }
            .bind(to: mapList_TableView.rx.items(cellIdentifier: InfoCell.identifier, cellType: InfoCell.self)) { (row, element, cell) in
                cell.containerView.items = element
            }.disposed(by: disposeBag)
        
        //                mapList_TableView.rx.setDataSource(self)
        //                    .disposed(by: disposeBag)
        
        
        //        mapList_CollectionView.rx.setDelegate(self)
        //            .disposed(by: disposeBag)
        //
        //        mapList_CollectionView.rx.setDataSource(self)
        //            .disposed(by: disposeBag)
    }
    
}

extension MapListDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //        mapList_TableView.scrollViewDidScroll(scrollView)
        
        let offsetY = scrollView.contentOffset.y
        
        if offsetY > 0 {
            image_ScrollView.snp.updateConstraints { make in
                make.top.equalToSuperview().offset(offsetY)
                //                make.height.equalTo(max(0, height - offsetY))
            }
            
            view.layoutIfNeeded()
        }
        
        
        //
        //        let content_Height = (AppAppearance.safeArea.top + AppAppearance.naviBarHeight)
        //        let default_Height = height - (content_Height + 30)
        //
        //        let dynamic_Offset = (height - content_Height - 30 - offsetY)
        //
        //        let transparent = abs(dynamic_Offset) / 30
        //
        //        let alpha = min(transparent, 1.0)
        //
        //        if offsetY > default_Height {
        //            containerView.backgroundColor = .white.withAlphaComponent(alpha)
        //
        ////            if transparent >= 1.0 {
        ////                back_Button.layer.shadowOpacity = Float(1.0 / transparent)
        ////            }
        ////            else {
        ////                back_Button.layer.shadowOpacity = 0.8
        ////            }
        ////            back_Button.layer.shadowOpacity = min(0.7, Float(0.01 / transparent))
        //        }
        //        else {
        //            containerView.backgroundColor = .white.withAlphaComponent(0)
        //        }
        
        
        
    }
}

//extension MapListDetailViewController: UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        return 1
//    }
//
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        if indexPath.row == 0 {
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: InfoCell.identifier, for: indexPath) as? InfoCell else {
//                return UITableViewCell()
//            }
//            cell.configureCell(title: mapListDetailViewModel.item.mapList.title, date: mapListDetailViewModel.item.mapList.date)
//            return cell
//        } else {
//            return UITableViewCell()
//        }
//    }
//}

extension MapListDetailViewController: UITableViewDelegate {
    //
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    //
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        for index in 1...(mapListDetailViewModel.item.reference.count - 1) {
            
            let reference = mapListDetailViewModel.item.reference[index]
            
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.sd_setImage(with: reference)
            
            let xPosition = UIScreen.main.bounds.width * CGFloat(index - 1)
            imageView.frame = CGRect(x: xPosition,
                                     y: 0,
                                     width: UIScreen.main.bounds.width,
                                     height: UIScreen.main.bounds.height / 2)
            image_ScrollView.contentSize.width = UIScreen.main.bounds.width * CGFloat(index)
            image_ScrollView.addSubview(imageView)
        }
        
        return image_ScrollView
        
        ////            mapList_TableView.addSubview(image_ScrollView)
        ////            image_ScrollView.snp.makeConstraints { make in
        ////                make.top.equalTo(view.snp.top)
        ////                make.width.equalToSuperview()
        ////                make.height.equalTo(containerView.snp.height)
        ////
        //                }
        ////
        ////            return bgImageView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return height
    }
}

extension MapListDetailViewController: UICollectionViewDelegate {
    
    
}

extension MapListDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as? CustomCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = .systemBlue
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CustomCollectionHeaderView.identifier, for: indexPath) as? CustomCollectionHeaderView else {
                return CustomCollectionHeaderView()
            }
            header.storageRef = mapListDetailViewModel.item.reference
            header.setup_HeaderView()
            return header
        } else {
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: height)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension MapListDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 2.2, height: view.frame.width / 2.2)
    }
}
