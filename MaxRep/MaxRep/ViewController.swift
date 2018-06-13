//
//  ViewController.swift
//  MaxRep
//
//  Created by Siavash on 13/6/18.
//  Copyright © 2018 Siavash. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON
import FirebaseDatabase

class ViewController: UIViewController {
  
  private lazy var searchBar: DashboardSearchBar = {
    let s = DashboardSearchBar()
    s.delegate = self
    s.isHidden = false
    return s
  }()
  private var keyword: String = ""
  private var filtered = AppDelegate.shared.exercise

  private lazy var tableView: UITableView = {
    let tb = UITableView()
    tb.allowsSelection = true
    tb.register(ExerciseNameCell.self, forCellReuseIdentifier: String(describing: ExerciseNameCell.self))
    tb.delegate = self
    tb.dataSource = self
    return tb
  }()
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    ViewModel.fetchData {
      self.filtered = AppDelegate.shared.exercise
      self.tableView.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(tableView)
    view.addSubview(searchBar)

    tableView.snp.makeConstraints { (make) in
      make.left.right.bottom.equalToSuperview()
      make.top.equalTo(searchBar.snp.bottom).offset(4)
    }
    searchBar.snp.makeConstraints { (make) in
      make.left.right.equalTo(0)
      if #available(iOS 11, *) {
        let guide = self.view.safeAreaLayoutGuide
        make.top.equalTo(guide.snp.top)
      } else {
        make.top.equalTo(self.topLayoutGuide.snp.bottom)
      }
      make.height.equalTo(64)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
}
extension ViewController: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filtered.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: ExerciseNameCell
    if let aCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ExerciseNameCell.self)) as? ExerciseNameCell {
      cell = aCell
    } else {
      cell = ExerciseNameCell()
    }
    cell.config(with: filtered[indexPath.row])
    return cell 
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc = EditViewController()
    vc.selectedIndex = indexPath.row
    navigationController?.pushViewController(vc, animated: true)
  }
}
// DashboardSearchBarDelegate
extension ViewController: DashboardSearchBarDelegate {
  func didBeginEditing() {
    keyword = searchBar.searchTextField.text ?? ""
  }
  
  func didEndEditing() {
    keyword = searchBar.searchTextField.text ?? ""
    if keyword == "" {
      filtered = AppDelegate.shared.exercise
    } else {
      filtered = AppDelegate.shared.exercise.filter({$0.name.contains(keyword)})
    }
    tableView.reloadData()
  }
  
  func searchbarTextUpdating(text: String) {
    keyword = text
    filtered = AppDelegate.shared.exercise.filter({$0.name.contains(keyword)})
    tableView.reloadData()
  }
  
  func willShowKeyboardWith(height: CGFloat) {
    
  }
  
  func willHideKeyboard() {
    filtered = AppDelegate.shared.exercise
    tableView.reloadData()
  }
  
  func didDeleteSearchField() {
    keyword = ""
    filtered = AppDelegate.shared.exercise
    tableView.reloadData()
  }
  
  func didTapClose() {
    filtered = AppDelegate.shared.exercise
    tableView.reloadData()
  }
  
  
}
