//
//  DataDetailVM.swift
//  LeanData
//
//  Created by xu on 2020/7/1.
//  Copyright © 2020 xaoxuu. All rights reserved.
//

import UIKit
import LeanCloud

class DataDetailVM: NSObject {
    
    var object: LCObject
    
    var keys = [String]()
    
    weak var controller: UIViewController?
    weak var view: DataTable?
    
    init(object: LCObject) {
        self.object = object
        
        if let dict = object.jsonValue as? [String : LCValueConvertible] {
            for k in dict.keys.sorted() {
                if ["__type", "className"].contains(k) == false {
                    keys.append(k)
                }
            }
        }
        
    }
    
}

extension DataDetailVM: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keys.count
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: view?.bindCell.description() ?? "cell", for: indexPath)
        let k = keys[indexPath.row]
        cell.textLabel?.text = k
        let obj = object.get(k)
        if let str = obj?.stringValue {
            cell.detailTextLabel?.text =  str.trimmingCharacters(in: .whitespacesAndNewlines)
        } else if let date = obj?.dateValue {
            cell.detailTextLabel?.text =  date.fullDesc
        } else {
            cell.detailTextLabel?.text = obj?.lcValue.jsonString
        }
        if ["__type", "className", "objectId", "createdAt", "updatedAt","insertedAt", "pid", "rid"].contains(k) == false {
            cell.textLabel?.alpha = 1
            cell.detailTextLabel?.alpha = 1
            cell.isUserInteractionEnabled = true
        } else {
            cell.textLabel?.alpha = 0.35
            cell.detailTextLabel?.alpha = 0.35
            cell.isUserInteractionEnabled = false
        }
        // FIXME: 发现复用布局有问题，暂时不知道怎么解决
        if let lb1 = cell.textLabel, let lb2 = cell.detailTextLabel, lb1.superview != nil, lb2.superview != nil {
            let margin = ipr.layout.margin
            lb1.snp.remakeConstraints({ (mk) in
                mk.top.equalToSuperview().offset(margin-4)
                mk.width.equalToSuperview().offset(-margin*2)
                mk.centerX.equalToSuperview()
            })
            lb2.snp.remakeConstraints({ (mk) in
                mk.width.equalToSuperview().offset(-margin*2)
                mk.centerX.equalToSuperview()
                mk.width.lessThanOrEqualToSuperview().offset(-margin*2).priority(.high)
                mk.bottom.equalToSuperview().offset(-margin)
                mk.top.equalTo(lb1.snp.bottom).offset(margin/2)
            })
        }
        
        return cell
    }
    
}

extension DataDetailVM: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let k = keys[indexPath.row]
        let vc = EditTextVC(title: k, text: "") { (str) in
            ProHUD.Alert.push("update", scene: .update) { (a) in
                a.update { (vm) in
                    vm.title = "正在更新"
                }
            }
            try? self.object.set(k, value: str)
            self.object.save { (result) in
                ErrorManager(lcError: result.error, id: "update")
                switch result {
                case .success:
                    ProHUD.Alert.push("update", scene: .success) { (a) in
                        a.update { (vm) in
                            vm.title = "更新成功"
                            vm.duration = 1
                        }
                    }
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                    NotificationCenter.default.post(name: NSNotification.Name.init("reload"), object: nil)
                    break
                case .failure(error: let error):
                    print(error)
                    
                }
                
            }
        }
        let obj = object.get(k)
        if let str = obj?.stringValue {
            vc.tv.text =  str
        } else if let date = obj?.dateValue {
            vc.tv.text =  date.fullDesc
        } else {
            vc.tv.text = obj?.lcValue.jsonString
        }
        controller?.present(vc, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return object.createdAt?.lcValue.dateValue?.fullDesc
    }
    
}
