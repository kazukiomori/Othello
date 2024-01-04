
import Foundation

enum FieldStatus: Equatable {
    case 空
    case 黒
    case 白
    case 置けるマス
    
    var color: Color? {
        switch self {
        case .空: return nil
        case .黒: return .黒
        case .白: return .白
        default: return nil
        }
    }
    
    var reverseTurn: FieldStatus? {
        switch self {
        case .黒: return .白
        case .白: return .黒
        case .空: return nil
        default: return nil
        }
    }
}

enum Color: Equatable {
    case 黒
    case 白
    
    var reverseColor: Color {
        switch self {
        case .黒: return .白
        case .白: return .黒
        }
    }
    
    var status: FieldStatus {
        switch self {
        case .黒: return .黒
        case .白: return .白
        }
    }
}

enum direction: CaseIterable {
    case 上
    case 右上
    case 右
    case 右下
    case 下
    case 左下
    case 左
    case 左上
    
    var dx: Int {
        switch self {
        case .右上, .右, .右下:
            return 1
        case .上, .下:
            return 0
        case .左上, .左, .左下:
            return -1
        }
    }
    
    var dy: Int {
        switch self {
        case .左上, .上, .右上:
            return -1
        case .左, .右:
            return 0
        case .左下, .下, .右下:
            return 1
        }
    }
}
