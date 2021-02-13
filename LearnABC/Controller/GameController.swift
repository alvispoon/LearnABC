//
//  GameController.swift
//  LearnWord123
//f
//  Created by Alvis Poon on 26/5/2020.
//  Copyright © 2020 Alvis Poon. All rights reserved.
//
import UIKit
import AVFoundation

protocol GameControllerDelegate {

    func callHome()
    func callAds(mode: Int)
}


class GameController{
    
    var audioPlayer: AVAudioPlayer!

    var delegate: GameControllerDelegate?
    
    var gameView: UIView!
    var popupVictory: PopupVictory!
    var hud:HUDView! {
        didSet {
          //connect the Hint button
          hud.homeButton.addTarget(self, action: Selector("actionHome"), for:.touchUpInside)
          hud.homeButton.isEnabled = true
        }
    }
    
    var points:Int = 0 {
           didSet {
               //custom setter - keep the score positive
               points = max(points, 0)
           }
     }

    var mode = UserDefaults.standard.integer(forKey: "Mode")
    var currentLetter = 0
    
    private var targets = [ResultView]()
    private var tiles = [TileView]()
    private var imWord: UIImage!
    var wordButtonImageView: UIImageView!
    var randomCharIndex : Int = 0
    var words : NSArray = []
    
    var completedWord : [Bool] = []
    var autoCompleteWord : [Bool] = []
    var numTestedChar = [[1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
                         [1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 6, 6],
                         [1, 2, 3, 4, 5, 5, 5, 5, 6, 7, 8, 9, 10, 11, 12, 13]]
    
    let synthesizer = AVSpeechSynthesizer()
    var word : String = ""
    var passed : Int = 0
    
    var learnCount : Int = 0
    
    var popupView:PopupLevel! {
      didSet {
        //connect the Hint button
       // popupView.hintButton.addTarget(self, action: Selector("actionHint"), for:.touchUpInside)
        //hud.hintButton.isEnabled = false
      }
    }
    var level: Level!{
           didSet {
               self.randomCharIndex = randomNumber(minX:0, maxX:UInt32(level.words.count-1))
                      self.words = level.words[randomCharIndex]
                      for index in 1...self.words.count {
                          self.completedWord.append(false)
                      }
           }
       }
    
    var levelNo: Int = 0{
        didSet{
            self.words = level.words[levelNo]
            self.completedWord.removeAll()
            for index in 1...self.words.count {
                self.completedWord.append(false)
            }
        }
    }
    
    func generateAutoCompleteWord(){
        if (mode == -1){
            for index in 0...self.word.count-1 {
                
                self.autoCompleteWord.append(true)
            }
        }else{
        self.autoCompleteWord.removeAll()
        
        let numberOfTestCharacter = numTestedChar[mode][word.count-1]
        
        var numberChar : [Int] = []
        
        for index in 0...self.word.count-1 {
            numberChar.append(index)
            self.autoCompleteWord.append(true)
        }
        
        numberChar.shuffle()
        
        
        
        for index in 0...numberOfTestCharacter-1 {
            
            self.autoCompleteWord[numberChar[index]] = false
        }
        print ("self.autoCompleteWord \(self.autoCompleteWord)")
        }
    }
    

    func generateLetter () {
        mode = UserDefaults.standard.integer(forKey: "Mode")
        
        print ("Enter Generate Letter")
        print (mode)
        var randomIndex = 0
        
        if (mode != -1){
        repeat {
            randomIndex = randomNumber(minX:0, maxX:UInt32(words.count-1))
        } while (completedWord[randomIndex])

        completedWord[randomIndex] = true
        }else{
            randomIndex = learnCount
        }
        
            
        let wordPair = words[randomIndex] as! NSArray
        word = wordPair[0] as! String
        let wordPic = wordPair[1] as! String
        let wordlenth = word.count
        
        print (word)
        print (wordPic)
        
        let imageSizeW = ScreenWidth*0.8
        let imageSizeH = ScreenHeight*0.4
 
        
        let wordButtonImage = UIImage(named: "\(word).png")!
        wordButtonImageView = UIImageView(image: wordButtonImage)
        let scale = imageSizeW / wordButtonImage.size.width
        wordButtonImageView.frame = CGRect(x: ScreenWidth*0.1, y: ScreenHeight*0.1, width: wordButtonImage.size.width * scale, height:
            wordButtonImage.size.height * scale)
        let tapGetsure = UITapGestureRecognizer(target: self,
                                                action: #selector(self.speak))
        tapGetsure.numberOfTapsRequired = 1
        wordButtonImageView.gestureRecognizers = [tapGetsure]
        wordButtonImageView.isUserInteractionEnabled = true
        
        gameView.addSubview(wordButtonImageView)

        
        
        let tileSide = (ceil((ScreenWidth * 0.9 - TileMargin * CGFloat(wordlenth)) / CGFloat(wordlenth)) - TileMargin > maxTileWidth) ? maxTileWidth : ceil((ScreenWidth * 0.9 - TileMargin * CGFloat(wordlenth)) / CGFloat(wordlenth)) - TileMargin
        
        var xOffset = (ScreenWidth - (CGFloat(wordlenth) * (tileSide + TileMargin))) / 2.0
        xOffset += tileSide / 2.0
       
        targets = []
        for (index, letter) in word.enumerated() {
          if letter != " " {
            let target = ResultView(letter: letter, sideLength: tileSide*0.9)
            
            target.center = CGPoint(x:xOffset + CGFloat(index)*(tileSide + TileMargin), y:ScreenHeight/3*2)
            gameView.addSubview(target)
            targets.append(target)
          }
        }
        
        tiles = []
        for (index, letter) in word.shuffled().enumerated() {
          if letter != " " {
            print ("letter \(letter)")
            let tile = TileView(letter: letter, sideLength: tileSide*0.9)
            tile.center = CGPoint(x: xOffset + CGFloat(index)*(tileSide + TileMargin), y: ScreenHeight/6*5)
            //tile.randomize()
            tile.dragDelegate = self
            gameView.addSubview(tile)
            tiles.append(tile)
          }
        }
        
        
        
        assignAnswer()
        speak()
        
        if (mode == -1){
            addNextPrevButton()
            addSoundButton()
            spellAndSpeak()
        }
        
    }
    
    func addNextPrevButton(){
        
        let tileSide = (ceil((ScreenWidth * 0.9 - TileMargin * CGFloat(3)) / CGFloat(3)) - TileMargin > maxTileWidth) ? maxTileWidth : ceil((ScreenWidth * 0.9 - TileMargin * CGFloat(3)) / CGFloat(3)) - TileMargin
        
        var xOffset = (ScreenWidth - (CGFloat(3) * (tileSide + TileMargin))) / 2.0
        //xOffset += tileSide / 2.0
       
        
        let prevButton = ActionButton(defaultButtonImage: "prevBTN", defaultTitle: "", action: nextprevButtonHandler, level: -2, width: tileSide*0.9, height: tileSide*0.9)
        let nextButton = ActionButton(defaultButtonImage: "nextBTN", defaultTitle: "", action: nextprevButtonHandler, level: -3, width: tileSide*0.9, height: tileSide*0.9)
        
        prevButton.frame = CGRect(x: xOffset + CGFloat(0)*(tileSide + TileMargin), y: ScreenHeight/6*4.5, width: tileSide*0.9, height: tileSide*0.9)
        
        nextButton.frame = CGRect(x: xOffset + CGFloat(2)*(tileSide + TileMargin), y: ScreenHeight/6*4.5, width: tileSide*0.9, height: tileSide*0.9)
        
        //prevButton.frame = CGRect(x: buttonGroupMargin + (buttonwidth + buttonmargin)*CGFloat(j) , y: buttonGroupTop+(buttonwidth+buttonmargin)*CGFloat(i), width: buttonwidth, height: buttonwidth)
        
        
        
        gameView.addSubview(prevButton)
        gameView.addSubview(nextButton)
    }
    
    
    func addSoundButton(){
        
        let tileSide = (ceil((ScreenWidth * 0.9 - TileMargin * CGFloat(3)) / CGFloat(3)) - TileMargin > maxTileWidth) ? maxTileWidth : ceil((ScreenWidth * 0.9 - TileMargin * CGFloat(3)) / CGFloat(3)) - TileMargin
        
        var xOffset = (ScreenWidth - (CGFloat(3) * (tileSide + TileMargin))) / 2.0
        //xOffset += tileSide / 2.0
       
        
        let soundImage = UIImage(named: "speakBTN.png")!
        var soundImageView = UIImageView(image: soundImage)
        //let scale = imageSizeW / wordButtonImage.size.width
        soundImageView.frame =  CGRect(x: xOffset + CGFloat(1)*(tileSide + TileMargin), y: ScreenHeight/6*4.5, width: tileSide*0.9, height: tileSide*0.9)
        let tapGetsure = UITapGestureRecognizer(target: self,
                                                action: #selector(self.spellAndSpeak))
        tapGetsure.numberOfTapsRequired = 1
        soundImageView.gestureRecognizers = [tapGetsure]
        soundImageView.isUserInteractionEnabled = true
        
        gameView.addSubview(soundImageView)
    }
    
    @objc func nextprevButtonHandler(index: Int) {
       //switch index {
        //case PopupButtons.level:
        //playSound1(filename: "selected.wav")
        print ("index \(index)")
        
        delegate?.callAds(mode: index)
        
        //popupButtonHandlerDelegate?.levelTapped(level: index)

    }
    
    func nexPrevButton(prevNext: Int){
        if (prevNext == -2){
            learnCount = learnCount - 1
        }else{
            learnCount = learnCount + 1
        }
            if (learnCount>=self.words.count){
                learnCount = 0
            }
        if (learnCount)<0{
            learnCount = self.words.count-1
        }
        self.clearBoard()
        self.generateLetter()
    }
    
    
    @objc func spellAndSpeak(){
        speak_perword()
        speak()
    }
    
    @objc func speak_perword(){
        print ("Click image view")
               
        var utteranceArray:[AVSpeechUtterance]  = []
        
        for char in word {
            let utterance = AVSpeechUtterance(string: String(char))
            utterance.voice = AVSpeechSynthesisVoice(language: "en-UK")
            utterance.voice = AVSpeechSynthesisVoice(identifier: "Karen")
            utterance.rate = 0.3
            utteranceArray.append(utterance)
        }
        for utterance in utteranceArray{
            
            synthesizer.speak(utterance)
        }
                
    }

    
    
    @objc func speak(){
        print ("Click image view")
                
                let utterance = AVSpeechUtterance(string: word)
                utterance.voice = AVSpeechSynthesisVoice(language: "en-UK")
                
                utterance.voice = AVSpeechSynthesisVoice(identifier: "Karen")
                //utterance.rate = Float(0.8)
                //utterance.pitchMultiplier = 0.5
                //utterance.preUtteranceDelay = 0
                utterance.volume = 1
                synthesizer.speak(utterance)
            }
        
    
    func generateDummyAnswer()->Character{
        var letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        letters = letters.replacingOccurrences(of: "[\(word)]", with: "", options: [.regularExpression, .caseInsensitive])
        return letters.randomElement()!
    }
    
    func assignAnswer(){
        generateAutoCompleteWord()
        print (tiles.count)
        var counter = 0
        //if mode == Mode.Easy{
            for targetView in targets {
                if (autoCompleteWord[counter]){
                for tileView in tiles{
                    if (tileView.isUserInteractionEnabled){
                    if targetView.letter == tileView.letter {
                        
                        if (mode != -1){
                        let newTile = tileView.clone(letter: generateDummyAnswer())
                        
 //                       print (generateDummyAnswer())
                        
                        tiles.append(newTile)
                        gameView.addSubview(newTile)
                        
                        
                        }
                        self.placeTile(tileView: tileView, targetView: targetView)
                        break
                    }
                    }
                }
                }
                counter += 1
          //  }
        }
        print (tiles.count)
    }
    
    
    func placeTile(tileView: TileView, targetView: ResultView) {

        targetView.isMatched = true
        
        tileView.isUserInteractionEnabled = false
        //tileView.transform = targetView.transform
        print ("start animate")
        UIView.animate(withDuration: 0.35, delay: 0.00, options: UIView.AnimationOptions.curveEaseOut
        ,
                     animations: {
                        tileView.transform = targetView.transform
                        //tileView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                        tileView.center = targetView.center
                       // tileView.transform = targetView.transform
                       // tileView.transform = CGAffineTransform(scaleX: 5, y: 5)
                        
                      },
                      completion: {
                        (value:Bool) in
                        targetView.isHidden = true
                        print ("stop animate")
                      })
        
    }

    //clear the tiles and targets
    func clearBoard() {
        
        tiles.removeAll(keepingCapacity: false)
        targets.removeAll(keepingCapacity: false)
        
      for view in gameView.subviews  {
        print (view)
        view.removeFromSuperview()
      }
    }
    
    
    func checkForSuccess() {
        print ("Check for Success")
      for targetView in targets {
        //no success, bail out
        if !targetView.isMatched {
          return
        }
      }
        playSound1(filename: "success.wav")
        passed += 1
        print (completedWord)
       // AppStoreReviewManager.requestReviewIfAppropriate()
        
        //AdmobManager.showAdsIfAppropriate()
//
//        let trophyImage = UIImage(named: "trophy.png")!
//        let trophyImageView = UIImageView(image: trophyImage)
//        let scale = ScreenWidth*0.1 / trophyImage.size.width
//        trophyImageView.frame = CGRect(x: , y: ScreenHeight*0.05, width: trophyImage.size.width * scale, height:
//            trophyImage.size.height * scale)
        
        UIView.transition(with: self.wordButtonImageView,
                          duration: 3.0,
                          options: [.transitionCrossDissolve, .curveEaseIn],
                          animations: {
                            self.wordButtonImageView.image = UIImage(imageLiteralResourceName: "trophy")
                            self.wordButtonImageView.frame.origin.x = ScreenWidth*0.7
                            self.wordButtonImageView.frame.origin.y = ScreenHeight*0.05
                            self.wordButtonImageView.frame.size.width = ScreenWidth*0.1
                            self.wordButtonImageView.frame.size.height = ScreenWidth*0.1
                            self.wordButtonImageView.alpha = 0

        }, completion: {
              (value:Bool) in
            self.points += 1
            self.hud.gamePoints.text = "\(self.points)"
            })

        
        UIView.animate(withDuration: 3,
                     delay: 1,
                     options: [.curveEaseIn],
                     animations: {
                        for tile in self.tiles{
                            tile.frame.origin.x = ScreenWidth * 2
                        }
                     }, completion: {_ in self.delegate?.callAds(mode: self.mode)})
        

    }
    
    func gotoNext(){
                wordButtonImageView.removeFromSuperview()
                if completedWord.contains(false){
                    self.clearBoard()
                    self.generateLetter()
                }
                else{
                    //AppStoreReviewManager.requestReviewIfAppropriate()
                    playSound1(filename: "levelup.wav")
                    print ("level completed")
                    popupVictory = PopupVictory(frame: CGRect(x: 0, y: 0, width: ScreenWidth*0.8, height: ScreenHeight*0.8), words: words, score: points )
                    popupVictory.popupVictoryButtonHandlerDelegate = self
                    gameView.addSubview(popupVictory)
        
                    popupVictory.center = CGPoint(x: ScreenWidth/2, y: ScreenHeight/2)
                    //popupView.isHidden = false
                }
                
    }

    @objc func actionHome() {
        print("HOME!")
        playSound1(filename: "selected.wav")
        delegate?.callHome()
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


extension GameController:TileDragDelegateProtocol {
  //a tile was dragged, check if matches a target
  func tileView(tileView: TileView, didDragToPoint point: CGPoint) {
    var resultView: ResultView?
    for tv in targets {
      if tv.frame.contains(point) && !tv.isMatched {
        resultView = tv
        break
      }
    }
    if let targetView = resultView {
        if targetView.letter == tileView.letter {
          print("Success! You should place the tile here!")
          self.placeTile(tileView: tileView, targetView: targetView)
          print("Check if the player has completed the phrase")
            self.checkForSuccess()
            
        } else {
        print("Failure. Let the player know this tile doesn't belong here")

      }
    }

    
  }
}




extension GameController: PopupVictoryButtonHandlerDelegate {
    
    func levelTapped() {
        playSound1(filename: "selected.wav")
        print ("LevelTapped")
        popupVictory.removeFromSuperview()
        //popupView.isHidden = false
        delegate?.callHome()
    }

    func nextTapped() {
        print ("Next")
        playSound1(filename: "selected.wav")
        let level = levelNo + 1
        self.clearBoard()
        self.levelNo = level
        self.generateLetter()
    }

    func retryTapped() {
        print ("retry")
        playSound1(filename: "selected.wav")
        //self.popupVictory.removeFromSuperview()
        let level = levelNo
        self.clearBoard()
        self.levelNo = level
        self.generateLetter()
    }

}


