//
//  SubGridCell.swift
//  KBScrollMagic
//
//  Created by liyang on 2017/4/2.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

class SubGridCell: UITableViewCell {
    
    static let cellIdentifier = "kSubGridCellIdentifier"
    static let cellHeight = CGFloat(70)
    
    let coverIV = UIImageView()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkText
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "美景"
        return label
    }()

    let detailLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor.darkText
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "红红的霜叶陶醉了秋日的树林，潺潺的溪水胜过了悠扬的琴声。当人们心情豪迈地欣赏着这动人的美景，即使露水沾湿了衣服也会浑然不觉。"
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(coverIV)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        
        coverIV.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(100)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(coverIV)
            make.left.equalTo(coverIV.snp.right).offset(10)
            make.right.equalToSuperview().offset(-15)
        }
        
        detailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.bottom.equalTo(coverIV)
            make.left.equalTo(coverIV.snp.right).offset(10)
            make.right.equalToSuperview().offset(-15)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
