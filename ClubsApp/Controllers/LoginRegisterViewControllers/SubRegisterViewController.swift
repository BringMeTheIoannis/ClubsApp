//
//  SubRegisterViewController.swift
//  ClubsApp
//
//  Created by Ivan Kuzmenkov on 6.02.23.
//

import UIKit
import FirebaseAuth

class SubRegisterViewController: UIViewController {
    
    let passRightViewWidth = 40
    let passRightViewHight = 40
    let passRightViewImageHeight = 24
    let passRightViewImageWidth = 24
    var isPassHide: Bool = true
    var isRepeatPassHide: Bool = true
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
    
    lazy var nicknameTextField: UITextField = {
        let textField = UITextField()
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.attributedPlaceholder = NSAttributedString(
            string: "Name or nickname",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray]
        )
        textField.leftView = leftViewForNicknameField
        textField.leftViewMode = .always
        textField.backgroundColor = .systemGray6
        textField.tintColor = .black
        textField.keyboardType = .alphabet
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
    
    lazy var repeatPassTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Повторите пароль",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray]
        )
        textField.leftView = leftViewRepeatPassField
        textField.rightView = rightViewForRepeatPassword
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
    
    var leftViewForNicknameField: UIView = {
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        return leftView
    }()
    
    var leftViewRepeatPassField: UIView = {
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        return leftView
    }()
    
    lazy var rightViewForPassword: UIView = {
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: passRightViewWidth, height: passRightViewHight))
        rightView.addSubview(passRightViewImageView)
        return rightView
    }()
    
    lazy var rightViewForRepeatPassword: UIView = {
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: passRightViewWidth, height: passRightViewHight))
        rightView.addSubview(repeatPassRightViewImageView)
        return rightView
    }()
    
    lazy var passRightViewImageView: UIImageView = {
        let rightImageView = UIImageView(frame: CGRect(x: 0, y: (passRightViewHight - passRightViewImageHeight) / 2, width: passRightViewImageWidth, height: passRightViewImageHeight))
        rightImageView.image = UIImage(named: "hidePassImage")
        return rightImageView
    }()
    
    lazy var repeatPassRightViewImageView: UIImageView = {
        let rightImageView = UIImageView(frame: CGRect(x: 0, y: (passRightViewHight - passRightViewImageHeight) / 2, width: passRightViewImageWidth, height: passRightViewImageHeight))
        rightImageView.image = UIImage(named: "hidePassImage")
        return rightImageView
    }()
    
    lazy var registerButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 127/255, green: 5/255, blue: 249/255, alpha: 1.0)
        button.tintColor = .white
        button.setTitle("Создать аккаунт", for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(createUser), for: .touchUpInside)
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
    }
    
    private func controllerAppearanceSetup() {
        view.backgroundColor = .white
    }
    
    private func setDelegates() {
        emailTextField.delegate = self
        nicknameTextField.delegate = self
        passTextField.delegate = self
        repeatPassTextField.delegate = self
    }
    
    private func addSubViews() {
        view.addSubview(emailTextField)
        view.addSubview(nicknameTextField)
        view.addSubview(passTextField)
        view.addSubview(repeatPassTextField)
        view.addSubview(errorLabel)
        view.addSubview(registerButton)
        view.addSubview(privacyLabelTop)
        view.addSubview(privacyLabelBottom)
        registerButton.addSubview(activityIndicator)
    }
    
    private func doLayout() {
        
        emailTextField.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(50)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(emailTextField.snp.bottom).offset(16)
            make.height.equalTo(50)
        }
        
        passTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(nicknameTextField.snp.bottom).offset(16)
            make.height.equalTo(50)
        }
        
        repeatPassTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(passTextField.snp.bottom).offset(16)
            make.height.equalTo(50)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(repeatPassTextField.snp.bottom).offset(8)
            make.height.equalTo(32)
        }
        
        registerButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(errorLabel.snp.bottom).offset(8)
            make.height.equalTo(52)
        }
        
        privacyLabelTop.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(registerButton.snp.bottom).offset(16)
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
    
    private func addTargetToPassRightView() {
        let gestureForPass = UITapGestureRecognizer(target: self, action: #selector(showHidePass))
        let gestureForPassRepeat = UITapGestureRecognizer(target: self, action: #selector(showHidePass))
        rightViewForPassword.isUserInteractionEnabled = true
        rightViewForRepeatPassword.isUserInteractionEnabled = true
        rightViewForPassword.addGestureRecognizer(gestureForPass)
        rightViewForRepeatPassword.addGestureRecognizer(gestureForPassRepeat)
    }
    
    @objc private func showHidePass(_ sender: UITapGestureRecognizer) {
        if sender.view == rightViewForPassword {
            showHidePassAction(isHide: &isPassHide, rightImageView: passRightViewImageView, textField: passTextField)
        } else if sender.view == rightViewForRepeatPassword {
            showHidePassAction(isHide: &isRepeatPassHide, rightImageView: repeatPassRightViewImageView, textField: repeatPassTextField)
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
    
    @objc private func createUser() {
        let password = passTextField.text.unwrapped
        let email = emailTextField.text.unwrapped
        let nickname = nicknameTextField.text.unwrapped
        if password.isEmpty || email.isEmpty || nickname.isEmpty {
            addErrorTextWithAnimation(errorText: "Email, пароль или nickname не могут быть пустыми")
            return
        }
        if passTextField.text != repeatPassTextField.text {
            addErrorTextWithAnimation(errorText: "Ошибка: пароли не одинаковы")
            return
        }
        createFirebaseUser(email: email, password: password)
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
    
    private func createFirebaseUser(email: String, password: String) {
        isRegistrationInProgress = true
        auth.registerUser(email: email, password: password) {[weak self] result in
            guard let self else { return }
            self.isRegistrationInProgress = false
            SceneDelegateEnvironment.sceneDelegate?.setMainAsInitial()
        } failure: {[weak self] error in
            guard let self else { return }
            self.isRegistrationInProgress = false
            self.addErrorTextWithAnimation(errorText: error?.localizedDescription)
        }
    }
    
    private func showLoadingInsideButton() {
        if isRegistrationInProgress {
            registerButton.isEnabled = false
            registerButton.titleLabel?.alpha = 0.0
            activityIndicator.alpha = 1.0
            activityIndicator.startAnimating()
        } else {
            registerButton.isEnabled = true
            activityIndicator.alpha = 0.0
            registerButton.titleLabel?.alpha = 1.0
            activityIndicator.stopAnimating()
        }
    }
}

extension SubRegisterViewController: UITextFieldDelegate {
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
