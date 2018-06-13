//
//  UpdateViewController.swift
//  MaxRep
//
//  Created by Siavash on 13/6/18.
//  Copyright © 2018 Siavash. All rights reserved.
//

import Foundation
import SnapKit
import FirebaseDatabase

final class UpdateViewController: UIViewController {
  
  var selectedIndex: Int = 0
  var selectedRepIndex: Int = 0
  
  private lazy var editTextField: UITextField = {
    let txt = UITextField()
    txt.textColor = .black
    txt.textAlignment = .center
    txt.delegate = self
    txt.keyboardType = UIKeyboardType.numbersAndPunctuation
    txt.returnKeyType = .done
    txt.layer.cornerRadius = 4
    txt.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor
    txt.layer.borderWidth = 1
    txt.clearsOnBeginEditing = true
    return txt
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(editTextField)
    view.backgroundColor = .white
    editTextField.snp.makeConstraints { (make) in
      make.height.equalTo(44)
      make.left.equalTo(16)
      make.top.equalTo(100)
      make.centerX.equalToSuperview()
    }
    
    let item = AppDelegate.shared.exercise[selectedIndex]
    editTextField.text = "\((item.info[selectedRepIndex].value(forKey: Constant.kWeight) as? Double) ?? 0)KG"
    title = "\(item.name) - Rep: \(String(describing: item.info[selectedRepIndex].value(forKey: Constant.kRep) ?? ""))"
  }
}
extension UpdateViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    // udpate
    view.endEditing(true)
    if let txt = textField.text, txt.count > 1 {
      let double = Double(textField.text!)
      var item = AppDelegate.shared.exercise[selectedIndex]
      item.info[selectedRepIndex].setValue(double, forKey: Constant.kWeight)
      var ref: DatabaseReference!
      ref = Database.database().reference()
      ref.child(Constant.kExercise).child(item.key).setValue([Constant.kName: item.name, Constant.kInfo: item.info])
      _ = navigationController?.popViewController(animated: true)
    }

    return true
  }
}
