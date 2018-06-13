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
  
  private lazy var tableView: UITableView = {
    let tb = UITableView()
    tb.allowsSelection = true
    tb.register(ExerciseNameCell.self, forCellReuseIdentifier: String(describing: ExerciseNameCell.self))
    tb.delegate = self
    tb.dataSource = self
    return tb
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(tableView)
    tableView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    var ref: DatabaseReference!
    ref = Database.database().reference()
    ref.child("Exercise").observeSingleEvent(of: .value) { (snapshot) in
      if !snapshot.hasChildren() {
        // write for the first time
        if let names = JSONImporter.getJSON() {
          for (_,value):(String, JSON) in names["Exercise"] {
            if let name = value["name"].string {
              if let item = value["info"].arrayObject {
                ref.child("Exercise").childByAutoId().setValue(["name":name,"info":item as! [NSDictionary] ])
              }
            }
          }
        }
      } else {
        for child in snapshot.children {
          if let value = (child as? DataSnapshot)?.value as? NSDictionary {
            let anExercise = Exercise.init(name: value["name"] as! String, info: value["info"] as! [NSDictionary], key: (child as? DataSnapshot)!.key)
            AppDelegate.shared.exercise.append(anExercise)
          }
        }
        self.tableView.reloadData()
      }
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
    return AppDelegate.shared.exercise.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: ExerciseNameCell
    if let aCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ExerciseNameCell.self)) as? ExerciseNameCell {
      cell = aCell
    } else {
      cell = ExerciseNameCell()
    }
    cell.config(with: AppDelegate.shared.exercise[indexPath.row])
    return cell 
  }
}

