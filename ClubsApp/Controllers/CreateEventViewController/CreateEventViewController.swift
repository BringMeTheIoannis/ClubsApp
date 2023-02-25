//
//  CreateEventViewController.swift
//  ClubsApp
//
//  Created by Ivan Kuzmenkov on 13.02.23.
//

import UIKit
import SnapKit

class CreateEventViewController: UIViewController {
    
    var addedUsers = [String]()
    lazy var navBar: UINavigationBar? = self.navigationController?.navigationBar
    
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
    
    lazy var placeTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Введите адрес/название места",
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
    
    lazy var aboutTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Описание",
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
    
    var bottomBorderForDateTimeTopView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        return view
    }()
    
    var bottomBorderForPlacesView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        return view
    }()
    
    var bottomBorderForAboutView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        return view
    }()
    
    var bottomBorderForAddUsersView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        return view
    }()
    
    var dateTimeContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    var dateTimeVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    lazy var topViewForDateTimeStackView: UIView = {
        let view = UIView()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(showHideDateTimePicker))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(gesture)
        return view
    }()
    
    lazy var addUsersView: UIView = {
        let view = UIView()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(goToAddUsersVC))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(gesture)
        return view
    }()
    
    var bottomViewForDateAndTimeStackView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.isHidden = true
        return view
    }()
    
    var labelForTopViewForDateTime: UILabel = {
        let label = UILabel()
        label.text = "Выберите дату и время"
        return label
    }()
    
    var labelForAddUsersView: UILabel = {
        let label = UILabel()
        label.text = "Добавьте участников"
        return label
    }()
    
    var arrowForTopViewForDateTimeView: UIImageView = {
        let image = UIImage(systemName: "chevron.down")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(red: 0.498, green: 0.02, blue: 0.976, alpha: 1)
        return imageView
    }()
    
    lazy var plusAddUserImageView: UIImageView = {
        let image = UIImage(systemName: "chevron.right")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(red: 0.498, green: 0.02, blue: 0.976, alpha: 1)
        return imageView
    }()
    
    lazy var calendarPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.locale = .current
        picker.preferredDatePickerStyle = .inline
        picker.minimumDate = Date.now
        picker.tintColor = UIColor(red: 0.498, green: 0.02, blue: 0.976, alpha: 1.0)
        picker.addTarget(self, action: #selector(changeLabelAfterCalendarChanged), for: .valueChanged)
        return picker
    }()
    
    lazy var timePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.locale = .current
        picker.preferredDatePickerStyle = .inline
        picker.locale = Locale(identifier: "be_BY")
        picker.tintColor = UIColor(red: 0.498, green: 0.02, blue: 0.976, alpha: 1.0)
        picker.addTarget(self, action: #selector(changeLabelAfterCalendarChanged), for: .valueChanged)
        return picker
    }()
    
    var viewForTimePickerAndButton: UIView = {
        let view = UIView()
        return view
    }()
    
    var timeLabelForTimeView: UILabel = {
        let label = UILabel()
        label.text = "Время"
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        return label
    }()
    
    lazy var doneButtonForDateTime: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(showHideDateTimePicker), for: .touchUpInside)
        button.backgroundColor = UIColor(red: 0.498, green: 0.02, blue: 0.976, alpha: 1.0)
        button.tintColor = .white
        button.layer.cornerRadius = 4
        button.setTitle("Готово", for: .normal)
        return button
    }()
    
    var insideStackViewForDatePickerAndTimePicker: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    lazy var closeControllerImageView: UIImageView = {
        let image = UIImage(systemName: "xmark")
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(closeController))
        let imageView = UIImageView(image: image)
        imageView.tintColor = .black
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(recognizer)
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controllerSetup()
        addSubviews()
        doLayout()
        addTopViewOfStackToFrontForNiceAnimation()
        dismissKeyboardByTapOnView()
        setupDelegates()
    }
    
    private func controllerSetup() {
        view.backgroundColor = .white
        title = "Создать"
    }
    
    private func setupDelegates() {
        titleTextField.delegate = self
        placeTextField.delegate = self
        aboutTextField.delegate = self
    }
    
    private func addSubviews() {
        view.addSubview(topColorView)
        view.addSubview(scrollView)
        navBar?.addSubview(closeControllerImageView)
        scrollView.addSubview(titleTextField)
        titleTextField.addSubview(bottomBorderForTitleLabel)
        scrollView.addSubview(dateTimeVerticalStackView)
        addViewsToDateTimeStack()
        scrollView.addSubview(placeTextField)
        placeTextField.addSubview(bottomBorderForPlacesView)
        scrollView.addSubview(aboutTextField)
        aboutTextField.addSubview(bottomBorderForAboutView)
        scrollView.addSubview(addUsersView)
        addUsersView.addSubview(plusAddUserImageView)
        addUsersView.addSubview(labelForAddUsersView)
        addUsersView.addSubview(bottomBorderForAddUsersView)
    }
    
    private func doLayout() {
        if navBar != nil {
            closeControllerImageView.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(16)
                make.bottom.equalToSuperview().inset(16)
            }
        }
        
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
            make.top.equalTo(bottomBorderForTitleLabel.snp.bottom).offset(16)
        }
        
        topViewForDateTimeStackView.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        
        dateTimeStackTopViewInsideLayout()
        
        bottomViewForDateAndTimeStackView.snp.makeConstraints { make in }
        
        insideStackViewForDatePickerAndTimePicker.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalToSuperview().priority(.high)
        }
        
        calendarPicker.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        viewForTimePickerAndButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        layoutInsideTimePickerView()
        
        placeTextField.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(dateTimeVerticalStackView.snp.bottom).offset(19.5)
            make.height.equalTo(30)
        }
        
        bottomBorderForPlacesView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(placeTextField.snp.bottom).offset(3)
            make.height.equalTo(0.5)
        }
        
        aboutTextField.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(bottomBorderForPlacesView.snp.bottom).offset(16)
            make.height.equalTo(30)
        }
        
        bottomBorderForAboutView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(aboutTextField.snp.bottom).offset(3)
            make.height.equalTo(0.5)
        }
        
        addUsersView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(bottomBorderForAboutView.snp.bottom).offset(16)
            make.height.equalTo(30)
        }
        
        addUsersViewLayout()
    }
    
    private func addViewsToDateTimeStack() {
        dateTimeVerticalStackView.addArrangedSubview(topViewForDateTimeStackView)
        dateTimeVerticalStackView.addArrangedSubview(bottomViewForDateAndTimeStackView)
        topViewForDateTimeStackView.addSubview(arrowForTopViewForDateTimeView)
        topViewForDateTimeStackView.addSubview(labelForTopViewForDateTime)
        topViewForDateTimeStackView.addSubview(bottomBorderForDateTimeTopView)
        bottomViewForDateAndTimeStackView.addSubview(insideStackViewForDatePickerAndTimePicker)
        insideStackViewForDatePickerAndTimePicker.addArrangedSubview(calendarPicker)
        insideStackViewForDatePickerAndTimePicker.addArrangedSubview(viewForTimePickerAndButton)
        viewForTimePickerAndButton.addSubview(timePicker)
        viewForTimePickerAndButton.addSubview(timeLabelForTimeView)
        viewForTimePickerAndButton.addSubview(doneButtonForDateTime)
    }
    
    private func dateTimeStackTopViewInsideLayout() {
        arrowForTopViewForDateTimeView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.width.equalTo(20)
        }
        
        labelForTopViewForDateTime.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalTo(arrowForTopViewForDateTimeView.snp.leading)
            make.centerY.equalToSuperview()
        }
        
        bottomBorderForDateTimeTopView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(topViewForDateTimeStackView.snp.bottom).offset(3)
            make.height.equalTo(0.5)
        }
    }
    
    private func addUsersViewLayout() {
        plusAddUserImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.width.equalTo(20)
        }
        
        labelForAddUsersView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalTo(plusAddUserImageView.snp.leading)
            make.centerY.equalToSuperview()
        }
        
        bottomBorderForAddUsersView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(addUsersView.snp.bottom).offset(3)
            make.height.equalTo(0.5)
        }
    }
    
    private func layoutInsideTimePickerView() {
        timeLabelForTimeView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(calendarPicker.layoutMargins.left)
            make.centerY.equalToSuperview()
        }

        timePicker.snp.makeConstraints { make in
            make.centerY.equalTo(timeLabelForTimeView.snp.centerY)
            make.width.equalTo(100)
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(timeLabelForTimeView.snp.trailing).offset(5)
        }

        doneButtonForDateTime.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(timePicker.snp.centerY)
            make.height.equalTo(34)
            make.width.equalTo(109)
        }
    }
    
    @objc private func showHideDateTimePicker() {
        UIView.animate(withDuration: 0.5) {[weak self] in
            guard let self else { return }
            self.view.endEditing(true)
            self.bottomViewForDateAndTimeStackView.isHidden = !self.bottomViewForDateAndTimeStackView.isHidden
            self.changeLabelAfterCalendarChanged()
            self.dateTimeChevronChange()
            self.view.layoutIfNeeded()
        }
    }
    
    private func addTopViewOfStackToFrontForNiceAnimation() {
        dateTimeVerticalStackView.bringSubviewToFront(topViewForDateTimeStackView)
    }
    
    private func dateTimeChevronChange() {
        self.bottomViewForDateAndTimeStackView.isHidden ? (arrowForTopViewForDateTimeView.image = UIImage(systemName: "chevron.down")) :
        (arrowForTopViewForDateTimeView.image = UIImage(systemName: "chevron.up"))
    }
    
    private func dismissKeyboardByTapOnView() {
        let gestureRecogn = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        gestureRecogn.cancelsTouchesInView = false
        self.view.addGestureRecognizer(gestureRecogn)
    }
    
    @objc private func changeLabelAfterCalendarChanged() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY HH:mm"
        let calendarPickerDay = calendarPicker.calendar.component(.day, from: calendarPicker.date)
        let calendarPickerMonth = calendarPicker.calendar.component(.month, from: calendarPicker.date)
        let calendarPickerYear = calendarPicker.calendar.component(.year, from: calendarPicker.date)
        let timePickerHours = timePicker.calendar.component(.hour, from: timePicker.date)
        let timePickerMinutes = timePicker.calendar.component(.minute, from: timePicker.date)
        let finalDateComponents = DateComponents(year: calendarPickerYear, month: calendarPickerMonth, day: calendarPickerDay, hour: timePickerHours, minute: timePickerMinutes)
        let finalDate = Calendar.current.date(from: finalDateComponents) ?? Date.now
        let prettyDate = dateFormatter.string(from: finalDate)
        self.labelForTopViewForDateTime.text = "Дата: \(prettyDate)"
    }
    
    @objc private func closeController() {
        self.dismiss(animated: true)
    }
    
    @objc private func goToAddUsersVC() {
        let addUserVC = AddUsersViewController()
        let vc = UINavigationController(rootViewController: addUserVC)
        addUserVC.addedUsersDataBringToCreateVC = {[weak self] addedUsersArray in
            guard let self else { return }
            self.addedUsers = addedUsersArray
        }
        addUserVC.addedUsersArray = addedUsers
        self.view.endEditing(true)
        self.present(vc, animated: true)
    }
}

extension CreateEventViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
