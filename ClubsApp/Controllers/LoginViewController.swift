//
//  LoginViewController.swift
//  ClubsApp
//
//  Created by Ivan Kuzmenkov on 3.02.23.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {
    
    
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
    
    var signInEmailTextField: UITextField = {
        let textField = UITextField()
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.attributedPlaceholder = NSAttributedString(
            string: "howareyou@good.com",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray]
        )
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.backgroundColor = .systemGray6
        textField.tintColor = .black
        textField.layer.cornerRadius = 8

        return textField
    }()
    
    var isSignInSelected: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        titleSettings()
        addSubViews()
        doLayout()
        addTargetToLabels()
        setDelegates()
    }
    
    
    private func titleSettings() {
        navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Добро пожаловать"
    }
    
    private func setDelegates() {
        signInEmailTextField.delegate = self
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
        //signInContents addSubview
        scrollView.addSubview(signInContentStackView)
        signInContentStackView.addArrangedSubview(signInEmailTextField)
    }
    
    private func doLayout() {
        let leadingAndTrailingOffset: CGFloat = 16.0
        let width = view.frame.size.width
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        signInOrUpStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(120)
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
        
        signInContentStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(leadingAndTrailingOffset)
            make.trailing.equalToSuperview().offset(-leadingAndTrailingOffset)
            make.top.equalTo(signInOrUpStackView.snp.bottom).offset(24)
        }
        
        signInEmailTextField.snp.makeConstraints { make in
            make.width.equalTo(width - (leadingAndTrailingOffset * 2))
            make.height.equalTo(50)
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
            UIView.animate(withDuration: 0.2) {
                self.signInUnderscore.backgroundColor = .black
                self.signUpUnderscore.backgroundColor = .clear
                self.signInLabel.textColor = .black
                self.signUpLabel.textColor = .systemGray2
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.signInUnderscore.backgroundColor = .clear
                self.signUpUnderscore.backgroundColor = .black
                self.signInLabel.textColor = .systemGray2
                self.signUpLabel.textColor = .black
            }
            
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 1.0) {
            textField.backgroundColor = .white
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor.systemGray2.cgColor
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        UIView.animate(withDuration: 1.0) {
            textField.backgroundColor = .systemGray6
            textField.layer.borderWidth = 0
        }
    }
}
