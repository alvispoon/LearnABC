//
//  PopupVictory.swift
//  LearnWord123
//
//  Created by Alvis Poon on 2/6/2020.
//  Copyright © 2020 Alvis Poon. All rights reserved.
//
import UIKit

protocol PopupVictoryButtonHandlerDelegate {
    func levelTapped()
    func nextTapped()
    func retryTapped()
}



struct PopupVictoryButtons {
    static let level = 0
    static let next = 1
    static let retry = 2
}


class PopupVictory: UIView {
    
    var popupVictoryButtonHandlerDelegate: PopupVictoryButtonHandlerDelegate?
  var words : NSArray = []
    
  //this should never be called
  required init(coder aDecoder:NSCoder) {
    fatalError("use init(frame:")
  }

    init(frame:CGRect, words: NSArray) {

    super.init(frame:frame)

    
    let background = UIImage(named: "redBoard2")!
    let backgroundUIView = UIImageView(image: background)
    backgroundUIView.frame = frame
    //backgroundUIView.center = CGPoint(x:ScreenWidth/2, y:ScreenHeight/2)
    self.addSubview(backgroundUIView)
    
        
        let titleLabelHeight = frame.height*0.1
    
    //"points" label
        var levelTitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width*0.8, height: titleLabelHeight))
    levelTitleLabel.textAlignment = .center
        levelTitleLabel.center = CGPoint(x:frame.width/2, y:frame.height*0.21)
    levelTitleLabel.backgroundColor =  UIColor.clear
    levelTitleLabel.text = "Level Completed"
        levelTitleLabel.font = UIFont(name:"Arial-BoldMT" , size: 100.0)!
        levelTitleLabel.textColor = .black
        levelTitleLabel.textAlignment = .center
        levelTitleLabel.text = "Level Completed"
        levelTitleLabel.minimumScaleFactor = 0.1    //or whatever suits your need
        levelTitleLabel.adjustsFontSizeToFitWidth = true
        levelTitleLabel.lineBreakMode = .byClipping
        levelTitleLabel.numberOfLines = 0

    self.addSubview(levelTitleLabel)
    
    print (levelTitleLabel.frame)
    
        
        for i in 0...words.count-1{
            let wordPair = words[i] as! NSArray
            let word = wordPair[0] as! String
            
            let wordLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width*0.75, height: titleLabelHeight*0.7))
            wordLabel.textAlignment = .center
            wordLabel.center = CGPoint(x:frame.width/2, y:frame.height*0.21 + (levelTitleLabel.frame.height*1.1)*CGFloat(i+1))
            wordLabel.backgroundColor =  UIColor.clear
            wordLabel.text = "\(i+1). \(word.uppercased())"
                wordLabel.font = UIFont(name:"Arial-BoldMT" , size: 100.0)!
                wordLabel.textColor = .black
                wordLabel.textAlignment = .left
                
                wordLabel.minimumScaleFactor = 0.1    //or whatever suits your need
                wordLabel.adjustsFontSizeToFitWidth = true
                wordLabel.lineBreakMode = .byClipping
                wordLabel.numberOfLines = 0
            
            
            
            
            
            self.addSubview(wordLabel)
            
        }
        
        
        
    
    
        let buttonwidth = frame.width * 0.2
        
        
        let buttonGroupMargin = frame.width*0.1
        var counter = 0
        
        let BackButton = UIButton()
            //BackButton.setTitle("Back", for: .normal)
             //BackButton.titleLabel?.font = UIFont(name:"Baskerville-SemiBoldItalic" , size: 40.0)!
             BackButton.setBackgroundImage(UIImage(named: "home"), for: .normal)
             BackButton.alpha = 1
            BackButton.addTarget(self, action:#selector(self.actionBack), for: .touchUpInside)
        BackButton.frame = CGRect(x: frame.width/3 - buttonwidth , y: frame.height*0.8, width: buttonwidth, height: buttonwidth)
        self.addSubview(BackButton)
        
        let PlayAgainButton = UIButton()
            //PlayAgainButton.setTitle("Play Again", for: .normal)
             //PlayAgainButton.titleLabel?.font = UIFont(name:"Baskerville-SemiBoldItalic" , size: 40.0)!
             PlayAgainButton.setBackgroundImage(UIImage(named: "reload"), for: .normal)
             PlayAgainButton.alpha = 1
            PlayAgainButton.addTarget(self, action:#selector(self.actionPlayAgain), for: .touchUpInside)
        PlayAgainButton.frame = CGRect(x: frame.width*0.4 , y: frame.height*0.8, width: buttonwidth, height: buttonwidth)
        self.addSubview(PlayAgainButton)
       
        let NextLevelButton = UIButton()
                   ////NextLevelButton.setTitle("Next Level", for: .normal)
                    NextLevelButton.titleLabel?.font = UIFont(name:"Baskerville-SemiBoldItalic" , size: 40.0)!
                    NextLevelButton.setBackgroundImage(UIImage(named: "next"), for: .normal)
                    NextLevelButton.alpha = 1
                   NextLevelButton.addTarget(self, action:#selector(self.actionNextLevel), for: .touchUpInside)
               NextLevelButton.frame = CGRect(x: frame.width/3*2 , y: frame.height*0.8, width: buttonwidth, height: buttonwidth)
               self.addSubview(NextLevelButton)
        

  }




    
    
    @objc func actionBack() {
      print("Back!")
        
        popupVictoryButtonHandlerDelegate?.levelTapped()
    }

    @objc func actionPlayAgain() {
      print("PlayAgain!")
        popupVictoryButtonHandlerDelegate?.retryTapped()
    }
    
    @objc func actionNextLevel() {
      print("Next!")
        popupVictoryButtonHandlerDelegate?.nextTapped()
    }
    
    
}
