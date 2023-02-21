//
//  CreateEventViewController.swift
//  ClubsApp
//
//  Created by Ivan Kuzmenkov on 13.02.23.
//

import UIKit
import SnapKit

class CreateEventViewController: UIViewController {
        
    var topColorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.94, green: 0.91, blue: 0.971, alpha: 1)
        return view
    }()
    
    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Название",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray,
                         NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)
                        ]
        )
        textField.borderStyle = .none
        textField.leftViewMode = .always
        textField.tintColor = .black
        textField.autocapitalizationType = .none
        textField.returnKeyType = .done
        textField.layer.cornerRadius = 8
        return textField
    }()
    
    var bottomBorderForTitleLabel: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        return view
    }()
    
    var dateTimeVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    var topViewForDateTimeStackView: UIView = {
        let view = UIView()
        return view
    }()
    
    var bottomViewForDateAndTimeStackView: UIView = {
        let view = UIView()
        return view
    }()
    
    var labelForTopViewForDateTime: UILabel = {
        let label = UILabel()
        label.text = "Выбрать дату и время"
        return label
    }()
    
    var arrowForTopViewForDateTimeView: UIImageView = {
        let image = UIImage(systemName: "chevron.right")
        let imageView = UIImageView(image: image)
        imageView.tintColor = .black
        return imageView
    }()
    
    var calendarPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .inline
        picker.tintColor = UIColor(red: 0.498, green: 0.02, blue: 0.976, alpha: 1.0)
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controllerSetup()
        addSubviews()
        doLayout()
    }
    
    private func controllerSetup() {
        view.backgroundColor = .white
        title = "Создать"
    }
    
    private func addSubviews() {
        view.addSubview(topColorView)
        view.addSubview(scrollView)
        scrollView.addSubview(titleTextField)
        titleTextField.addSubview(bottomBorderForTitleLabel)
        scrollView.addSubview(dateTimeVerticalStackView)
        addViewsToDateTimeStack()
    }
    
    private func doLayout() {
        topColorView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
        }

        scrollView.snp.makeConstraints { make in
            make.leading.trailing.bottom.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.top.equalToSuperview().offset(32)
            make.height.equalTo(30)
        }
        
        bottomBorderForTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(titleTextField.snp.bottom).offset(3)
            make.height.equalTo(0.5)
        }
        
        dateTimeVerticalStackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(bottomBorderForTitleLabel).inset(16)
        }
        
        topViewForDateTimeStackView.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        
        bottomViewForDateAndTimeStackView.snp.makeConstraints { make in
            make.height.equalTo(500)
        }
        
        labelForTopViewForDateTime.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().inset(30)
            make.centerY.equalToSuperview()
        }
        
        arrowForTopViewForDateTimeView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(13)
            make.height.equalTo(24)
        }
        
        calendarPicker.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
    }
    
    private func addViewsToDateTimeStack() {
        dateTimeVerticalStackView.addArrangedSubview(topViewForDateTimeStackView)
        dateTimeVerticalStackView.addArrangedSubview(bottomViewForDateAndTimeStackView)
        topViewForDateTimeStackView.addSubview(labelForTopViewForDateTime)
        topViewForDateTimeStackView.addSubview(arrowForTopViewForDateTimeView)
        bottomViewForDateAndTimeStackView.addSubview(calendarPicker)
    }
}
