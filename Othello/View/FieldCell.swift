
import UIKit

class FieldCell: UICollectionViewCell {
    
    @IBOutlet weak var fieldView: UIView!
    var status: FieldStatus = .空
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setStatus(_ status: FieldStatus) {
        self.status = status
    }
    
    func update() {
        switch status {
        case .黒:
            self.fieldView.backgroundColor = .black
        case .白:
            self.fieldView.backgroundColor = .white
        case .空:
            self.fieldView.backgroundColor = .systemGreen
        case .置けるマス:
            self.fieldView.backgroundColor = .systemBlue
        }
    }
    
}
