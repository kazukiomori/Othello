
import Foundation

enum FieldStatus: Equatable {
    case 空
    case 黒
    case 白
    
    var color: Color? {
        switch self {
        case .空: return nil
        case .黒: return .黒
        case .白: return .白
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
            return 1
        case .左, .右:
            return 0
        case .左下, .下, .右下:
            return -1
        }
    }
}
