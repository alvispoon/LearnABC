import GoogleMobileAds

enum AdmobManager {
//  static func requestReviewIfAppropriate() {
//    SKStoreReviewController.requestReview()
//  }
  
  static let mobShowActionCount = 3
    
  

    static func requestAdsIfAppropriate(vc : UIViewController, interstitial: GADInterstitial) -> Bool {
    let defaults = UserDefaults.standard
    let bundle = Bundle.main

    
    // 2.
    var actionCount = defaults.integer(forKey: .adMobActionCount)

    // 3.
    actionCount += 1

    // 4.
    defaults.set(actionCount, forKey: .adMobActionCount)
        

    // 5.
    guard actionCount >= mobShowActionCount else {
      return false
    }
        
        print ("actionCount : \(actionCount)")
        
            if interstitial.isReady {
                print("actionCount interstitial.isReady")
                interstitial.present(fromRootViewController: vc)
              }
    // 9.
    defaults.set(0, forKey: .adMobActionCount)
    return true
  }
    
    
   
  
  
}
