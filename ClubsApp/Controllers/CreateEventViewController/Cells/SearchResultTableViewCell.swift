//
//  SearchResultTableViewCell.swift
//  ClubsApp
//
//  Created by Ivan Kuzmenkov on 23.02.23.
//

import UIKit
import SnapKit

class SearchResultTableViewCell: UITableViewCell {
    static var id = String(describing: SearchResultTableViewCell.self)
    
    
    var nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var roundImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    var isSelectedIndicator: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor(red: 0.498, green: 0.02, blue: 0.976, alpha: 1).cgColor
        return view
    }()
    
    var firstCharOfNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.textColor = .white
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        cellSetup()
        addSubviews()
        doLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        roundImage.layer.cornerRadius = roundImage.frame.size.width / 2
        isSelectedIndicator.layer.cornerRadius = isSelectedIndicator.frame.size.width / 2
    }
    
    private func cellSetup() {
        self.selectionStyle = .none
    }
    
    private func addSubviews() {
        contentView.addSubview(roundImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(isSelectedIndicator)
        roundImage.addSubview(firstCharOfNameLabel)
    }
    
    private func doLayout() {
        roundImage.snp.makeConstraints { make in
            make.height.width.equalTo(48)
            make.leading.equalToSuperview().offset(16)
            make.top.bottom.equalToSuperview()
        }
        
        isSelectedIndicator.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(roundImage.snp.trailing).offset(12)
            make.top.equalToSuperview().offset(4)
            make.trailing.equalTo(isSelectedIndicator.snp.leading)
        }
        
        firstCharOfNameLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
