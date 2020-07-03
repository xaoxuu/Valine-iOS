//
//  DataTable.swift
//  LeanData
//
//  Created by xu on 2020/7/1.
//  Copyright © 2020 xaoxuu. All rights reserved.
//

import UIKit

class DataTable: UITableView {
    
    var bindCell: UITableViewCell.Type = DataCell.self
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: .insetGrouped)
        
        separatorInset = .init(top: 0, left: ipr.layout.margin, bottom: 0, right: ipr.layout.margin)
        separatorColor = .systemGray5
        register(bindCell, forCellReuseIdentifier: bindCell.description())
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
