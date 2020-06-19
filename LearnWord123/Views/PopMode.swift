//
//  PopupVictory.swift
//  LearnWord123
//
//  Created by Alvis Poon on 2/6/2020.
//  Copyright © 2020 Alvis Poon. All rights reserved.
//
import UIKit


protocol PopupModeButtonHandlerDelegate {
    func ModeTapped(mode: Int)
}

class PopupMode: UIView {
    
     var popupModeButtonHandlerDelegate: PopupModeButtonHandlerDelegate?
    
  //this should never be called
  required init(coder aDecoder:NSCoder) {
    fatalError("use init(frame:")
  }

    override init(frame:CGRect) {

    super.init(frame:frame)

    
    let background = UIImage(named: "redBoard")!
    let backgroundUIView = UIImageView(image: background)
    backgroundUIView.frame = frame
    //backgroundUIView.center = CGPoint(x:ScreenWidth/2, y:ScreenHeight/2)
    self.addSubview(backgroundUIView)
    
    
    //"points" label
    var levelTitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: 70))
    levelTitleLabel.textAlignment = .center
        levelTitleLabel.center = CGPoint(x:frame.width/2, y:frame.height*0.2)
    levelTitleLabel.backgroundColor =  UIColor.clear
    levelTitleLabel.font = UIFont(name:"Baskerville-SemiBoldItalic" , size: 30.0)!
    levelTitleLabel.text = "Mode"
    self.addSubview(levelTitleLabel)
    
    print (levelTitleLabel.frame)
    
        
     
        let buttonwidth = frame.width * 0.7
        let buttonheight = buttonwidth * 0.3
        let buttonmargin = (frame.height * 0.8 / CGFloat(modeType.count) ) * 0.1
        
        let buttonGroupMargin = frame.width*0.1
        var counter = 0
        for j in 0...modeType.count-1{
                
            let hintButton = ActionButton(defaultButtonImage: "menuBoard", defaultTitle: modeType[j], action: popupModeButtonHandler, level: j, width: buttonwidth, height: buttonwidth)
            hintButton.frame = CGRect(x: (frame.width-buttonwidth)/2 , y: frame.height*0.2 + (buttonheight + buttonmargin) * CGFloat(j+1), width: buttonwidth, height: buttonheight)
                    self.addSubview(hintButton)
                
        }
        

  }


        @objc func popupModeButtonHandler(index: Int) {
            //popupButtonHandlerDelegate?.levelTapped(level: index)
            print ("Play Sound")
            playSound(filename: "selected.wav")
            
            popupModeButtonHandlerDelegate?.ModeTapped(mode: index)
            let defaults = UserDefaults.standard
            defaults.set(index, forKey: "Mode")
            print (index)
            self.removeFromSuperview()
        }

    
    
}
