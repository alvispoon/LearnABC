//
//  Tiles.swift
//  LearnWord123
//
//  Created by Alvis Poon on 26/5/2020.
//  Copyright © 2020 Alvis Poon. All rights reserved.
//

import UIKit

protocol TileDragDelegateProtocol {
  func tileView(tileView: TileView, didDragToPoint: CGPoint)
}


class TileView:UIImageView {

var letter: Character

    private var xOffset: CGFloat = 0.0
    private var yOffset: CGFloat = 0.0
    private var tempTransform: CGAffineTransform = CGAffineTransform.identity

    var dragDelegate: TileDragDelegateProtocol?

    var sideLength: CGFloat = 0.0

//4 this should never be called
required init(coder aDecoder:NSCoder) {
  fatalError("use init(letter:, sideLength:")
}

init(letter:Character, sideLength:CGFloat) {
  self.letter = letter
    self.sideLength = sideLength
  
  let image = UIImage(named: "blockY1")!
  
  super.init(image:image)
  
  let scale = sideLength / image.size.width
  self.frame = CGRect(x: 0, y: 0, width: image.size.width * scale, height: image.size.height * scale)
  
  let letterLabel = UILabel(frame: self.bounds)
  letterLabel.textAlignment = NSTextAlignment.center
  letterLabel.textColor = UIColor.black
  letterLabel.backgroundColor = UIColor.clear
  letterLabel.text = letter.uppercased()
  letterLabel.font = UIFont(name: "Verdana-Bold", size: 100.0*scale)
  self.addSubview(letterLabel)
  
  self.isUserInteractionEnabled = true
  
  self.layer.shadowColor = UIColor.black.cgColor
  self.layer.shadowOpacity = 0
  self.layer.shadowOffset = CGSize(width: 10, height: 10)
  self.layer.shadowRadius = 15.0
  self.layer.masksToBounds = false
      
  let path = UIBezierPath(rect: self.bounds)
  self.layer.shadowPath = path.cgPath

}
    
    
    func randomize() {
      let rotation = CGFloat(randomNumber(minX:0, maxX:50)) / 100.0 - 0.2
      self.transform = CGAffineTransform(rotationAngle: rotation)

        let yOffset = CGFloat(randomNumber(minX: 0, maxX: 10) - 10)
        self.center = CGPoint(x: self.center.x, y: self.center.y+yOffset)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first as? UITouch {
            let point = touch.location(in: self.superview)
            xOffset = point.x - self.center.x
          yOffset = point.y - self.center.y
        }
        self.layer.shadowOpacity = 0.8
        tempTransform = self.transform
        self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first as? UITouch {
          let point = touch.location(in: self.superview)
            self.center = CGPoint(x: point.x - xOffset, y: point.y - yOffset)
            
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchesMoved(touches, with: event)
        dragDelegate?.tileView(tileView: self, didDragToPoint: self.center)
        self.layer.shadowOpacity = 0.0
        self.transform = tempTransform
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.transform = tempTransform
        self.layer.shadowOpacity = 0.0
    }

    func clone(letter: Character) -> TileView{
        let tile = TileView(letter: letter, sideLength: sideLength)
        tile.center = self.center
        tile.dragDelegate = self.dragDelegate
                
        return tile
    }
    
}

