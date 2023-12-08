//
//  FirstViewController.swift
//  Othello
//
//  Created by Kazuki Omori on 2023/12/01.
//

import UIKit

class FirstViewController: UIViewController {
    
    @IBOutlet weak var segment: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        segment.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        segment.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
    }
   
    func gotoFieldViewController(_ isOffline: Bool) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let FieldViewController = storyBoard.instantiateViewController(withIdentifier: "FieldViewController") as? FieldViewController else { return }
        FieldViewController.isOffline = isOffline
        FieldViewController.modalPresentationStyle = .fullScreen
        present(FieldViewController, animated: true)
    }
    
    @IBAction func tappedOffline(_ sender: Any) {
        gotoFieldViewController(true)
    }
    
    @IBAction func tappedComputer(_ sender: Any) {
        gotoFieldViewController(false)
    }
    
}
