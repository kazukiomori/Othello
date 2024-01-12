
import UIKit
import GoogleMobileAds

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
    
    var previousFields: [[FieldStatus]] = [[]]
    var turn: FieldStatus = .黒
    
    var whiteCount: Int = 2
    var blackCount: Int = 2
    
    var retryFlag = true
    
    var isOffline = true
    
    var timeSetting: timeSetting = .none

    var blackTimer: Timer = Timer()
    var whiteTimer: Timer = Timer()
    var blackSettingTime: TimeInterval = 0
    var whiteSettingTime: TimeInterval = 0
    
    var blackCounting = true
    var whiteCounting = false
    
    func startNewGameAction() -> (() -> Void) {
        { [weak self] in self?.resetField()
            self?.finishTimer()
            if PlayCount.shared.getPlayCount() == 5 {
                self?.showAd()
                PlayCount.shared.resetPlayCount()
            }
            PlayCount.shared.plusPlayCount()
        }
    }
    func backToHomeAction() -> (() -> Void) {
        { self.dismiss(animated: true, completion: nil)
            self.finishTimer()
            self.resetField()
        }
    }
    func cancelButtonAction() -> (() -> Void) {{ return }}
    @IBOutlet weak var whiteUserBack: UIView!
    @IBOutlet weak var whiteBackHeight: NSLayoutConstraint!
    @IBOutlet weak var whiteUser: UIView!
    @IBOutlet weak var whiteUserTurnBar: UIView!
    @IBOutlet weak var whiteCountLabel: UILabel!
    @IBOutlet weak var whiteTimerLabel: UILabel!
    @IBOutlet weak var blackUser: UIView!
    @IBOutlet weak var blackUserTurnBar: UIView!
    @IBOutlet weak var blackCountLabel: UILabel!
    @IBOutlet weak var blackTimerLabel: UILabel!
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        prepareUser()
        prepareTimer()
        reloadField()
        manageTurnBar(turn: turn)
    }
    
    func reloadField() {
        // 置けるますの色を変える
        updateNextSetColor()
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
    
    func prepareUser() {
        whiteUserBack.backgroundColor = .black
        whiteUser.layer.cornerRadius = blackUser.frame.width / 2.0
        whiteUser.layer.masksToBounds = true
        whiteUser.backgroundColor = .white
        whiteCountLabel.text = String(whiteCount)
        blackUser.layer.cornerRadius = blackUser.frame.width / 2.0
        blackUser.layer.masksToBounds = true
        blackUser.backgroundColor = .black
        blackCountLabel.text = String(blackCount)
    }
    
    func prepareTimer() {
        switch timeSetting {
        case .none:
            whiteTimerLabel.isHidden = true
            blackTimerLabel.isHidden = true
        case .twoMinute:
            whiteSettingTime = 120.0
            blackSettingTime = 120.0
            let whiteMinutes = Int(whiteSettingTime) / 60
            let whiteSeconds = Int(whiteSettingTime) % 60
            let blackMinutes = Int(blackSettingTime) / 60
            let blackSeconds = Int(blackSettingTime) % 60
            whiteTimerLabel.text = String(format: "%02d:%02d", whiteMinutes, whiteSeconds)
            blackTimerLabel.text = String(format: "%02d:%02d", blackMinutes, blackSeconds)
        default:
            whiteSettingTime = 10.0
            blackSettingTime = 10.0
            let whiteSeconds = Int(whiteSettingTime) % 60
            let blackSeconds = Int(blackSettingTime) % 60
            whiteTimerLabel.text = String(format: "%02d秒", whiteSeconds)
            blackTimerLabel.text = String(format: "%02d秒", blackSeconds)
        }
    }
    
    func updateBlackTimerLabel() {
        let minutes = Int(blackSettingTime) / 60
        let seconds = Int(blackSettingTime) % 60
        if timeSetting == .twoMinute {
            blackTimerLabel.text = String(format: "%02d:%02d", minutes, seconds)
        } else if timeSetting == .tenSeconds {
            blackTimerLabel.text = String(format: "%02d秒", seconds)
        }
    }
    
    func updateWhiteTimerLabel() {
        let minutes = Int(whiteSettingTime) / 60
        let seconds = Int(whiteSettingTime) % 60
        if timeSetting == .twoMinute {
            whiteTimerLabel.text = String(format: "%02d:%02d", minutes, seconds)
        } else if timeSetting == .tenSeconds {
            whiteTimerLabel.text = String(format: "%02d秒", seconds)
        }
        
    }
    
    @objc func updateTimerForColor() {
        let rightAction = startNewGameAction()
        let leftAction = backToHomeAction()
        switch turn {
        case .黒:
            if blackSettingTime > 0 {
                blackSettingTime -= 1
                updateBlackTimerLabel()
            } else {
                if timeSetting != .none {
                    showAlert(title: "白の勝ち。", message: "黒の持ち時間が0になりました。白の勝ちです。\nもう一度ゲームを続けますか？", rightButtonTitle: "続ける", rightButtonAction: rightAction, leftButtonTitle: "ホームに戻る", leftButtonAction: leftAction)
                    blackTimer.invalidate()
                    finishTimer()
                }
            }
        case .白:
            if whiteSettingTime > 0 {
                whiteSettingTime -= 1
                updateWhiteTimerLabel()
            } else {
                if timeSetting != .none {
                    showAlert(title: "黒の勝ち。", message: "白の持ち時間が0になりました。黒の勝ちです。\nもう一度ゲームを続けますか？", rightButtonTitle: "続ける", rightButtonAction: rightAction, leftButtonTitle: "ホームに戻る", leftButtonAction: leftAction)
                    whiteTimer.invalidate()
                    finishTimer()
                }
            }
        default:
            break
        }
    }
    
    func stopTimer() {
        if blackCounting {
            blackTimer.invalidate()
            blackCounting = false
            if timeSetting == .tenSeconds {
                blackSettingTime = 10
                DispatchQueue.main.async {
                    self.blackTimerLabel.text = String(format: "%02d秒", 10)
                }
            }
        } else {
            blackCounting = true
            blackTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimerForColor), userInfo: nil, repeats: true)
        }
        
        if whiteCounting {
            whiteTimer.invalidate()
            whiteCounting = false
            if timeSetting == .tenSeconds {
                whiteSettingTime = 10
                DispatchQueue.main.async {
                    self.whiteTimerLabel.text = String(format: "%02d秒", 10)
                }
            }
        } else {
            whiteCounting = true
            whiteTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimerForColor), userInfo: nil, repeats: true)
        }
    }
    
    func finishTimer() {
        blackTimer.invalidate()
        whiteTimer.invalidate()
        switch timeSetting {
        case .tenSeconds:
            blackSettingTime = 10
            whiteSettingTime = 10
            DispatchQueue.main.async {
                self.blackTimerLabel.text = String(format: "%02d秒", 10)
                self.whiteTimerLabel.text = String(format: "%02d秒", 10)
            }
        case .twoMinute:
            whiteSettingTime = 120.0
            blackSettingTime = 120.0
            let whiteMinutes = Int(whiteSettingTime) / 60
            let whiteSeconds = Int(whiteSettingTime) % 60
            let blackMinutes = Int(blackSettingTime) / 60
            let blackSeconds = Int(blackSettingTime) % 60
            DispatchQueue.main.async {
                self.whiteTimerLabel.text = String(format: "%02d:%02d", whiteMinutes, whiteSeconds)
                self.blackTimerLabel.text = String(format: "%02d:%02d", blackMinutes, blackSeconds)
            }
        default:
            break
        }
    }
    
    func getStatus(position: Position) -> FieldStatus {
        fieldStates[position.x][position.y]
    }
    
    func getFieldsOnLine(start: Position, direction: direction) -> [(Position, FieldStatus)] {
        if let nextPosition = start.getNextPosition(direction: direction) {
            return [(start, getStatus(position: start))] + getFieldsOnLine(start: nextPosition, direction: direction)
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
    
    func turnOthello(position: Position, color: Color) {
        var directions: [direction] = []
        direction.allCases.forEach {
            let onlins = getFieldsOnLine(start: position, direction: $0).map {$0.1}
            if onlins.isSetOthello(color: color) {
                directions.append($0)
            }
        }
        
        directions.forEach {
            let Fields = getFieldsOnLine(start: position, direction: $0)
            for (Position, FieldStatus) in Fields {
                if FieldStatus.color == color {
                    break
                } else if FieldStatus.color == color.reverseColor {
                    fieldStates[Position.x][Position.y] = color.status
                }
            }
        }
    }
    
    func getEmptyPositions() -> [Position] {
        var emptyPositions: [Position] = []

        for (rowIndex, row) in fieldStates.enumerated() {
            for (columnIndex, status) in row.enumerated() {
                if status == .空 {
                    let position = Position(x: rowIndex, y: columnIndex)!
                    emptyPositions.append(position)
                }
            }
        }
        return emptyPositions
    }
    
    func canSetStone(color: Color) -> Bool {
        let emptyPositions = getEmptyPositions()
        return emptyPositions
            .map { isSetOthello(position: $0, color: color) }
            .contains(true)
    }
    
    func isGameOver(color: Color) -> Bool {
        let emptyPositions = getEmptyPositions()
        let notFinish = emptyPositions
            .map { isSetOthello(position: $0, color: color) }
            .contains(true)
        if notFinish {
            return false
        }
        
        if retryFlag {
            retryFlag = false
            return false
        }
            return true
    }
    
    func getColorsCount() {
        var white = 0
        var black = 0
        for row in fieldStates {
            for status in row {
                if status == .白 {
                    white += 1
                } else if status == .黒 {
                    black += 1
                }
            }
        }
        whiteCount = white
        whiteCountLabel.text = String(whiteCount)
        blackCount = black
        blackCountLabel.text = String(blackCount)
    }
    
    func showAlert(title: String, message: String, rightButtonTitle: String, rightButtonAction: (() -> Void)?, leftButtonTitle: String, leftButtonAction: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let rightButton = UIAlertAction(title: rightButtonTitle, style: .default) { _ in
            rightButtonAction?()
        }
        alertController.addAction(rightButton)
        
        let leftButton = UIAlertAction(title: leftButtonTitle, style: .cancel) { _ in
            leftButtonAction?()
        }
        alertController.addAction(leftButton)
        present(alertController, animated: true)
    }
    
    func resetField() {
    fieldStates = [
        [.空,.空,.空,.空,.空,.空,.空,.空],
        [.空,.空,.空,.空,.空,.空,.空,.空],
        [.空,.空,.空,.空,.空,.空,.空,.空],
        [.空,.空,.空,.白,.黒,.空,.空,.空],
        [.空,.空,.空,.黒,.白,.空,.空,.空],
        [.空,.空,.空,.空,.空,.空,.空,.空],
        [.空,.空,.空,.空,.空,.空,.空,.空],
        [.空,.空,.空,.空,.空,.空,.空,.空]
    ]
        reloadField()
        getColorsCount()
    }
    
    func getRandomField(color: Color) -> Position? {
        let canSetFields = getFieldCanSet(color: color)
        return canSetFields.randomElement()
    }
    
    func getCanSetRandomField() -> Position? {
        var canSetFields: [Position] = []
        for i in 0..<fieldStates.count {
            for j in 0..<fieldStates[i].count {
                if fieldStates[j][i] == .置けるマス {
                    let position = Position(x: i, y: j)!
                    canSetFields.append(position)
                }
            }
        }
        return canSetFields.randomElement()
    }
    
    func getFieldCanSet(color: Color) -> [Position] {
        let emptyPositions = getEmptyPositions()
        var canSetFields: [Position] = []
        emptyPositions.forEach { emptyPosition in
            if isSetOthello(position: emptyPosition, color: color) {
                canSetFields.append(emptyPosition)
            }
        }
        return canSetFields
    }
    
    func updateNextSetColor() {
        resetNextSetColor()
        let nextSetStones = getFieldCanSet(color: turn.color!)
        nextSetStones.forEach { stone in
            fieldStates[stone.x][stone.y] = .置けるマス
        }
    }
    
    func resetNextSetColor() {
        for i in 0..<fieldStates.count {
            for j in 0..<fieldStates[i].count {
                if fieldStates[j][i] == .置けるマス {
                    fieldStates[j][i] = .空
                }
            }
        }
        print("fields:\(fieldStates)")
    }
    
    func manageTurnBar(turn: FieldStatus) {
        switch turn {
        case .白:
            whiteUserTurnBar.isHidden = false
            blackUserTurnBar.isHidden = true
        case .黒:
            whiteUserTurnBar.isHidden = true
            blackUserTurnBar.isHidden = false
        default:
            break
        }
    }
    
    func setPreviousFields() {
        previousFields = fieldStates
    }
    
    func showAd() {
        guard let rewardedInterstitialAd = Admob.shared.rewardedInterstitialAd else {
            return print("Ad wasn't ready.")
          }

          rewardedInterstitialAd.present(fromRootViewController: self) {
            let reward = rewardedInterstitialAd.adReward
          }
    }
    
    @IBAction func tappedBackToHome(_ sender: Any) {
        showAlert(title: "ホームに戻る", message: "本当にホームに戻りますか？", rightButtonTitle: "ホームに戻る", rightButtonAction: backToHomeAction(), leftButtonTitle: "キャンセル", leftButtonAction: cancelButtonAction())
    }
    
    @IBAction func tappedNewGame(_ sender: Any) {
        showAlert(title: "新規対局", message: "本当に最初から始めますか？", rightButtonTitle: "新規対局", rightButtonAction: startNewGameAction(), leftButtonTitle: "キャンセル", leftButtonAction: cancelButtonAction())
    }
}

extension FieldViewController: UICollectionViewDelegate {
    fileprivate func othelloLogicAfterSetStone(_ x: Int, _ y: Int) {
        if !isSetOthello(position: Position(x: x, y: y)!, color: turn.color!) {
            return
        }
        
        stopTimer()
        
        turnOthello(position: Position(x: x, y: y)!, color: turn.color!)
        
        switch turn {
        case .黒:
            fieldStates[x][y] = .黒
            turn = .白
        case .白:
            fieldStates[x][y] = .白
            turn = .黒
            blackUserTurnBar.isHidden = false
            
        default:
            break
        }
        manageTurnBar(turn: turn)
        reloadField()
        
        getColorsCount()
        
        let rightAction = startNewGameAction()
        let leftAction = cancelButtonAction()
        
        resetNextSetColor()
        // 次の色が置くことができるかチェックする　できないならパス　パスした色も置けないならゲーム終了
        if canSetStone(color: turn.color!) {
            updateNextSetColor()
        } else if canSetStone(color: turn.color!.reverseColor) {
            print("\(turn.color!)は置くところがありません。\(String(describing: turn.color?.reverseColor))の番です。")
            turn = (turn.color?.reverseColor.status)!
        } else {
            if whiteCount > blackCount {
                finishTimer()
                showAlert(title: "白の勝ち。", message: "\(whiteCount)対\(blackCount)で白の勝ちです。\nもう一度ゲームを続けますか？", rightButtonTitle: "続ける", rightButtonAction: rightAction, leftButtonTitle: "キャンセル", leftButtonAction: leftAction)
            } else {
                finishTimer()
                showAlert(title: "黒の勝ち。", message: "\(blackCount)対\(whiteCount)で黒の勝ちです。\nもう一度ゲームを続けますか？", rightButtonTitle: "続ける", rightButtonAction: rightAction, leftButtonTitle: "キャンセル", leftButtonAction: leftAction)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let x = Int(indexPath.row % Int(FIELD_SIZE.width))
        let y = Int(indexPath.row / Int(FIELD_SIZE.width))
        
        othelloLogicAfterSetStone(x, y)
        
        if !isOffline {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                while self.turn == .白 {
                    guard let field = self.getCanSetRandomField() else { return }
                    self.othelloLogicAfterSetStone(field.x, field.y)
                }
            }
        }
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
