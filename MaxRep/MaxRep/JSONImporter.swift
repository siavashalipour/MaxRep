//
//  JSONImporter.swift
//  MaxRep
//
//  Created by Siavash on 13/6/18.
//  Copyright © 2018 Siavash. All rights reserved.
//

import Foundation
import SwiftyJSON

struct JSONImporter {
  
  static func getJSON() -> JSON? {
    if let path = Bundle.main.path(forResource: "ExerciseNames", ofType: "json") {
      do {
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
        let jsonObj = try JSON(data: data)
        if jsonObj != JSON.null {
          return jsonObj
        } else {
          print("Could not get json from file, make sure that file contains valid json.")
        }
      } catch let error {
        print(error.localizedDescription)
      }
    } else {
      print("Invalid filename/path.")
    }
    return nil
  }
}
