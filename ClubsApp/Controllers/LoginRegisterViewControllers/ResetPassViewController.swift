//
//  ResetPassViewController.swift
//  ClubsApp
//
//  Created by Ivan Kuzmenkov on 9.02.23.
//

import UIKit

class ResetPassViewController: UIViewController {
    
    let sidesInset: Double = 16
    var auth: UserAuth = UserAuth()
    var isRegistrationInProgress: Bool = false {
        didSet {
            showLoadingInsideButton()
        }
    }
    
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
        textField.returnKeyType = .done
        textField.layer.cornerRadius = 8
        return textField
    }()
    
    var leftViewForEmailField: UIView = {
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        return leftView
    }()
    
    lazy var resetPassButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 127/255, green: 5/255, blue: 249/255, alpha: 1.0)
        button.tintColor = .white
        button.setTitle("Сбросить пароль", for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(resetPassAction), for: .touchUpInside)
        return button
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
    
    lazy var doneNavBarButton: UIButton = {
        let button = UIButton()
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(UIColor(red: 127/255, green: 5/255, blue: 249/255, alpha: 1.0), for: .normal)
        button.addTarget(self, action: #selector(dismissScreen), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        controllerAppearanceSetup()
        addSubViews()
        doLayout()
        setDelegates()
        dismissKeyboardByTapOnView()
        addDoneButtonToNavBar()
    }
    
    private func controllerAppearanceSetup() {
        view.backgroundColor = .white
        navigationItem.title = "Сброс пароля"
    }
    
    private func setDelegates() {
        emailTextField.delegate = self
    }
    
    private func addSubViews() {
        view.addSubview(emailTextField)
        view.addSubview(resetPassButton)
        view.addSubview(errorLabel)
        resetPassButton.addSubview(activityIndicator)
    }
    
    private func doLayout() {
        emailTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(sidesInset)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(163)
            make.height.equalTo(50)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(sidesInset)
            make.top.equalTo(emailTextField.snp.bottom).offset(4)
            make.height.equalTo(32)
        }
        
        resetPassButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(sidesInset)
            make.top.equalTo(errorLabel.snp.bottom).offset(4)
            make.height.equalTo(50)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    private func addDoneButtonToNavBar() {
        let barItem = UIBarButtonItem(customView: doneNavBarButton)
        navigationItem.rightBarButtonItems = [barItem]
    }
    
    @objc private func dismissScreen() {
        self.dismiss(animated: true)
    }
    
    private func dismissKeyboardByTapOnView() {
        let gestureRecogn = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        self.view.addGestureRecognizer(gestureRecogn)
    }
    
    @objc private func resetPassAction() {
        let email = emailTextField.text.unwrapped
        if email.isEmpty {
            addResultTextWithAnimation(errorText: "Email не может быть пустым")
            return
        }
        resetPassword(email: email)
    }
    
    private func resetPassword(email: String) {
        isRegistrationInProgress = true
        auth.resetPassword(email: email) { successString in
            self.isRegistrationInProgress = false
            self.errorLabel.textColor = .systemGreen
            self.errorLabel.text = successString
            self.addResultTextWithAnimation(errorText: successString)
            self.emailTextField.text = ""
        } failure: { error in
            self.isRegistrationInProgress = false
            self.addResultTextWithAnimation(errorText: error.localizedDescription)
        }
    }
    
    private func addResultTextWithAnimation(errorText: String?) {
        UIView.transition(with: errorLabel, duration: 0.3, options: [.transitionCrossDissolve]) {
            self.errorLabel.text = errorText
        }
        alertAnimation(on: errorLabel)
    }
    
    private func alertAnimation(on view: UIView) {
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
            resetPassButton.isEnabled = false
            resetPassButton.titleLabel?.alpha = 0.0
            activityIndicator.alpha = 1.0
            activityIndicator.startAnimating()
        } else {
            resetPassButton.isEnabled = true
            activityIndicator.alpha = 0.0
            resetPassButton.titleLabel?.alpha = 1.0
            activityIndicator.stopAnimating()
        }
    }
}

extension ResetPassViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.6) {
            textField.backgroundColor = .white
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor.systemGray2.cgColor
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        UIView.animate(withDuration: 0.6) {
            textField.backgroundColor = .systemGray6
            textField.layer.borderWidth = 0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
