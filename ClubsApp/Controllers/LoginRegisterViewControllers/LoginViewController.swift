//
//  LoginViewController.swift
//  ClubsApp
//
//  Created by Ivan Kuzmenkov on 3.02.23.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {
    
    var isSignInSelected: Bool = true
    let leadingAndTrailingOffset: CGFloat = 16.0
    lazy var width = view.frame.size.width
    lazy var activeSubController: ViewControllerWithActiveTextFieldProtocol = subLoginViewController
    
    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    var signInOrUpStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        return stack
    }()
    
    var signInStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.isUserInteractionEnabled = true
        return stack
    }()
    
    var signUpStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.isUserInteractionEnabled = true
        return stack
    }()
    
    var signInLabel: UILabel = {
       let label = UILabel()
        label.text = "Вход"
        label.textAlignment = .center
        return label
    }()
    
    var signUpLabel: UILabel = {
       let label = UILabel()
        label.text = "Регистрация"
        label.textColor = .systemGray2
        label.textAlignment = .center
        return label
    }()
    
    var signInUnderscore: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    var signUpUnderscore: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    var signInContentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()
    
    lazy var subLoginViewController: SubLoginViewController = {
        let vc = SubLoginViewController()
        addChild(vc)
        vc.didMove(toParent: self)
        return vc
    }()
    
    lazy var subRegisterViewController: SubRegisterViewController = {
        let vc = SubRegisterViewController()
        addChild(vc)
        vc.didMove(toParent: self)
        return vc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        titleSettings()
        addSubViews()
        doLayout()
        addTargetToLabels()
        dismissKeyboardByTapOnView()
        addObserverForKeyboard()
    }
    
    
    private func titleSettings() {
        navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Добро пожаловать"
    }

    
    private func addSubViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(signInOrUpStackView)
        signInOrUpStackView.addArrangedSubview(signInStackView)
        signInOrUpStackView.addArrangedSubview(signUpStackView)
        signInStackView.addArrangedSubview(signInLabel)
        signInStackView.addArrangedSubview(signInUnderscore)
        signUpStackView.addArrangedSubview(signUpLabel)
        signUpStackView.addArrangedSubview(signUpUnderscore)
        scrollView.addSubview(subLoginViewController.view)
    }
    
    private func doLayout() {
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        signInOrUpStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(view.frame.height * 0.13)
            make.leading.equalToSuperview().offset(leadingAndTrailingOffset)
            make.trailing.equalToSuperview().offset(-leadingAndTrailingOffset)
        }
        
        signInLabel.snp.makeConstraints { make in
            make.width.equalTo((width / 2) - leadingAndTrailingOffset)
        }
        
        signInUnderscore.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo((width / 2) - leadingAndTrailingOffset)
        }
        
        signUpLabel.snp.makeConstraints { make in
            make.width.equalTo((width / 2) - leadingAndTrailingOffset)
        }
        
        signUpUnderscore.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo((width / 2) - leadingAndTrailingOffset)
        }
        
        subLoginViewController.view.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(leadingAndTrailingOffset)
            make.trailing.equalToSuperview().offset(-leadingAndTrailingOffset)
            make.top.equalTo(signInOrUpStackView.snp.bottom).offset(24)
            make.bottom.equalToSuperview()
        }
    }
    
    private func addTargetToLabels() {
        let gestureRecogn1 = UITapGestureRecognizer(target: self, action: #selector(switchSigninOrSignup(_:)))
        let gestureRecogn2 = UITapGestureRecognizer(target: self, action: #selector(switchSigninOrSignup(_:)))
        signInStackView.addGestureRecognizer(gestureRecogn1)
        signUpStackView.addGestureRecognizer(gestureRecogn2)
    }
    
    @objc private func switchSigninOrSignup (_ recognizer: UIGestureRecognizer) {
        recognizer.view == signInStackView ? (isSignInSelected = true) : (isSignInSelected = false)
        if isSignInSelected {
            removeController(controller: subRegisterViewController)
            addController(controller: subLoginViewController)
            UIView.animate(withDuration: 0.2) {[weak self] in
                guard let self else { return }
                self.signInUnderscore.backgroundColor = .black
                self.signUpUnderscore.backgroundColor = .clear
                self.signInLabel.textColor = .black
                self.signUpLabel.textColor = .systemGray2
            }
        } else {
            removeController(controller: subLoginViewController)
            addController(controller: subRegisterViewController)
            UIView.animate(withDuration: 0.2) {[weak self] in
                guard let self else { return }
                self.signInUnderscore.backgroundColor = .clear
                self.signUpUnderscore.backgroundColor = .black
                self.signInLabel.textColor = .systemGray2
                self.signUpLabel.textColor = .black
            }
        }
    }
    
    private func addObserverForKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeController(controller: UIViewController) {
        controller.willMove(toParent: nil)
        controller.view.removeFromSuperview()
        controller.removeFromParent()
    }
    
    private func addController(controller: UIViewController) {
        addChild(controller)
        guard let controllerWithSelectedActiveField = controller as? ViewControllerWithActiveTextFieldProtocol else { return }
        activeSubController = controllerWithSelectedActiveField
        UIView.transition(with: self.view, duration: 0.3, options: [.transitionCrossDissolve]) {[weak self] in
            guard let self else { return }
            self.scrollView.addSubview(controller.view)
        }
        controller.didMove(toParent: self)
        controller.view.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(leadingAndTrailingOffset)
            make.trailing.equalToSuperview().offset(-leadingAndTrailingOffset)
            make.top.equalTo(signInOrUpStackView.snp.bottom).offset(24)
            make.bottom.equalToSuperview()
        }
    }
    
    private func dismissKeyboardByTapOnView() {
        let gestureRecogn = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        self.view.addGestureRecognizer(gestureRecogn)
    }
}

extension LoginViewController {
    @objc private func keyBoardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else { return }
        guard let activeTextField = activeSubController.activeTextField else { return }
        let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: view).maxY
        let topOfKeyboard = view.frame.size.height - keyboardSize.height
        if bottomOfTextField > topOfKeyboard {
//            navigationController?.view.frame.origin.y = -keyboardSize.height
            UIView.animate(withDuration: 0.5) {[weak self] in
                guard let self else { return }
                self.navigationController?.view.frame.origin.y = topOfKeyboard - (bottomOfTextField + 10)
            }
        }
    }
    
    @objc private func keyBoardWillHide(notification: NSNotification) {
        navigationController?.view.frame.origin.y = 0
    }
}
