//
//  SubLoginViewController.swift
//  ClubsApp
//
//  Created by Ivan Kuzmenkov on 5.02.23.
//

import UIKit
import SnapKit

class SubLoginViewController: UIViewController {
    
    var emailTextField: UITextField = {
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
        textField.keyboardType = .emailAddress
        textField.returnKeyType = .done
        textField.layer.cornerRadius = 8
        return textField
    }()
    
    var passTextField: UITextField = {
        let rightViewWidth = 40
        let rightViewHight = 40
        let imageHeight = 24
        let imageWidth = 24
        let textField = UITextField()
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: rightViewWidth, height: rightViewHight))
        let rightViewImage = UIImageView(frame: CGRect(x: 0, y: (rightViewHight - imageHeight) / 2, width: imageWidth, height: imageHeight))
        rightViewImage.image = UIImage(named: "hidePassImage")
        textField.attributedPlaceholder = NSAttributedString(
            string: "Пароль",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray]
        )
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.rightView = rightView
        textField.rightView?.addSubview(rightViewImage)
        textField.rightViewMode = .always
        textField.backgroundColor = .systemGray6
        textField.tintColor = .black
        textField.keyboardType = .emailAddress
        textField.returnKeyType = .done
        textField.layer.cornerRadius = 8
        return textField
    }()
    
    var forgetPassLabel: UILabel = {
       let label = UILabel()
        return label
    }()
    
    var mainVerticalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.isUserInteractionEnabled = true
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewAppearanceSetup()
        addSubViews()
        doLayout()
        setDelegates()
    }
    
    private func viewAppearanceSetup() {
        view.backgroundColor = .white
    }
    
    private func setDelegates() {
        emailTextField.delegate = self
        passTextField.delegate = self
    }
    
    private func addSubViews() {
        view.addSubview(mainVerticalStackView)
        mainVerticalStackView.addArrangedSubview(emailTextField)
        mainVerticalStackView.addArrangedSubview(passTextField)
    }
    
    private func doLayout() {
        mainVerticalStackView.snp.makeConstraints { make in
            // TODO: добавить top к superview!
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(50)
        }
        
        passTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(emailTextField.snp.bottom).offset(16)
            make.height.equalTo(50)
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
