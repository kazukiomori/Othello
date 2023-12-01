//
//  FirstViewController.swift
//  Othello
//
//  Created by Kazuki Omori on 2023/12/01.
//

import UIKit

class FirstViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
   
    @IBAction func tappedOffline(_ sender: Any) {
        let nextViewController = FieldViewController()
        nextViewController.isOffline = true
        navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func tappedComputer(_ sender: Any) {
        let nextViewController = FieldViewController()
        nextViewController.isOffline = true
        navigationController?.pushViewController(nextViewController, animated: true)
    }
    
}
