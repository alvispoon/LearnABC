//
//  ViewController.swift
//  LearnWord123
//
//  Created by Alvis Poon on 26/5/2020.
//  Copyright © 2020 Alvis Poon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let controller:GameController
    
    
    
    required init?(coder aDecoder: NSCoder) {
      controller = GameController()
      super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        let gameView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
        self.view.addSubview(gameView)
        controller.gameView = gameView
        controller.level = Level()
        //controller.generateLetter()
        //controller.gameView.alpha = 0.5
        controller.delegate = self
        
        controller.gameView.backgroundColor = .white
        
        let hudView = HUDView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
        self.view.addSubview(hudView)
        controller.hud = hudView


        
        let levelView = PopupLevel(frame: CGRect(x: 0, y: 0, width: ScreenWidth*0.8, height: ScreenHeight*0.8))
        self.view.addSubview(levelView)
        levelView.center = CGPoint(x: ScreenWidth/2, y: ScreenHeight/2)
        levelView.popupButtonHandlerDelegate = self
        controller.popupView = levelView
        levelView.isHidden = false
        //levelView.isHidden = true
        //controller.levelPopup = levelView

        
//        let modeView = PopupMode(frame: CGRect(x: 0, y: 0, width: ScreenWidth*0.8, height: ScreenHeight*0.8))
//        modeView.center = CGPoint(x: ScreenWidth/2, y: ScreenHeight/2)
//        modeView.popupModeButtonHandlerDelegate = self
//         self.view.addSubview(modeView)
//
        
        
    }


}


extension ViewController:  GameControllerDelegate{
    func callHome() {
        self.dismiss(animated: true, completion: nil)
    }
}



extension ViewController: PopupButtonHandlerDelegate {
    
    func levelTapped(level: Int) {
        //sceneManagerDelegate?.presentLevelScene()
        self.controller.popupView.isHidden = true
        controller.gameView.alpha = 1
        self.controller.levelNo = level
        self.controller.clearBoard()
        self.controller.generateLetter()
        //print ("LevelTapped")
        
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

