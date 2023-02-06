//
//  SubLoginViewController.swift
//  ClubsApp
//
//  Created by Ivan Kuzmenkov on 5.02.23.
//

import UIKit
import SnapKit

class SubLoginViewController: UIViewController {
    
    let passRightViewWidth = 40
    let passRightViewHight = 40
    let passRightViewImageHeight = 24
    let passRightViewImageWidth = 24
    var isPassHide: Bool = true
    
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.attributedPlaceholder = NSAttributedString(
            string: "howareyou@good.com",
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
        textField.keyboardType = .emailAddress
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
    
    var signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 127/255, green: 5/255, blue: 249/255, alpha: 1.0)
        button.tintColor = .white
        button.setTitle("Войти", for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewAppearanceSetup()
        addSubViews()
        doLayout()
        setDelegates()
        addTargetToPassRightView()
    }
    
    private func viewAppearanceSetup() {
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
        view.addSubview(signInButton)
    }
    
    private func doLayout() {
        
        emailTextField.snp.makeConstraints { make in
            // TODO: добавить top к superview!
            make.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
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
        }
        
        signInButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(forgetPassLabel.snp.bottom).offset(28)
            make.height.equalTo(52)
        }
        
    }
    
    private func addTargetToPassRightView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(showHidePass))
        rightViewForPassword.isUserInteractionEnabled = true
        rightViewForPassword.addGestureRecognizer(gesture)
    }
    
    @objc private func showHidePass () {
        isPassHide.toggle()
        if isPassHide {
            self.passRightViewImageView.alpha = 0.0
            passTextField.isSecureTextEntry = true
            self.passRightViewImageView.image = UIImage(named: "hidePassImage")
            UIView.animate(withDuration: 0.5) {
                self.passRightViewImageView.alpha = 1.0
            }
            
        } else {
            passTextField.isSecureTextEntry = false
            self.passRightViewImageView.alpha = 0.0
            self.passRightViewImageView.image = UIImage(systemName: "eye.slash")
            self.passRightViewImageView.tintColor = .systemGray
            passRightViewImageView.contentMode = .scaleAspectFit
            UIView.animate(withDuration: 0.5) {
                self.passRightViewImageView.alpha = 1.0
            }
        }
    }
}

extension SubLoginViewController: UITextFieldDelegate {
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
