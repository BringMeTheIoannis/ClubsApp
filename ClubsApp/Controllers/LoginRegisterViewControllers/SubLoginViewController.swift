//
//  SubLoginViewController.swift
//  ClubsApp
//
//  Created by Ivan Kuzmenkov on 5.02.23.
//

import UIKit
import SnapKit

class SubLoginViewController: UIViewController, ViewControllerWithActiveTextFieldProtocol {
    
    let passRightViewWidth = 40
    let passRightViewHight = 40
    let passRightViewImageHeight = 24
    let passRightViewImageWidth = 24
    var isPassHide: Bool = true
    var isRegistrationInProgress: Bool = false {
        didSet {
            showLoadingInsideButton()
        }
    }
    var auth: UserAuth = UserAuth()
    var activeTextField: UITextField?
    
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray]
        )
        textField.leftView = leftViewForEmailField
        textField.leftViewMode = .always
        textField.backgroundColor = .systemGray6
        textField.tintColor = .black
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.returnKeyType = .done
        textField.layer.cornerRadius = 8
        return textField
    }()

    lazy var passTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Пароль",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray]
        )
        textField.leftView = leftViewForPassField
        textField.rightView = rightViewForPassword
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        textField.backgroundColor = .systemGray6
        textField.tintColor = .black
        textField.isSecureTextEntry = true
        textField.returnKeyType = .done
        textField.layer.cornerRadius = 8
        return textField
    }()
    
    var leftViewForPassField: UIView = {
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        return leftView
    }()
    
    var leftViewForEmailField: UIView = {
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        return leftView
    }()
    
    lazy var rightViewForPassword: UIView = {
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: passRightViewWidth, height: passRightViewHight))
        rightView.addSubview(passRightViewImageView)
        return rightView
    }()
    
    lazy var passRightViewImageView: UIImageView = {
        let rightImageView = UIImageView(frame: CGRect(x: 0, y: (passRightViewHight - passRightViewImageHeight) / 2, width: passRightViewImageWidth, height: passRightViewImageHeight))
        rightImageView.image = UIImage(named: "hidePassImage")
        return rightImageView
    }()
    
    var forgetPassLabel: UILabel = {
        let label = UILabel()
        label.text = "Забыли пароль?"
        label.textColor = .systemGray3
        label.textAlignment = .right
        label.font = label.font.withSize(13)
        return label
    }()
    
    lazy var signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 127/255, green: 5/255, blue: 249/255, alpha: 1.0)
        button.tintColor = .white
        button.setTitle("Войти", for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        return button
    }()
    
    var privacyLabelTop: UILabel = {
        var label = UILabel()
        label.text = "Нажимая кнопку «Войти», вы принимаете условия"
        label.numberOfLines = 2
        label.font = label.font.withSize(13)
        label.textAlignment = .center
        label.textColor = .systemGray2
        return label
    }()
    
    var privacyLabelBottom: UILabel = {
        var label = UILabel()
        label.text = "Политики конфиденциальности"
        label.font = label.font.withSize(13)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    var errorLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(13)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .systemRed
        return label
    }()
    
    var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = .white
        indicator.hidesWhenStopped = true
        indicator.alpha = 0.0
        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        controllerAppearanceSetup()
        addSubViews()
        doLayout()
        setDelegates()
        addTargetToPassRightView()
        addTargetToForgotPass()
    }
    
    private func controllerAppearanceSetup() {
        view.backgroundColor = .white
    }
    
    private func setDelegates() {
        emailTextField.delegate = self
        passTextField.delegate = self
    }
    
    private func addSubViews() {
        view.addSubview(emailTextField)
        view.addSubview(passTextField)
        view.addSubview(forgetPassLabel)
        view.addSubview(errorLabel)
        view.addSubview(signInButton)
        view.addSubview(privacyLabelTop)
        view.addSubview(privacyLabelBottom)
        signInButton.addSubview(activityIndicator)
    }
    
    private func doLayout() {
        emailTextField.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(50)
        }
        
        passTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(emailTextField.snp.bottom).offset(16)
            make.height.equalTo(50)
        }
        
        forgetPassLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(passTextField.snp.bottom).offset(8)
            make.height.equalTo(16)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(forgetPassLabel.snp.bottom).offset(4)
            make.height.equalTo(32)
        }
        
        signInButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(errorLabel.snp.bottom).offset(8)
            make.height.equalTo(52)
        }
        
        privacyLabelTop.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(signInButton.snp.bottom).offset(16)
            make.height.equalTo(16)
        }
        
        privacyLabelBottom.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(privacyLabelTop.snp.bottom)
            make.height.equalTo(16)
            make.bottom.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    private func addTargetToForgotPass() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(pushToForgetPassScreen))
        forgetPassLabel.isUserInteractionEnabled = true
        forgetPassLabel.addGestureRecognizer(gesture)
    }
    
    @objc private func pushToForgetPassScreen() {
        let vc = ResetPassViewController()
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.prefersLargeTitles = true
        self.present(navController, animated: true)
    }
    
    private func addTargetToPassRightView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(showHidePass))
        rightViewForPassword.isUserInteractionEnabled = true
        rightViewForPassword.addGestureRecognizer(gesture)
    }
    
    @objc private func showHidePass(_ sender: UITapGestureRecognizer) {
        if sender.view == rightViewForPassword {
            showHidePassAction(isHide: &isPassHide, rightImageView: passRightViewImageView, textField: passTextField)
        }
    }
    
    private func showHidePassAction(isHide: inout Bool, rightImageView: UIImageView, textField: UITextField) {
        isHide.toggle()
        if isHide {
            rightImageView.alpha = 0.0
            textField.isSecureTextEntry = true
            rightImageView.image = UIImage(named: "hidePassImage")
            UIView.animate(withDuration: 0.5) {
                rightImageView.alpha = 1.0
            }
        } else {
            rightImageView.alpha = 0.0
            textField.isSecureTextEntry = false
            rightImageView.image = UIImage(systemName: "eye.slash")
            rightImageView.tintColor = .systemGray
            rightImageView.contentMode = .scaleAspectFit
            UIView.animate(withDuration: 0.5) {
                rightImageView.alpha = 1.0
            }
        }
    }
    
    @objc private func signIn() {
        let password = passTextField.text.unwrapped
        let email = emailTextField.text.unwrapped
        if password.isEmpty || email.isEmpty {
            addErrorTextWithAnimation(errorText: "Email и пароль не могут быть пустыми")
            return
        }
        loginUser(email: email, password: password)
    }
    
    private func loginUser(email: String, password: String) {
        isRegistrationInProgress = true
        auth.signIn(email: email, password: password) {[weak self] result in
            guard let self else { return }
            self.isRegistrationInProgress = false
            SceneDelegateEnvironment.sceneDelegate?.setMainAsInitial()
        } failure: {[weak self] error in
            guard let self else { return }
            self.isRegistrationInProgress = false
            self.addErrorTextWithAnimation(errorText: error?.localizedDescription)
        }
    }
    
    private func addErrorTextWithAnimation(errorText: String?) {
        UIView.transition(with: errorLabel, duration: 0.3, options: [.transitionCrossDissolve]) {[weak self] in
            guard let self else { return }
            self.errorLabel.text = errorText
        }
        errorAlertAnimation(on: errorLabel)
    }
    
    private func errorAlertAnimation(on view: UIView) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: view.center.x - 10, y: view.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: view.center.x + 10, y: view.center.y))
        view.layer.add(animation, forKey: "position")
    }
    
    private func showLoadingInsideButton() {
        if isRegistrationInProgress {
            signInButton.isEnabled = false
            signInButton.titleLabel?.alpha = 0.0
            activityIndicator.alpha = 1.0
            activityIndicator.startAnimating()
        } else {
            signInButton.isEnabled = true
            activityIndicator.alpha = 0.0
            signInButton.titleLabel?.alpha = 1.0
            activityIndicator.stopAnimating()
        }
    }
}

extension SubLoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
        UIView.animate(withDuration: 0.6) {
            textField.backgroundColor = .white
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor.systemGray2.cgColor
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        self.activeTextField = nil
        UIView.animate(withDuration: 0.6) {
            textField.backgroundColor = .systemGray6
            textField.layer.borderWidth = 0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.activeTextField = nil
        return textField.resignFirstResponder()
    }
}

//    TODO: addDoneButtonToKeyboard to viewDidLoad if needed
extension SubLoginViewController {
    private func addDoneButtonToKeyboard() {
            let doneToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
            doneToolBar.barStyle = .default
            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let doneToolBarItem = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(doneKeyboardButton))
            doneToolBar.items = [flexSpace, doneToolBarItem]
            doneToolBar.sizeToFit()
            emailTextField.inputAccessoryView = doneToolBar
            passTextField.inputAccessoryView = doneToolBar
        }
    
        @objc private func doneKeyboardButton() {
            view.endEditing(true)
        }
}
