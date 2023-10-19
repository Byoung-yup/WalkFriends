//
//  LaunchViewController.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/10/05.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class LaunchViewController: UIViewController {
    
    // MARK: - Properties
    
    private let launchViewModel: LaunchViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Properties
    
    lazy var launch_ImageView: UIImageView = {
        let imageV = UIImageView()
        imageV.image = UIImage(named: "Launch_View_Bg")
        imageV.contentMode = .scaleAspectFit
        return imageV
    }()
    
    lazy var main_Launch_Lbl : UILabel = {
        let lbl = UILabel()
        lbl.text = "우리 곁의 워크프렌즈"
        lbl.textColor = .black
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    lazy var sub_Launch_Lbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "오늘 하루를\n 워크프렌즈와 함께하세요!"
        lbl.textColor = .black
        lbl.textAlignment = .center
        lbl.numberOfLines = 2
        lbl.font = UIFont.systemFont(ofSize: 18, weight: .light)
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    lazy var start_Btn: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .main_Color
        config.cornerStyle = .dynamic
        var titleAttr = AttributedString(stringLiteral: "시작하기")
        titleAttr.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        titleAttr.foregroundColor = .white
        config.attributedTitle = titleAttr
        
        let btn = UIButton(configuration: config)
        return btn
    }()
    
    
    // MARK: - Initialize
    
    init(launchViewModel: LaunchViewModel) {
        self.launchViewModel = launchViewModel
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
    }
    
    deinit {
        print("\(self.description) - deinit")
    }
    
    // MARK: - Configure UI
    
    private func configureUI() {
        
        view.addSubview(launch_ImageView)
        view.addSubview(main_Launch_Lbl)
        view.addSubview(sub_Launch_Lbl)
        view.addSubview(start_Btn)
        
        launch_ImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(14)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-14)
            make.height.equalTo(400)
        }
        
        main_Launch_Lbl.snp.makeConstraints { make in
            make.top.equalTo(launch_ImageView.safeAreaLayoutGuide.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        sub_Launch_Lbl.snp.makeConstraints { make in
            make.top.equalTo(main_Launch_Lbl.safeAreaLayoutGuide.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        start_Btn.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(14)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-14)
            make.height.equalTo(50)
        }
        
        drawBackground()
    }
    
    private func binding() {
        
        let input = LaunchViewModel.Input(location_Trigger: start_Btn.rx.tap.asObservable())
        let output = launchViewModel.transform(input: input)
        
        output.show_Location
            .debug()
            .asDriver(onErrorJustReturn: ())
            .drive()
            .disposed(by: disposeBag)
    }
}
