//
//  MapListViewCell.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/07/06.
//

import UIKit
import SnapKit
import RxSwift
import SDWebImage
import FirebaseStorageUI

class MapListViewCell1: UITableViewCell {
    
    // MARK: - Utils
    
    static var identifier: String {
        return String(describing: self)
    }
    
    // MARK: - UI Properties
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
//        view.layer.cornerRadius = 10
//        view.layer.shadowColor = UIColor.gray.cgColor
//        view.layer.shadowOpacity = 0.6
//        view.layer.shadowOffset = CGSize(width: 0, height: 5)
//        view.clipsToBounds = true
        return view
    }()
    
    lazy var thumbnailView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleToFill
        imgView.backgroundColor = .red
//        imgView.image = UIImage(named: "Register_View_Bg")
        return imgView
    }()
    
    lazy var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont(name: "LettersforLearners", size: 15)
        return lbl
    }()
    
    lazy var subTitleLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .systemGray6
        lbl.font = UIFont(name: "LettersforLearners", size: 13)
        return lbl
    }()
    
    lazy var bottom_StackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLbl, subTitleLbl, info_StackView])
        view.backgroundColor = .white
        view.axis = .vertical
        view.distribution = .fillProportionally
        view.alignment = .leading
        view.spacing = 5
        return view
    }()
    
    lazy var popular_Symbol_StackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [popular_Symbol, popular_Lbl])
        view.backgroundColor = .white
        view.distribution = .fillEqually
        view.spacing = 5
        view.axis = .horizontal
        return view
    }()
    
    lazy var popular_Symbol: UIImageView = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold)
        let systemImage = UIImage(systemName: "hand.thumbsup", withConfiguration: imageConfig)
        let imgView = UIImageView()
        imgView.backgroundColor = .white
        imgView.image = systemImage
        imgView.tintColor = .main_Color
        return imgView
    }()
    
    lazy var popular_Lbl: UILabel = {
        let lbl = UILabel()
        //        lbl.text = "4.7K"
        lbl.textColor = .black
        lbl.font = UIFont(name: "LettersforLearners", size: 15)
        return lbl
    }()
    
    lazy var distance_Symbol_StackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [distance_Symbol, distance_Lbl])
        view.backgroundColor = .white
        view.distribution = .fillEqually
        view.spacing = 5
        view.axis = .horizontal
        return view
    }()
    
    lazy var distance_Symbol: UIImageView = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold)
        let systemImage = UIImage(systemName: "arrow.triangle.branch", withConfiguration: imageConfig)
        let imgView = UIImageView()
        imgView.backgroundColor = .white
        imgView.image = systemImage
        imgView.tintColor = .main_Color
        return imgView
    }()
    
    lazy var distance_Lbl: UILabel = {
        let lbl = UILabel()
//        lbl.text = "0.5km"
        lbl.textColor = .black
        lbl.font = UIFont(name: "LettersforLearners", size: 15)
        return lbl
    }()
    
    lazy var time_Symbol_StackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [time_Symbol, time_Lbl])
        view.backgroundColor = .white
        view.distribution = .fillEqually
        view.spacing = 5
        view.axis = .horizontal
        return view
    }()
    
    lazy var time_Symbol: UIImageView = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold)
        let systemImage = UIImage(systemName: "clock", withConfiguration: imageConfig)
        let imgView = UIImageView()
        imgView.backgroundColor = .white
        imgView.image = systemImage
        imgView.tintColor = .main_Color
        return imgView
    }()
    
    lazy var time_Lbl: UILabel = {
        let lbl = UILabel()
//        lbl.text = "20m"
        lbl.textColor = .black
        lbl.font = UIFont(name: "LettersforLearners", size: 15)
        return lbl
    }()
    
    lazy var info_StackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [popular_Symbol_StackView, distance_Symbol_StackView, time_Symbol_StackView])
        view.backgroundColor = .white
        view.distribution = .fillEqually
        view.spacing = 20
        view.axis = .horizontal
        return view
    }()
    
    // MARK: - Properties
    
    var mapList: FinalMapList? = nil {
        didSet {
            configureCell()
        }
    }
    
    let disposeBag = DisposeBag()
    
    // MARK: - Initailize
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
        
    }
    
    override func layoutSubviews() {
      super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 21, bottom: 0, right: 21))
    }
    
    // MARK: - Configure UI
    
    private func configureUI() {
        
        contentView.layer.shadowRadius = 10
        contentView.layer.shadowColor = UIColor.gray.cgColor
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.masksToBounds = false
        contentView.layer.cornerRadius = 10
        
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true
        
        backgroundColor = .clear
//        contentView.backgroundColor = .yellow
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(contentView.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
//
        containerView.addSubview(thumbnailView)
        thumbnailView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.6)
        }
//
        containerView.addSubview(bottom_StackView)
        bottom_StackView.backgroundColor = .yellow
        bottom_StackView.snp.makeConstraints { make in
            make.top.equalTo(thumbnailView.safeAreaLayoutGuide.snp.bottom).offset(10)
            make.left.equalTo(containerView.safeAreaLayoutGuide.snp.left).offset(10)
            make.right.equalTo(containerView.safeAreaLayoutGuide.snp.right).offset(-10)
            make.bottom.equalTo(containerView.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
    }
    
    private func configureCell() {
        
        guard let finalMapList = mapList else { return }
        
//        guard let url = URL(string: mapList.imageUrls[1]) else { return }
//        let urlRequest = URLRequest(url: url!)
//
//        URLSession.shared.rx
//            .response(request: urlRequest)
//            .observe(on: MainScheduler.instance)
//            .subscribe(onNext: { [weak self] (_, data) in
//                print("data: \(data)")
//                self?.thumbnailView.image = UIImage(data: data)
//            }).disposed(by: disposeBag)
        
        let placeholderImage = UIImage(named: "waveform.circle")
        
        thumbnailView.sd_setImage(with: finalMapList.reference[1], placeholderImage: placeholderImage)
        
        titleLbl.text = finalMapList.mapList.title
        subTitleLbl.text = finalMapList.mapList.address
        popular_Lbl.text = finalMapList.mapList.popular.numberFormatter()
        distance_Lbl.text = "20km"
        time_Lbl.text = finalMapList.mapList.time + "m"
    }
    
}
