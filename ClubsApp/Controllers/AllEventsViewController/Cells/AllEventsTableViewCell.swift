//
//  AllEventsTableViewCell.swift
//  ClubsApp
//
//  Created by Ivan Kuzmenkov on 6.03.23.
//

import UIKit

class AllEventsTableViewCell: UITableViewCell {
    static var id = String(describing: AllEventsTableViewCell.self)
    
    var label: UILabel = {
        let label = UILabel()
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        doLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        contentView.addSubview(label)
    }
    
    private func doLayout() {
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
}
