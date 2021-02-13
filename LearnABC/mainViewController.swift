//
//  mainViewController.swift
//  LearnWord123
//
//  Created by Alvis Poon on 9/6/2020.
//  Copyright © 2020 Alvis Poon. All rights reserved.
//

import UIKit
import AVFoundation

class mainViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer!

    @IBOutlet weak var menu1: UIStackView!
    @IBOutlet weak var menu2: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menu2.isHidden = true
    }
    let defaults = UserDefaults.standard
    
//    @IBAction func easyMode(_ sender: Any) {
//        defaults.set(0, forKey: "Mode")
//        print ("PerformSegus")
//        self.performSegue(withIdentifier: "toGameVC", sender: sender)
//    }
    @IBAction func selectLearnTest(_ sender: Any) {
        let clickedButton = sender as! UIButton
        playSound1(filename: "selected.wav")
        if (clickedButton.tag == 0){
            print ("clickedButton.tag \(clickedButton.tag)")
            defaults.set(-1, forKey: "Mode")
            self.performSegue(withIdentifier: "toGameVC", sender: nil)
        }else{
            menu1.isHidden = true
            menu2.isHidden = false
        }
    }
    
    @IBAction func clickEasyMode(_ sender: Any) {
        let clickedButton = sender as! UIButton
        playSound1(filename: "selected.wav")
        
        defaults.set(clickedButton.tag, forKey: "Mode")
        print (clickedButton.tag)
        menu1.isHidden = false
        menu2.isHidden = true
                self.performSegue(withIdentifier: "toGameVC", sender: sender)
    }
    
    
     func playSound1 (filename : String){
         let path = Bundle.main.path(forResource: filename, ofType: nil)!
         let url = URL(fileURLWithPath: path)

         do {
             //create your audioPlayer in your parent class as a property
             audioPlayer = try AVAudioPlayer(contentsOf: url)
             audioPlayer.play()
         } catch {
             print("couldn't load the file")
         }
     }

}
