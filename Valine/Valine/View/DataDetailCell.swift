//
//  DataDetailCell.swift
//  Valine
//
//  Created by xu on 2020/7/3.
//  Copyright © 2020 xaoxuu.com. All rights reserved.
//

import UIKit

class DataDetailCell: DataCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        textLabel?.textColor = .systemGray
        textLabel?.font = .regular(12)
        detailTextLabel?.textColor = nil
        detailTextLabel?.font = .bold(17)
        textLabel?.snp.updateConstraints({ (mk) in
            mk.top.equalToSuperview().offset(ipr.layout.margin-4)
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
