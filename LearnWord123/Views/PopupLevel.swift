import UIKit
import AVFoundation

protocol PopupButtonHandlerDelegate {
    func levelTapped(level: Int)
//    func nextTapped()
//    func retryTapped()
}


class PopupLevel: UIView {
  
    
    var audioPlayer: AVAudioPlayer!
  
    var level = Level()
    let maxCol = 5
    let maxRow = 7
    
    var popupButtonHandlerDelegate: PopupButtonHandlerDelegate?

    
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
    print ("ABC")
    print (frame)
    
    //"points" label
    var levelTitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: 70))
    levelTitleLabel.textAlignment = .center
    levelTitleLabel.center = CGPoint(x:frame.width/2, y:45)
    levelTitleLabel.backgroundColor =  UIColor.clear
    levelTitleLabel.font = UIFont(name:"Baskerville-SemiBoldItalic" , size: 30.0)!
    levelTitleLabel.text = " Levels"
    //self.addSubview(levelTitleLabel)
    
    
    
//    self.isUserInteractionEnabled = false
        print (level.wordsTitle.count)
    
        let buttonwidth = (frame.width * 0.8 / CGFloat(maxCol) ) * 0.8
        let buttonmargin = (frame.width * 0.8 / CGFloat(maxCol) ) * 0.2
        
        let buttonGroupMargin = frame.width*0.1
        let buttonGroupTop = frame.width * 0.25
        
        print (buttonwidth)
        print (buttonmargin)
        
        print (buttonGroupMargin)
        
        var counter = 0
        for i in 0...maxRow-1{
            for j in 0...maxCol-1{
                if counter<level.wordsTitle.count{
                    let hintButton = ActionButton(defaultButtonImage: "blockR", defaultTitle: level.wordsTitle[counter], action: popupButtonHandler, level: counter, width: buttonwidth, height: buttonwidth)
                    print (level.wordsTitle[counter])
                    print (buttonGroupMargin + (buttonwidth + buttonmargin)*CGFloat(j))
                    hintButton.frame = CGRect(x: buttonGroupMargin + (buttonwidth + buttonmargin)*CGFloat(j) , y: buttonGroupTop+(buttonwidth+buttonmargin)*CGFloat(i), width: buttonwidth, height: buttonwidth)
                    self.addSubview(hintButton)
                }
                counter+=1
            }
        }

  }
    
    @objc func popupButtonHandler(index: Int) {
       //switch index {
        //case PopupButtons.level:
        playSound1(filename: "selected.wav")
            popupButtonHandlerDelegate?.levelTapped(level: index)
//        case PopupButtons.next:
//            popupButtonHandlerDelegate?.nextTapped()
//        case PopupButtons.retry:
//            popupButtonHandlerDelegate?.retryTapped()
       // default:
       //     break
       // }
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

    
    
    @objc func actionHint() {
      print("Help!")
    }

}

