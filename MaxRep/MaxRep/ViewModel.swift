//
//  ViewModel.swift
//  MaxRep
//
//  Created by Siavash on 13/6/18.
//  Copyright © 2018 Siavash. All rights reserved.
//

import Foundation
import FirebaseDatabase
import SwiftyJSON

struct ViewModel {
  
  static func fetchData(completion: @escaping () -> Void) {
    var ref: DatabaseReference!
    ref = Database.database().reference()
    ref.child(Constant.kExercise).observeSingleEvent(of: .value) { (snapshot) in
      if !snapshot.hasChildren() {
        // write for the first time
        if let names = JSONImporter.getJSON() {
          for (_,value):(String, JSON) in names[Constant.kExercise] {
            if let name = value[Constant.kName].string {
              if let item = value[Constant.kInfo].arrayObject {
                ref.child(Constant.kExercise).childByAutoId().setValue([Constant.kName:name,Constant.kInfo:item as! [NSDictionary] ])
              }
            }
          }
        }
      } else {
        for child in snapshot.children {
          if let value = (child as? DataSnapshot)?.value as? NSDictionary {
            let anExercise = Exercise.init(name: value[Constant.kName] as! String, info: value[Constant.kInfo] as! [NSDictionary], key: (child as? DataSnapshot)!.key)
            AppDelegate.shared.exercise.append(anExercise)
          }
        }
      }
      completion()
    }
  }
}
