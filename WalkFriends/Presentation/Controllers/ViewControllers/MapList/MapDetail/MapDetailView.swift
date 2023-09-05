//
//  MapDetailView.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/08/30.
//

import Foundation
import UIKit
import SnapKit
import SDWebImage
import FirebaseStorageUI

final class MapDetailView: UIView {
    
    // MARK: - Properties
    
    var item: FinalMapList? {
        didSet {
            setup_Image_ScrollView()
        }
    }
    
    var time: Float = 0.0
    var timer: Timer?
    
    // MARK: - UI Properties
    
    lazy var progressView: UIProgressView = {
        let view = UIProgressView()
        view.trackTintColor = .white
        view.progressTintColor = .main_Color
        view.progress = 0.0
        view.backgroundColor = .white
        return view
    }()
    
    lazy var main_ScrollView: UIScrollView = {
        let view = UIScrollView()
        //        view.backgroundColor = .red
        view.showsVerticalScrollIndicator = false
        view.bounces = false
        return view
    }()
    
    private lazy var main_ContentView: UIView = {
        let view = UIView()
        //        view.backgroundColor = .yellow
        return view
    }()
    
    lazy var image_ScrollView: UIScrollView = {
        let view = UIScrollView()
        //        view.backgroundColor = .green
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    //    lazy var image_ContentView: UIView = {
    //        let view = UIView()
    //        view.backgroundColor = .blue
    //        return view
    //    }()
    
    lazy var image_PageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.hidesForSinglePage = true
        pc.currentPageIndicatorTintColor = .white
        pc.pageIndicatorTintColor = .systemGray
        //        pc.backgroundColor = .yellow
        return pc
    }()
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("init frame")
        configureUI()
        set_Delegate()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("init coder")
        configureUI()
        set_Delegate()
    }
    
    // MARK: - Configure UI
    
    private func configureUI() {
        
        addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(5)
        }
        
        addSubview(main_ScrollView)
        main_ScrollView.snp.makeConstraints { make in
            make.top.equalTo(progressView.safeAreaLayoutGuide.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        main_ScrollView.addSubview(main_ContentView)
        main_ContentView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.top.bottom.equalToSuperview()
            make.height.equalTo(snp.height).multipliedBy(2)
        }
        
        main_ContentView.addSubview(image_ScrollView)
        image_ScrollView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(snp.height).dividedBy(2)
        }
        
        main_ContentView.addSubview(image_PageControl)
        image_PageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(image_ScrollView.safeAreaLayoutGuide.snp.bottom)
            //            make.width.equalTo(50)
            //            make.height.equalTo(30)
        }
        //
        //        image_ScrollView.addSubview(image_ContentView)
        //        image_ContentView.snp.makeConstraints { make in
        //            make.height.equalToSuperview()
        //            make.centerY.left.right.equalToSuperview()
        //        }
        //
    }
    
    private func set_Delegate() {
        image_ScrollView.delegate = self
    }
}

extension MapDetailView {
    
    // MARK: - Setup Image ScrollView
    
    func setup_Image_ScrollView() {
        print("setup_Image_ScrollView")
        setup_PageControl()
        guard let item = item else { return }

//        timer?.invalidate()

        for index in 1...(item.reference.count - 1) {

//            guard let url = URL(string: item.reference[index]) else { return }
            
            let ref = item.reference[index]

            let imageView = UIImageView()
            imageView.backgroundColor = .systemGray
//            imageView.sd_setImage(with: url)
            imageView.sd_setImage(with: ref)
            imageView.contentMode = .scaleToFill
            //            imageView.layer.cornerRadius = 10
            //            imageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            //            imageView.clipsToBounds = true

            let xPosition = UIScreen.main.bounds.width * CGFloat(index - 1)
            //            print("width: \(main_ContentView.frame.width)")
            //            print("xPosition: \(xPosition)")
            imageView.frame = CGRect(x: xPosition,
                                     y: 0,
                                     width: UIScreen.main.bounds.width,
                                     height: UIScreen.main.bounds.height / 2)
            //            print("imageView.frame: \(imageView.frame)")
            image_ScrollView.contentSize.width = UIScreen.main.bounds.width * CGFloat(index)
            //            image_ContentView.snp.remakeConstraints { make in
            //                make.width.equalTo(UIScreen.main.bounds.width).multipliedBy(index)
            //            }
            image_ScrollView.addSubview(imageView)

//            time += 1.0 / Float((item.imageUrls.count - 1))
//            print("time: \(time)")
//            progressView.setProgress(time, animated: true)
//
//            if time >= 1.0 {
//
//                UIView.animate(withDuration: 0.5,
//                               delay: 0,
//                               options: .transitionCrossDissolve,
//                               animations: { [weak self] in
//                    self?.main_ScrollView.isHidden = false
//                }) { [weak self] _ in
//                    self?.progressView.progressTintColor = .white
//                }
//            }
        }
    }
    
    func setup_PageControl() {
        image_PageControl.numberOfPages = (item?.reference.count)! - 1
//        //        image_PageControl.currentPageIndicatorTintColor = .white
//        //        image_PageControl.pageIndicatorTintColor = .systemGray
    }
}

extension MapDetailView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == image_ScrollView {
            //            print(image_ScrollView.contentOffset.x)
            image_PageControl.currentPage = Int(round(image_ScrollView.contentOffset.x / UIScreen.main.bounds.width))
        }
    }
}
