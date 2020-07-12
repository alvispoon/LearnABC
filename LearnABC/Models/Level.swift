//
//  Level.swift
//  LearnWord123
//
//  Created by Alvis Poon on 26/5/2020.
//  Copyright © 2020 Alvis Poon. All rights reserved.
//

import Foundation

struct Level {
    let pointsPerLetter: Int
    let wordsTitle: [String]
    let words: [NSArray]


    

init() {
  //1 find .plist file for this level
  let fileName = "AtoZ.plist"
  let levelPath = "\(Bundle.main.resourcePath!)/\(fileName)"
    
  //2 load .plist file
  let levelDictionary: NSDictionary? = NSDictionary(contentsOfFile: levelPath)
    
  //3 validation
  assert(levelDictionary != nil, "Level configuration file not found")
    
  //4 initialize the object from the dictionary
  self.pointsPerLetter = levelDictionary!["pointsPerLetter"] as! Int
  self.words = levelDictionary!["words"] as! [NSArray]
    
    self.wordsTitle = levelDictionary!["wordsTitle"] as! [String]
}

}
