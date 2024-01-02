//
//  FirstViewController.swift
//  Othello
//
//  Created by Kazuki Omori on 2023/12/01.
//

import UIKit
import GoogleMobileAds

class FirstViewController: UIViewController {
    var timeSetting: timeSetting = .none
    
    @IBOutlet weak var segment: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        Admob.shared.setInterstitial()
        segment.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        segment.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
    }
   
    func gotoFieldViewController(_ isOffline: Bool) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let FieldViewController = storyBoard.instantiateViewController(withIdentifier: "FieldViewController") as? FieldViewController else { return }
        FieldViewController.isOffline = isOffline
        FieldViewController.timeSetting = timeSetting
        FieldViewController.modalPresentationStyle = .fullScreen
        present(FieldViewController, animated: true)
    }
    
    @IBAction func tappedOffline(_ sender: Any) {
        PlayCount.shared.plusPlayCount()
        if PlayCount.shared.getPlayCount() == 5 {
            showAd(true)
            PlayCount.shared.resetPlayCount()
        }
        PlayCount.shared.plusPlayCount()
        gotoFieldViewController(true)
    }
    
    @IBAction func tappedComputer(_ sender: Any) {
        if PlayCount.shared.getPlayCount() == 5 {
            showAd(false)
            PlayCount.shared.resetPlayCount()
        }
        PlayCount.shared.plusPlayCount()
        gotoFieldViewController(false)
    }
    
    func showAd(_ isOffline: Bool) {
        guard let rewardedInterstitialAd = Admob.shared.rewardedInterstitialAd else {
            return print("Ad wasn't ready.")
          }

          rewardedInterstitialAd.present(fromRootViewController: self) {
            let reward = rewardedInterstitialAd.adReward
          }
    }
    
    @IBAction func tappedTimeSetting(_ sender: Any) {
        switch segment.selectedSegmentIndex {
        case 0:
            timeSetting = .none
        case 1:
            timeSetting = .twoMinute
        default:
            timeSetting = .tenSeconds
        }
    }
    
}
