//
//  Admob.swift
//  Othello
//
//  Created by Kazuki Omori on 2024/01/02.
//

import GoogleMobileAds
import UIKit

class Admob {
    
    static let shared = Admob()
    var rewardedInterstitialAd: GADRewardedInterstitialAd?
    
    func setInterstitial() {
        GADRewardedInterstitialAd.load(withAdUnitID:"ca-app-pub-3940256099942544/6978759866",
                                       request: GADRequest()) { ad, error in
            if let error = error {
                return print("Failed to load rewarded interstitial ad with error: \(error.localizedDescription)")
            }
            
            self.rewardedInterstitialAd = ad
        }
    }
}
