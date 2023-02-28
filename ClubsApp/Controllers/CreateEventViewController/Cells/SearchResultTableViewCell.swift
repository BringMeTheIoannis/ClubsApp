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
    var colorsForImage: [UIColor] = [.systemGreen, .systemBlue, .systemCyan, .systemMint, .systemPink, .systemGray, .systemOrange, .systemYellow, .systemPurple]
    
    var nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var roundImage: UIImageView = {
        let imageView = UIImageView()
        let randomColorIndex = Int.random(in: 0..<colorsForImage.count)
        imageView.backgroundColor = colorsForImage[randomColorIndex]
        return imageView
    }()
    
    var isSelectedIndicator: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor(red: 0.498, green: 0.02, blue: 0.976, alpha: 1).cgColor
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        doLayout()
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        roundImage.layer.cornerRadius = roundImage.frame.size.width / 2
        isSelectedIndicator.layer.cornerRadius = isSelectedIndicator.frame.size.width / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        contentView.addSubview(roundImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(isSelectedIndicator)
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
    }
}
