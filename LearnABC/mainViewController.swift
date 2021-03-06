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

    @IBOutlet weak var noAdsBtn: UIButton!
    @IBOutlet weak var menu0: UIStackView!
    @IBOutlet weak var menu1: UIStackView!
    @IBOutlet weak var menu2: UIStackView!
    @IBOutlet weak var mainIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menu1.isHidden = true
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
    
    func hideMenu0(){
        menu0.isHidden = true
        noAdsBtn.isHidden = true
        menu1.isHidden = false
    }
    func showMenu0(){
        menu0.isHidden = false
        noAdsBtn.isHidden = false
        menu1.isHidden = true
    }
    
    @IBAction func backtoMenu0(_ sender: Any) {
        showMenu0()
        mainIcon.image = UIImage(named: "iconLarge")
    }
    
    
    @IBAction func backtoMenu1(_ sender: Any) {
        menu1.isHidden = false
        menu2.isHidden = true
    }
    
    
    @IBAction func enterABC(_ sender: Any) {
        hideMenu0()
        mainIcon.image = UIImage(named:"ABC")
        defaults.set("ABC.plist", forKey: "level")
    }
    
    @IBAction func enterABCD(_ sender: Any) {
        hideMenu0()
        mainIcon.image = UIImage(named:"ABCD")
        defaults.set("ABCD.plist", forKey: "level")
    }
    
    
    @IBAction func enterABCDE(_ sender: Any) {
        hideMenu0()
        mainIcon.image = UIImage(named:"ABCDE")
        defaults.set("ABCDE.plist", forKey: "level")
    }
    
    @IBAction func enterABCDEF(_ sender: Any) {
        hideMenu0()
        mainIcon.image = UIImage(named:"ABCDEF")
        defaults.set("ABCDEF.plist", forKey: "level")
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
    
    @IBAction func gotoDownload(_ sender: Any) {
        //var url  = NSURL(string: "itms-apps://itunes.apple.com/app/id1024941703")
        let APPSTORE_URL = "https://apps.apple.com/app/words-puzzle-3-letters-fullver/id1540474539?l=en"
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: APPSTORE_URL)!, options: [:], completionHandler: nil)
         }
        else {
            // Earlier versions
            if UIApplication.shared.canOpenURL(URL(string: APPSTORE_URL)!) {
                UIApplication.shared.openURL(URL(string: APPSTORE_URL)!)
            }
        }
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
