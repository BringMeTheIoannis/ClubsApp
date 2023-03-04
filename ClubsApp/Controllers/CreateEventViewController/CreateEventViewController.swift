//
//  CreateEventViewController.swift
//  ClubsApp
//
//  Created by Ivan Kuzmenkov on 13.02.23.
//

import UIKit
import SnapKit
import EmojiPicker

class CreateEventViewController: UIViewController {
    
    var addedUsers = [User]()
    var isClosedEvent: Bool = false
    lazy var navBar: UINavigationBar? = self.navigationController?.navigationBar
    var eventDate: Date = Date()
    
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
        picker.locale = Locale(identifier: "ru_RU")
        picker.calendar.firstWeekday = 2
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
        picker.locale = Locale(identifier: "ru_RU")
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
    
    var emojiView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var  emojiRoundView: UIView = {
        let view = UIView()
        let gesutre = UITapGestureRecognizer(target: self, action: #selector(openEmojiPickerModule))
        view.backgroundColor = UIColor(red: 0.66, green: 0.553, blue: 0.767, alpha: 1)
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(gesutre)
        return view
    }()
    
    lazy var emojiExplainLabel: UILabel = {
        let label = UILabel()
        let gesutre = UITapGestureRecognizer(target: self, action: #selector(openEmojiPickerModule))
        label.text = "Выберите картинку"
        label.textColor = UIColor(red: 0.66, green: 0.553, blue: 0.767, alpha: 1)
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(gesutre)
        return label
    }()
    
    var emojiStringLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Apple color emoji", size: 30)
        label.textAlignment = .center
        return label
    }()
    
    var isClosedEventView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var isClosedEventCheckMark: UIImageView = {
        let imageView = UIImageView()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(isClosedEventToggle))
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor(red: 0.66, green: 0.553, blue: 0.767, alpha: 1).cgColor
        imageView.tintColor = UIColor(red: 0.66, green: 0.553, blue: 0.767, alpha: 1)
        imageView.layer.cornerRadius = 2
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(gesture)
        return imageView
    }()
    
    var isClosedEventLabel: UILabel = {
        let label = UILabel()
        label.text = "Закрытая встреча"
        return label
    }()
    
    lazy var createButton: UIButton = {
        let button = UIButton(type: .system)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(createEvent))
        button.backgroundColor = UIColor(red: 0.498, green: 0.02, blue: 0.976, alpha: 1)
        button.tintColor = .white
        button.setTitle("Создать", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.layer.cornerRadius = 8
        button.isUserInteractionEnabled = true
        button.addGestureRecognizer(gesture)
        return button
    }()
    
    lazy var scrollViewContentContainer: UIView = {
        let view = UIView()
        return view
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
//        indicator.alpha = 0.0
        return indicator
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        makeViewsRounded()
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
        scrollView.addSubview(scrollViewContentContainer)
        navBar?.addSubview(closeControllerImageView)
        scrollViewContentContainer.addSubview(titleTextField)
        titleTextField.addSubview(bottomBorderForTitleLabel)
        scrollViewContentContainer.addSubview(dateTimeVerticalStackView)
        addViewsToDateTimeStack()
        scrollViewContentContainer.addSubview(placeTextField)
        placeTextField.addSubview(bottomBorderForPlacesView)
        scrollViewContentContainer.addSubview(aboutTextField)
        aboutTextField.addSubview(bottomBorderForAboutView)
        scrollViewContentContainer.addSubview(addUsersView)
        addUsersView.addSubview(plusAddUserImageView)
        addUsersView.addSubview(labelForAddUsersView)
        addUsersView.addSubview(bottomBorderForAddUsersView)
        scrollViewContentContainer.addSubview(emojiView)
        emojiView.addSubview(emojiRoundView)
        emojiView.addSubview(emojiExplainLabel)
        emojiRoundView.addSubview(emojiStringLabel)
        scrollViewContentContainer.addSubview(isClosedEventView)
        isClosedEventView.addSubview(isClosedEventCheckMark)
        isClosedEventView.addSubview(isClosedEventLabel)
        scrollViewContentContainer.addSubview(errorLabel)
        scrollViewContentContainer.addSubview(createButton)
        createButton.addSubview(activityIndicator)
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
        
        scrollViewContentContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.safeAreaLayoutGuide).priority(.low)
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
        
        emojiView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(bottomBorderForAddUsersView.snp.bottom).offset(16)
        }
        
        emojiRoundView.snp.makeConstraints { make in
            make.height.width.equalTo(48)
            make.leading.top.bottom.equalToSuperview()
        }
        
        emojiExplainLabel.snp.makeConstraints { make in
            make.leading.equalTo(emojiRoundView.snp.trailing).offset(8)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        emojiStringLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        isClosedEventView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(emojiView.snp.bottom).offset(18)
        }
        
        isClosedEventCheckMark.snp.makeConstraints { make in
            make.height.width.equalTo(18)
            make.leading.top.bottom.equalToSuperview()
        }
        
        isClosedEventLabel.snp.makeConstraints { make in
            make.leading.equalTo(isClosedEventCheckMark.snp.trailing).offset(8)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        errorLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(isClosedEventView.snp.bottom).offset(20)
            make.height.equalTo(32)
        }
        
        createButton.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.top.greaterThanOrEqualTo(errorLabel.snp.bottom).offset(50)
            make.bottom.equalToSuperview().offset(-5).priority(.high)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
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
    
    private func makeViewsRounded() {
        emojiRoundView.layer.cornerRadius = emojiRoundView.frame.size.width / 2
    }
    
    @objc private func isClosedEventToggle() {
        isClosedEvent.toggle()
        if isClosedEvent {
            UIView.transition(with: isClosedEventCheckMark, duration: 0.3, options: .transitionCrossDissolve) {[weak self] in
                guard let self else { return }
                self.isClosedEventCheckMark.image = UIImage(systemName: "checkmark")
            }
        } else {
            UIView.transition(with: isClosedEventCheckMark, duration: 0.3, options: .transitionCrossDissolve) {[weak self] in
                guard let self else { return }
                self.isClosedEventCheckMark.image = nil
            }
        }
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
        eventDate = finalDate
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
        addUserVC.tableView.reloadData()
        self.view.endEditing(true)
        self.present(vc, animated: true)
    }
    
    @objc private func openEmojiPickerModule() {
        let emojiVC = EmojiPickerViewController()
        emojiVC.sourceView = emojiRoundView
        emojiVC.delegate = self
        emojiVC.horizontalInset = 16
        emojiVC.isDismissedAfterChoosing = true
        view.safeAreaLayoutGuide.layoutFrame.maxY - emojiView.frame.maxY > 270 ? (emojiVC.arrowDirection = .up) : (emojiVC.arrowDirection = .down)
        present(emojiVC, animated: true)
    }
    
    @objc private func createEvent() {
        let database = DatabaseManager()
        let titleText = titleTextField.text.unwrapped
        let dateTimeLabelText = labelForTopViewForDateTime.text.unwrapped
        let placeLocationText = placeTextField.text.unwrapped
        let aboutText = aboutTextField.text.unwrapped
        let pictureText = emojiStringLabel.text.unwrapped
        
        if titleText.isEmpty {
            addErrorTextWithAnimation(errorText: "Поле название не может быть пустым")
            return
        }
        if dateTimeLabelText == "Выберите дату и время" {
            addErrorTextWithAnimation(errorText: "Выберите дату и время")
            return
        }
        if placeLocationText.isEmpty {
            addErrorTextWithAnimation(errorText: "Поле c местоположением не может быть пустым")
            return
        }
        if aboutText.isEmpty {
            addErrorTextWithAnimation(errorText: "Поле с описанием не может быть пустым")
            return
        }
        if pictureText.isEmpty {
            addErrorTextWithAnimation(errorText: "Выберите эмодзи, наиболее соотвествующее событию")
            return
        }
        addErrorTextWithAnimation(errorText: "")
        let eventModel = EventModel(title: titleText, date: eventDate, place: placeLocationText, about: aboutText, invitedUsers: addedUsers, picture: pictureText, isClosedEvent: isClosedEvent)
        
        createButton.titleLabel?.alpha = 0.0
        activityIndicator.startAnimating()
        database.createEvent(eventModel: eventModel) {[weak self] in
            guard let self else { return }
            self.activityIndicator.stopAnimating()
            self.createButton.titleLabel?.alpha = 1.0
            self.showDonePopUp()
        } failure: {[weak self] error in
            guard let self else { return }
            self.activityIndicator.stopAnimating()
            self.createButton.titleLabel?.alpha = 1.0
            self.addErrorTextWithAnimation(errorText: error)
        }
    }
    
    private func showDonePopUp() {
        let donePopUpVC = DonePopUpViewController()
        donePopUpVC.modalPresentationStyle = .overCurrentContext
        donePopUpVC.modalTransitionStyle = .crossDissolve
        self.present(donePopUpVC, animated: true)
        donePopUpVC.dismiss = {[weak self] in
            guard let self else { return }
            self.dismiss(animated: true)
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
}

extension CreateEventViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField != titleTextField, !bottomViewForDateAndTimeStackView.isHidden {
            showHideDateTimePicker()
            textField.becomeFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}

extension CreateEventViewController: EmojiPickerDelegate{
    func didGetEmoji(emoji: String) {
        emojiStringLabel.text = emoji
    }
}
