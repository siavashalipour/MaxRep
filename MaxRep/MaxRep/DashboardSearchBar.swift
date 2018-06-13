//
//  SearchBar.swift
//  MaxRep
//
//  Created by Siavash on 13/6/18.
//  Copyright © 2018 Siavash. All rights reserved.
//

import Foundation
import Foundation
import SnapKit

protocol DashboardSearchBarDelegate {
  func searchbarTextUpdating(text: String)
  func willShowKeyboardWith(height: CGFloat)
  func willHideKeyboard()
  func didDeleteSearchField()
  func didTapClose()
  func didBeginEditing()
  func didEndEditing()
}
final class DashboardSearchBar: UIView {
  
  var delegate: DashboardSearchBarDelegate?
  
  private lazy var closebtn: UIButton = {
    let btn = UIButton()
    btn.setImage(#imageLiteral(resourceName: "cross"), for: .normal)
    btn.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
    return btn
    
  }()
  lazy var searchTextField: UITextField = {
    let txtField = UITextField()
    txtField.font = UIFont.systemFont(ofSize: 14)
    txtField.textColor = UIColor.black
    txtField.attributedPlaceholder = NSAttributedString.init(string: NSLocalizedString("Search", comment: ""), attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.gray])
    txtField.delegate = self
    txtField.returnKeyType = .search
    return txtField
  }()
  private lazy var separator: UIView = {
    let v = UIView()
    v.backgroundColor = UIColor.white
    return v
  }()
  override init(frame: CGRect) {
    super.init(frame: frame)
    defaultSetup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    defaultSetup()
  }
  private func defaultSetup() {
    NotificationCenter.default.removeObserver(self)
    NotificationCenter.default.addObserver(self, selector: #selector(self.willShowKeyboard(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.willHideKeyboard), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    
    _ = subviews.map({
      $0.removeFromSuperview()
    })
    // add close button
    addSubview(closebtn)
    closebtn.snp.makeConstraints { (make) in
      make.size.equalTo(CGSize(width: 20, height: 20))
      make.left.equalTo(8)
      if #available(iOS 11, *) {
        let guide = safeAreaLayoutGuide
        make.top.equalTo(guide.snp.top).offset(15)
      } else {
        make.top.equalTo(15)
      }
    }
    // add search text
    addSubview(searchTextField)
    searchTextField.snp.makeConstraints { (make) in
      make.left.equalTo(closebtn.snp.right).offset(8)
      make.right.equalTo(-8)
      make.height.equalTo(22)
      make.top.equalTo(closebtn)
    }
    // add separator
    addSubview(separator)
    separator.snp.makeConstraints { (make) in
      make.height.equalTo(1)
      make.left.right.bottom.equalToSuperview()
    }
  }
  @objc
  private func willShowKeyboard(_ notification: Notification) {
    delegate?.willShowKeyboardWith(height: getKeyboardHeight(for: notification))
  }
  
  @objc
  private func willHideKeyboard() {
    delegate?.willHideKeyboard()
  }
  
  private func setupDefaultAttributedPlaceholder() {
    searchTextField.attributedPlaceholder = NSAttributedString.init(string: NSLocalizedString("Search", comment: ""), attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.gray])
  }
  @objc
  private func didTapClose() {
    searchTextField.endEditing(true)
    delegate?.didTapClose()
  }
  func updateSearchField(to text: String) {
    searchTextField.text = text
  }
  func startEditMode() {
    searchTextField.becomeFirstResponder()
  }
  
  func getKeyboardHeight(for notification: Notification) -> CGFloat {
    let keyboardInfo = (notification as NSNotification).userInfo
    let keyboardFrameBegin = keyboardInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
    let keyboardFrameBeginRect = keyboardFrameBegin.cgRectValue
    return keyboardFrameBeginRect.height
  }
}
extension DashboardSearchBar: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    if textField.text == "" {
      textField.placeholder = ""
    }
    delegate?.didBeginEditing()
  }
  func textFieldDidEndEditing(_ textField: UITextField) {
    if textField.text == "" { // put back the placeholder
      setupDefaultAttributedPlaceholder()
    }
    delegate?.didEndEditing()
  }
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let text = textField.text else { return true }
    if text.count == 1 && string == "" { // text field is now empty
      delegate?.didDeleteSearchField()
      setupDefaultAttributedPlaceholder()
      return true
    }
    if text == "" {
      delegate?.searchbarTextUpdating(text: string)
    } else if string != "" {
      delegate?.searchbarTextUpdating(text: text + string)
    } else {
      delegate?.searchbarTextUpdating(text: String(text.characters.dropLast()))
    }
    return true
  }
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    delegate?.searchbarTextUpdating(text: textField.text ?? "")
    endEditing(true)
    return true
  }
}
