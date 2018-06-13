//
//  EditCell.swift
//  MaxRep
//
//  Created by Siavash on 13/6/18.
//  Copyright © 2018 Siavash. All rights reserved.
//

import Foundation
import SnapKit

final class EditCell: UITableViewCell {
  
  private lazy var repLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.textAlignment = .left
    label.numberOfLines = 0
    return label
    
  }()
  private lazy var weightLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.textAlignment = .right
    label.numberOfLines = 0
    return label
  }()
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  private func setupUI() {
    
    _ = contentView.subviews.map({$0.removeFromSuperview()})
    contentView.addSubview(repLabel)
    repLabel.snp.makeConstraints { (make) in
      make.left.top.equalTo(8)
      make.centerY.equalToSuperview()
    }
    contentView.addSubview(weightLabel)
    weightLabel.snp.makeConstraints { (make) in
      make.right.equalTo(-8)
      make.centerY.equalTo(repLabel)
    }
  }
  
  func config(with rep: Int, weight: Double) {
    repLabel.text = "Rep: \(rep)"
    weightLabel.text = "\(weight)KG"
  }
}
