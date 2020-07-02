//
//  TextField.swift
//  Valine
//
//  Created by xu on 2020/7/2.
//  Copyright © 2020 xaoxuu.com. All rights reserved.
//

import UIKit

class TFLeftView: UIView {

    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.textAlignment = .right
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (mk) in
            mk.center.equalToSuperview()
            mk.right.equalToSuperview().offset(-16)
            mk.width.equalTo(60)
            mk.height.equalTo(34)
        }
        titleLabel.font = .bold(15)
        
        titleLabel.backgroundColor = .white
        titleLabel.layer.cornerRadius = 8
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class TF: UITextField {
    
    var prefix: String? {
        set {
            leftV.titleLabel.text = newValue
        }
        get {
            return leftV.titleLabel.text
        }
    }
    
    let leftV = TFLeftView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        autocorrectionType = .no
        placeholder = placeholder
        font = .regular(15)
        clearButtonMode = .whileEditing
        leftViewMode = .always
        enablesReturnKeyAutomatically = true
        
        leftView = leftV
        
    }
    
    convenience init(returnKeyType: UIReturnKeyType) {
        self.init(frame: .zero)
        self.returnKeyType = returnKeyType
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
