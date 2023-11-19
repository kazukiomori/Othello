
import UIKit

class FieldViewController: UIViewController {
    let FIELD_SIZE = CGSize(width: 8, height: 8)
    var fieldStates: [[FieldStatus]] = [
        [.空,.空,.空,.空,.空,.空,.空,.空],
        [.空,.空,.空,.空,.空,.空,.空,.空],
        [.空,.空,.空,.空,.空,.空,.空,.空],
        [.空,.空,.空,.白,.黒,.空,.空,.空],
        [.空,.空,.空,.黒,.白,.空,.空,.空],
        [.空,.空,.空,.空,.空,.空,.空,.空],
        [.空,.空,.空,.空,.空,.空,.空,.空],
        [.空,.空,.空,.空,.空,.空,.空,.空]
    ]
    var turn: FieldStatus = .黒

    @IBOutlet weak var fieldCollectionView: UICollectionView! {
        didSet {
            fieldCollectionView.dataSource = self
            fieldCollectionView.delegate = self
            fieldCollectionView.register(
                UINib(nibName: "FieldCell", bundle: nil),
                forCellWithReuseIdentifier: "FieldCell")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareField()
        reloadField()
    }
    
    func reloadField() {
        DispatchQueue.main.async {
            self.fieldCollectionView.reloadData()
        }
    }
    
    func prepareField() {
        let layout = UICollectionViewFlowLayout()
        let width: CGFloat = fieldCollectionView.layer.bounds.width / FIELD_SIZE.width
        let height = width
        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        fieldCollectionView.setCollectionViewLayout(layout, animated: false)
    }
    
    func getStatus(position: Position) -> FieldStatus {
        fieldStates[position.x][position.y]
    }
    
    func getFieldsOnLine(start: Position, direction: direction) -> [(Position, FieldStatus)] {
        if let nextPosition = start.getNextPosition(direction: direction) {
            var fieldsOnLine = [(start, getStatus(position: start))] + getFieldsOnLine(start: nextPosition, direction: direction)
            return fieldsOnLine
        } else {
            return [(start, getStatus(position: start))]
        }
    }
    
    func isSetOthello(position: Position, color: Color) -> Bool {
        return direction.allCases
            .map{ getFieldsOnLine(start: position, direction: $0).map {$0.1} }
            .map { $0.isSetOthello(color: color)}
            .contains(true)
    }

}

extension FieldViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let x = Int(indexPath.row % Int(FIELD_SIZE.width))
        let y = Int(indexPath.row / Int(FIELD_SIZE.width))
        
        if !isSetOthello(position: Position(x: x, y: y)!, color: turn.color!) {
            return
        }
        
        switch turn {
        case .黒:
            fieldStates[x][y] = .黒
            turn = .白
        case .白:
            fieldStates[x][y] = .白
            turn = .黒
        default:
            break
        }
        reloadField()
    }
}

extension FieldViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(FIELD_SIZE.width * FIELD_SIZE.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let x = Int(indexPath.row % Int(FIELD_SIZE.width))
        let y = Int(indexPath.row / Int(FIELD_SIZE.width))
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FieldCell", for: indexPath) as! FieldCell
        cell.fieldView.layer.cornerRadius = cell.fieldView.frame.width / 2.0
        cell.fieldView.layer.masksToBounds = true
        cell.setStatus(fieldStates[x][y])
        cell.update()
        return cell
    }
}

extension FieldViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.layer.bounds.width / FIELD_SIZE.width
        let height = width
        return CGSize(width: width, height: height)
    }
}
