//
//  EditViewController.swift
//  MaxRep
//
//  Created by Siavash on 13/6/18.
//  Copyright © 2018 Siavash. All rights reserved.
//

import Foundation
import SnapKit

final class EditViewController: UIViewController {
  
  var selectedIndex: Int = 0
  
  private lazy var tableView: UITableView = {
    let tb = UITableView()
    tb.allowsSelection = true
    tb.register(EditCell.self, forCellReuseIdentifier: String(describing: EditCell.self))
    tb.delegate = self
    tb.dataSource = self
    return tb
  }()
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    ViewModel.fetchData {
      self.tableView.reloadData()
    }
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(tableView)
    tableView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    title = AppDelegate.shared.exercise[selectedIndex].name
  }
}

extension EditViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return AppDelegate.shared.exercise[selectedIndex].info.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: EditCell
    if let aCell = tableView.dequeueReusableCell(withIdentifier: String(describing: EditCell.self)) as? EditCell {
      cell = aCell
    } else {
      cell = EditCell()
    }
    let item = AppDelegate.shared.exercise[selectedIndex].info[indexPath.row]
    cell.config(with: item.value(forKey: Constant.kRep) as! Int, weight: item.value(forKey: Constant.kWeight) as! Double)
    return cell
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc = UpdateViewController()
    vc.selectedIndex = selectedIndex
    vc.selectedRepIndex = indexPath.row
    navigationController?.pushViewController(vc, animated: true)
  }
}
