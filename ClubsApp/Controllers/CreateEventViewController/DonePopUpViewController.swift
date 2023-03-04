//
//  DonePopUpViewController.swift
//  ClubsApp
//
//  Created by Ivan Kuzmenkov on 4.03.23.
//

import UIKit

class DonePopUpViewController: UIViewController {
    
    var doneView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 13
        return view
    }()
    
    var stackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 14
        return stackView
    }()
    
    var imageView: UIImageView = {
        var imageView = UIImageView()
        var image = UIImage(named: "doneImage")
        imageView.image = image
        return imageView
    }()
    
    var label: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.text = "Успешно создано!"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.3)
        addSubviews()
        doLayout()
    }
    
    private func addSubviews() {
        view.addSubview(doneView)
        doneView.addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
    }
    
    private func doLayout() {
        doneView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(300)
        }
        
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerX.centerY.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.height.equalTo(87)
            make.width.equalTo(89)
        }
    }
}
