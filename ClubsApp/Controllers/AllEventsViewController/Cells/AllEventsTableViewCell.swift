//
//  AllEventsTableViewCell.swift
//  ClubsApp
//
//  Created by Ivan Kuzmenkov on 6.03.23.
//

import UIKit

class AllEventsTableViewCell: UITableViewCell {
    static var id = String(describing: AllEventsTableViewCell.self)
    
    var contentInnerView: UIView = {
        let view = UIView()
        return view
    }()
    
    var eventEmojiLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Apple color emoji", size: 50)
        return label
    }()
    
    var titleAndIconContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    var participantsContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    var participantImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    var firstCharOnImageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    var quantityOfParticipantsLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = UIColor(red: 0.617, green: 0.617, blue: 0.617, alpha: 1)
        return label
    }()
    
    var dateContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = UIColor(red: 0.617, green: 0.617, blue: 0.617, alpha: 1)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        doLayout()
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        participantImageView.layer.cornerRadius = participantImageView.frame.height / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        contentView.addSubview(contentInnerView)
        contentInnerView.addSubview(eventEmojiLabel)
        contentInnerView.addSubview(titleAndIconContainerView)
        titleAndIconContainerView.addSubview(titleLabel)
        contentInnerView.addSubview(participantsContainerView)
        participantsContainerView.addSubview(participantImageView)
        participantsContainerView.addSubview(quantityOfParticipantsLabel)
        participantImageView.addSubview(firstCharOnImageLabel)
        contentInnerView.addSubview(dateContainerView)
        dateContainerView.addSubview(dateLabel)
    }
    
    private func doLayout() {
        let innerViewInserts = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        
        contentInnerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(innerViewInserts)
        }
        
        eventEmojiLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview()
            make.height.width.equalTo(50)
        }
        
        titleAndIconContainerView.snp.makeConstraints { make in
            make.leading.equalTo(eventEmojiLabel.snp.trailing).offset(13)
            make.top.trailing.equalToSuperview()
            make.height.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        participantsContainerView.snp.makeConstraints { make in
            make.top.equalTo(titleAndIconContainerView.snp.bottom).offset(8)
            make.leading.equalTo(eventEmojiLabel.snp.trailing).offset(13)
            make.trailing.equalToSuperview()
            make.height.equalTo(19)
        }
        
        participantImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(19)
        }
        
        firstCharOnImageLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        quantityOfParticipantsLabel.snp.makeConstraints { make in
            make.leading.equalTo(participantImageView.snp.trailing).offset(4)
            make.top.bottom.trailing.equalToSuperview()
        }
        
        dateContainerView.snp.makeConstraints { make in
            make.leading.equalTo(eventEmojiLabel.snp.trailing).offset(13)
            make.trailing.bottom.equalToSuperview()
            make.top.equalTo(participantsContainerView.snp.bottom).offset(9.5)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
