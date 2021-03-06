//
//  ViewController.swift
//  LearnWord123
//
//  Created by Alvis Poon on 26/5/2020.
//  Copyright © 2020 Alvis Poon. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController,GADInterstitialDelegate {

    private let controller:GameController
    
    var interstitial: GADInterstitial!
    
    var prevNextBtnID = 0
    
    var level = Level(inputfile: "ABC.plist")
    
    required init?(coder aDecoder: NSCoder) {
      controller = GameController()
      super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        //print ("viewDidLoad")
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let mode = UserDefaults.standard.integer(forKey: "Mode")
        let file = UserDefaults.standard.string(forKey: "level")
        
        
        interstitial = createAndLoadInterstitial()
        interstitial.delegate = self
        let request = GADRequest()
        interstitial.load(request)
        
        
        
        let gameView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
        self.view.addSubview(gameView)
        controller.gameView = gameView
        controller.level = Level(inputfile: file!)
        //controller.generateLetter()
        //controller.gameView.alpha = 0.5
        controller.delegate = self
        
        controller.gameView.backgroundColor = .white
        
        let hudView = HUDView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight), mode: mode)
        self.view.addSubview(hudView)
        controller.hud = hudView


        
        if (level.wordsTitle.count > 1){
                   let levelView = PopupLevel(frame: CGRect(x: 0, y: 0, width: ScreenWidth*0.8, height: ScreenHeight*0.8))
                   levelView.popupButtonHandlerDelegate = self
                   controller.popupView = levelView
                   self.view.addSubview(levelView)
                   levelView.center = CGPoint(x: ScreenWidth/2, y: ScreenHeight/2)
                   
        }else{
            controller.gameView.alpha = 1
            self.controller.levelNo = 0
            
            self.controller.clearBoard()
            self.controller.generateLetter()
        }
        
        
        
        //levelView.isHidden = false
        //levelView.isHidden = true
        //controller.levelPopup = levelView

        
//        let modeView = PopupMode(frame: CGRect(x: 0, y: 0, width: ScreenWidth*0.8, height: ScreenHeight*0.8))
//        modeView.center = CGPoint(x: ScreenWidth/2, y: ScreenHeight/2)
//        modeView.popupModeButtonHandlerDelegate = self
//         self.view.addSubview(modeView)
//
        print ("check interstitial.isReady")
        
        
        
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
     // var interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")  //testing ads
        var interstitial = GADInterstitial(adUnitID: "ca-app-pub-6628389226232597/5027669662")
      interstitial.delegate = self
      interstitial.load(GADRequest())
      return interstitial
    }

    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
      interstitial = createAndLoadInterstitial()
        //self.controller.gotoNext()
        if (prevNextBtnID > -1){
            self.controller.gotoNext()
        }else{
            self.controller.nexPrevButton(prevNext: prevNextBtnID)
        }
    }


}


extension ViewController:  GameControllerDelegate{
    func callHome() {
        
       self.dismiss(animated: true, completion: nil)
    }
    
    func callAds(mode: Int){
        prevNextBtnID = mode
        if (!AdmobManager.requestAdsIfAppropriate(vc: self, interstitial: interstitial )){
            if (mode > -1){
                self.controller.gotoNext()
            }else{
                self.controller.nexPrevButton(prevNext: mode)
            }
        }
    }
}



extension ViewController: PopupButtonHandlerDelegate {
    
    func levelTapped(level: Int) {
        //sceneManagerDelegate?.presentLevelScene()
        print (level)
        print ("Enter LevelTapped")
        
        controller.gameView.alpha = 1
        self.controller.levelNo = level
        
        self.controller.clearBoard()
        self.controller.generateLetter()
        print ("LevelTapped")
        
    }
//
//    func nextTapped() {
//        if let level = level {
//            sceneManagerDelegate?.presentGameSceneFor(level: level + 1)
//        }
//    }
//
//    func retryTapped() {
//        if let level = level {
//            sceneManagerDelegate?.presentGameSceneFor(level: level)
//        }
//    }

}



extension ViewController: PopupModeButtonHandlerDelegate {
    
    func ModeTapped(mode: Int) {
        //sceneManagerDelegate?.presentLevelScene()
        self.controller.popupView.isHidden = false
        
    }
}

