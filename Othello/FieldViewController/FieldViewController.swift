//
//  ViewController.swift
//  Othello
//
//  Created by Kazuki Omori on 2023/07/01.
//

import UIKit

class FieldViewController: UIViewController {
    let FIELD_SIZE = CGSize(width: 8, height: 8)

    @IBOutlet weak var fieldCollectionView: UICollectionView! {
        didSet {
            fieldCollectionView.dataSource = self
            fieldCollectionView.delegate = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

extension FieldViewController: UICollectionViewDelegate {
    
}

extension FieldViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(FIELD_SIZE.width + FIELD_SIZE.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Bancell", for: indexPath) as! BanCell
        return cell
    }
    
    
}
