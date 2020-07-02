//
//  InputBar.swift
//  Valine
//
//  Created by xu on 2020/7/2.
//  Copyright © 2020 xaoxuu.com. All rights reserved.
//

import UIKit

class InputBar: UIView {

    var prefix: String? {
        set {
            lb.text = newValue
        }
        get {
            return lb.text
        }
    }
    var placeholder: String? {
        set {
            tf.placeholder = newValue
        }
        get {
            return tf.placeholder
        }
    }
    
    let lb = UILabel()

    let tf = UITextField()
    
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = ipr.layout.cornerRadius.regular
        lb.font = .bold(12)
        lb.textColor = .systemGray
        tf.autocorrectionType = .no
        tf.font = .regular(15)
        tf.adjustsFontSizeToFitWidth = true
        tf.clearButtonMode = .whileEditing
        tf.leftViewMode = .always
        tf.enablesReturnKeyAutomatically = true
        tf.returnKeyType = .done
        
        addSubview(lb)
        addSubview(tf)
        
        let border = UIView()
        border.backgroundColor = UIColor.systemGray.withAlphaComponent(0.1)
        addSubview(border)
        
        lb.snp.contentHuggingVerticalPriority = 1
        tf.snp.contentHuggingVerticalPriority = 0
        
        lb.snp.makeConstraints { (mk) in
            mk.top.equalToSuperview().offset(12)
            mk.left.equalToSuperview().offset(8)
        }
        
        tf.snp.makeConstraints { (mk) in
            mk.top.equalTo(lb.snp.bottom)
            mk.bottom.right.equalToSuperview().offset(-8)
            mk.left.equalToSuperview().offset(8)
        }
        
        border.snp.makeConstraints { (mk) in
            mk.left.right.bottom.equalTo(tf)
            mk.height.equalTo(1)
        }
        
        tf.rx.controlEvent(.editingDidBegin).subscribe(onNext: { (void) in
            UIView.animate(withDuration: 0.2) {
                border.backgroundColor = .accent
            }
        }).disposed(by: disposeBag)
        tf.rx.controlEvent([.editingDidEnd, .editingDidEndOnExit]).subscribe(onNext: { (void) in
            UIView.animate(withDuration: 0.2) {
                border.backgroundColor = UIColor.systemGray.withAlphaComponent(0.1)
            }
        }).disposed(by: disposeBag)
        
    }
    
    convenience init(prefix: String?, placeholder: String? = nil, defaultText: String? = nil) {
        self.init(frame: .zero)
        self.prefix = prefix
        self.placeholder = placeholder
        self.tf.text = defaultText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
