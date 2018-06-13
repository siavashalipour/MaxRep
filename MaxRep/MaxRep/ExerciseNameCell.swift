//
//  ExerciseNameCell.swift
//  MaxRep
//
//  Created by Siavash on 13/6/18.
//  Copyright © 2018 Siavash. All rights reserved.
//

import Foundation
import SnapKit

final class ExerciseNameCell: UITableViewCell {
  
  private lazy var nameLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.textAlignment = .left
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
    contentView.addSubview(nameLabel)
    nameLabel.snp.makeConstraints { (make) in
      make.left.top.equalTo(8)
      make.centerY.equalToSuperview()
    }
  }
  
  func config(with exercise: Exercise) {
    nameLabel.text = exercise.name
  }
}
