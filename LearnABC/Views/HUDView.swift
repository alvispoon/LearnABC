//
//  HUDView.swift
//  LearnWord123
//
//  Created by Alvis Poon on 3/6/2020.
//  Copyright © 2020 Alvis Poon. All rights reserved.
//
import UIKit

class HUDView: UIView {
  
    var gamePoints: UILabel
    var homeButton: UIButton!


    
  //this should never be called
  required init(coder aDecoder:NSCoder) {
    fatalError("use init(frame:")
  }

    init(frame:CGRect, mode: Int) {
    //the dynamic points label
    

    //"points" label
//    var pointsLabel = UILabel(frame: CGRect(x: ScreenWidth-120, y: ScreenHeight*0.05, width: 100, height: ScreenHeight*0.05))
//    pointsLabel.backgroundColor =  UIColor.clear
//    pointsLabel.text = " Points:"
//    self.addSubview(pointsLabel)
    
    let trophyImage = UIImage(named: "trophy.png")!
    let trophyImageView = UIImageView(image: trophyImage)
    let scale = ScreenWidth*0.1 / trophyImage.size.width
    trophyImageView.frame = CGRect(x: ScreenWidth*0.7, y: ScreenHeight*0.05, width: trophyImage.size.width * scale, height:
        trophyImage.size.height * scale)
    
    
    
    self.gamePoints = UILabel(frame: CGRect(x: ScreenWidth*0.7 + trophyImageView.frame.size.width + 5, y: ScreenHeight*0.05, width: ScreenWidth*0.25 - trophyImageView.frame.size.width - 5, height: trophyImageView.frame.size.height))
    gamePoints.font = UIFont(name:"Arial-BoldMT" , size: 100.0)!
    gamePoints.textColor = .black
    gamePoints.textAlignment = .left
    gamePoints.text = "0"
    gamePoints.minimumScaleFactor = 0.1    //or whatever suits your need
    gamePoints.adjustsFontSizeToFitWidth = true
    gamePoints.lineBreakMode = .byClipping
    gamePoints.numberOfLines = 0
   
   
        
        let homeImage = UIImage(named: "home.png")!
              
              let scale1 = ScreenWidth*0.1 / homeImage.size.width

        self.homeButton = UIButton()
        homeButton.setBackgroundImage(homeImage, for: .normal)
        homeButton.frame = CGRect(x: ScreenWidth*0.05, y: ScreenHeight*0.05, width: homeImage.size.width * scale, height:
        homeImage.size.height * scale)
        
    
    
    super.init(frame:frame)
        if (mode != -1){
            self.addSubview(trophyImageView)
        
            self.addSubview(gamePoints)
            
        }
    self.addSubview(homeButton)
    //self.isUserInteractionEnabled = false

  }
    
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
         //1 let touches through and only catch the ones on buttons
        let hitView = super.hitTest(point, with: event)
      //2
      if hitView is UIButton {
        return hitView
      }
        
      //3
      return nil
    }

}

