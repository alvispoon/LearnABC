//
//  config.swift
//  LearnWord123
//
//  Created by Alvis Poon on 26/5/2020.
//  Copyright © 2020 Alvis Poon. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

//UI Constants




struct Mode {
    static let Easy = 0
    static let Medium = 1
    static let Difficult = 2
}

let modeType = ["Easy", "Medium", "Difficult"]

let ScreenWidth = UIScreen.main.bounds.size.width
let ScreenHeight = UIScreen.main.bounds.size.height

let maxTileWidth = (ScreenHeight/6*5 - ScreenHeight/3*2) * 0.8
let TileMargin: CGFloat = 0.0


//Random number generator
func randomNumber(minX:UInt32, maxX:UInt32) -> Int {
  let result = (arc4random() % (maxX - minX + 1)) + minX
  return Int(result)
}

func playSound (filename : String){
    var audioPlayer: AVAudioPlayer!
    let path = Bundle.main.path(forResource: filename, ofType: nil)!
    let url = URL(fileURLWithPath: path)

    do {
        print (url)
        //create your audioPlayer in your parent class as a property
        audioPlayer = try AVAudioPlayer(contentsOf: url)
        audioPlayer.play()
    } catch {
        print("couldn't load the file")
    }
}
