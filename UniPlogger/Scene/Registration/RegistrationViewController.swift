//
//  RegistrationViewController.swift
//  UniPlogger
//
//  Created by 손병근 on 2020/12/05.
//  Copyright (c) 2020 손병근. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol RegistrationDisplayLogic: class {
    func displayError(error: Common.CommonError, useCase: Registration.UseCase)
}

class RegistrationViewController: UIViewController, RegistrationDisplayLogic {
    var interactor: RegistrationBusinessLogic?
    var router: (NSObjectProtocol & RegistrationRoutingLogic & RegistrationDataPassing)?
    
    let accountFieldBox = UIView().then {
        $0.backgroundColor = .recordCellBackgroundColor
        $0.layer.cornerRadius = 24
        $0.layer.masksToBounds = true
    }
    
    let accountField = UITextField().then {
        $0.font = .notoSans(ofSize: 16, weight: .regular)
        $0.keyboardType = .emailAddress
        $0.backgroundColor = .clear
        $0.borderStyle = .none
        $0.placeholder = "아이디 (이메일)"
//        $0.addTarget(self, action: #selector(validateAccount), for: .editingChanged)
    }
    
    let passwordFieldBox = UIView().then {
        $0.backgroundColor = .recordCellBackgroundColor
        $0.layer.cornerRadius = 24
        $0.layer.masksToBounds = true
    }
    
    let passwordField = UITextField().then {
        $0.font = .notoSans(ofSize: 16, weight: .regular)
        $0.isSecureTextEntry = true
        $0.backgroundColor = .clear
        $0.borderStyle = .none
        $0.placeholder = "비밀번호"
//        $0.addTarget(self, action: #selector(validatePassword), for: .editingChanged)
    }
    
    let passwordInfoLabel = UILabel().then {
        $0.text = "8~20자 이내의 영문과 숫자 조합을 입력해주세요"
        $0.textColor = UIColor(named: "color_registrationPasswordInfoLabel")
        $0.font = .notoSans(ofSize: 14, weight: .regular)
    }
    
    let passwordConfirmFieldBox = UIView().then {
        $0.backgroundColor = .recordCellBackgroundColor
        $0.layer.cornerRadius = 24
        $0.layer.masksToBounds = true
    }
    
    let passwordConfirmField = UITextField().then {
        $0.font = .notoSans(ofSize: 16, weight: .regular)
        $0.isSecureTextEntry = true
        $0.backgroundColor = .clear
        $0.borderStyle = .none
        $0.placeholder = "비밀번호 재입력"
//        $0.addTarget(self, action: #selector(validatePassword), for: .editingChanged)
    }
    
    lazy var registrationButton = UIButton().then {
        $0.setTitle("회원가입 완료", for: .normal)
        $0.backgroundColor = UIColor(named: "color_registrationButton")
        $0.titleLabel?.font = .roboto(ofSize: 15, weight: .bold)
        $0.isEnabled = false
        $0.layer.cornerRadius = 26
        $0.layer.masksToBounds = true
//        $0.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = RegistrationInteractor()
        let presenter = RegistrationPresenter()
        let router = RegistrationRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        setupView()
        setupLayout()
    }
    
    func displayError(error: Common.CommonError, useCase: Registration.UseCase){
        //handle error with its usecase
    }
}
