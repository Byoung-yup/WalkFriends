//
//  Location.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/10/07.
//

import Foundation
import UIKit
import SnapKit

class Location: UIViewController {
    
    lazy var bg_View: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .black.withAlphaComponent(0.5)
        btn.alpha = 0
        btn.addTarget(self, action: #selector(hide), for: .touchUpInside)
        return btn
    }()
    
    lazy var container_View: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var main_StackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [main_Info_Lbl, sub_Info_Lbl, sub_StackView])
        view.backgroundColor = .white
        view.spacing = 10
        view.axis = .vertical
        view.distribution = .fill
        view.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        view.isLayoutMarginsRelativeArrangement = true
        view.alpha = 0
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var sub_StackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [cancel_Btn, set_Btn])
        view.backgroundColor = .white
        view.spacing = 10
        view.axis = .horizontal
        view.distribution = .fillEqually
        return view
    }()
    
    lazy var main_Info_Lbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "위치 정보 사용 설정"
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.backgroundColor = .clear
        return lbl
    }()
    
    lazy var sub_Info_Lbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "내 위치 확인을 위해 설정에서 위치 정보 사용을 허용해주세요."
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .light)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.numberOfLines = 2
        lbl.backgroundColor = .clear
        return lbl
    }()
    
    lazy var cancel_Btn: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .white
        config.cornerStyle = .dynamic
        var titleAttr = AttributedString(stringLiteral: "취소")
        titleAttr.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        titleAttr.foregroundColor = .main_Color
        config.attributedTitle = titleAttr
        
        let btn = UIButton(configuration: config)
        btn.addTarget(self, action: #selector(hide), for: .touchUpInside)
        return btn
    }()
    
    lazy var set_Btn: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .main_Color
        config.cornerStyle = .dynamic
        var titleAttr = AttributedString(stringLiteral: "설정하기")
        titleAttr.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        titleAttr.foregroundColor = .white
        config.attributedTitle = titleAttr
        
        let btn = UIButton(configuration: config)
        btn.addTarget(self, action: #selector(set), for: .touchUpInside)
        return btn
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    deinit {
        print("\(self.description) - deinit")
    }
    
    private func configureUI() {
        
        view.addSubview(bg_View)
        bg_View.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bg_View.addSubview(main_StackView)
        main_StackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalTo(bg_View.safeAreaLayoutGuide.snp.left).offset(50)
            make.right.equalTo(bg_View.safeAreaLayoutGuide.snp.right).offset(-50)
        }
        
        sub_StackView.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
    }
    
    func appear(sender: UIViewController) {
        sender.present(self, animated: false)
        show()
    }
    
    private func show() {
        
        UIView.animate(withDuration: 0.5, delay: 0.1) {
            self.bg_View.alpha = 1
            self.main_StackView.alpha = 1
        }
    }
    
    @objc func hide() {
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
            self.bg_View.alpha = 0
            self.main_StackView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
//            self.removeFromParent()
        }
    }
    
    @objc func set() {
        if let appSetting = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(appSetting)
            self.dismiss(animated: false)
        }
    }
}
