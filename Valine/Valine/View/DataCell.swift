//
//  DataCell.swift
//  LeanData
//
//  Created by xu on 2020/7/1.
//  Copyright © 2020 xaoxuu. All rights reserved.
//

import UIKit

/// 数据库里的一行
class DataCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        let margin = ipr.layout.margin
        textLabel?.numberOfLines = 16
        detailTextLabel?.numberOfLines = 32
        detailTextLabel?.textColor = .systemGray
        textLabel?.font = .bold(17)
        detailTextLabel?.font = .regular(12)
        
        textLabel?.snp.remakeConstraints({ (mk) in
            mk.top.equalToSuperview().offset(margin)
            mk.width.equalToSuperview().offset(-margin*2)
            mk.centerX.equalToSuperview()
        })
        detailTextLabel?.snp.remakeConstraints({ (mk) in
            mk.width.equalToSuperview().offset(-margin*2)
            mk.centerX.equalToSuperview()
            mk.width.lessThanOrEqualToSuperview().offset(-margin*2).priority(.high)
            mk.bottom.equalToSuperview().offset(-margin)
            mk.top.equalTo(textLabel!.snp.bottom).offset(margin/2)
        })
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
