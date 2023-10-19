//
//  ResetViewController.swift
//  WalkFriends
//
//  Created by 김병엽 on 2023/10/02.
//


import UIKit
import SnapKit
import RxSwift

final class ResetViewController: UIViewController {
    
    // MARK: - Properties
    
    private let resetViewModel: ResetViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Properties
    
    let toBack_Btn = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: nil, action: nil)
    
    
    
    // MARK: - Init
    
    init(resetViewModel: ResetViewModel) {
        self.resetViewModel = resetViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(self.description) - deinit")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        drawBackground()
        configureUI()
        
        binding()
    }
    
    // MARK: - Configure UI
    
    private func configureUI() {
        
        setNaviBar()
        
//        view.addSubview(containerView)
//        containerView.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide)
//            make.left.right.equalTo(view)
//            make.height.equalTo(safeArea.top)
//        }
//
//        containerView.addSubview(toBack_Btn)
//        toBack_Btn.snp.makeConstraints { make in
//            make.top.equalTo(containerView.safeAreaLayoutGuide)
//            make.left.equalToSuperview().offset(14)
//        }
    }
    
    // MARK: NaviBar
    
    private func setNaviBar() {
        
        let naviBar = UINavigationBar(frame: CGRect(x: 0, y: safeArea.top, width: view.frame.width, height: safeArea.top))
        naviBar.shadowImage = UIImage()
        naviBar.setBackgroundImage(UIImage(), for: .default)
        naviBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        naviBar.tintColor = .black
        
        let naviItem = UINavigationItem(title: "비밀번호 찾기")
        naviItem.leftBarButtonItem = toBack_Btn
        naviBar.items = [naviItem]
        
        view.addSubview(naviBar)
    }
    
    // MARK: - Binding
    
    private func binding() {
        
        let input = ResetViewModel.Input(toBack_Trigger: toBack_Btn.rx.tap.asObservable())
        let output = resetViewModel.transform(input: input)
        
        output.toBack
            .subscribe()
            .disposed(by: disposeBag)
    }
}
