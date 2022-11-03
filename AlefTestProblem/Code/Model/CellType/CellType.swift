//
//  CellType.swift
//  AlefTestProblem
//
//  Created by Ruslan Abbasov on 03.11.2022.
//

import Foundation

//class HashableCell: Hashable {
//    var uuid = UUID()
//    static func == (lhs: HashableCell, rhs: HashableCell) -> Bool {
//        <#code#>
//    }
//
//}

protocol CellTypeProtocol: Hashable, Identifiable {
}

class CellType: CellTypeProtocol {
    static func == (lhs: CellType, rhs: CellType) -> Bool {
        return lhs.id == rhs.id
    }

    var id = UUID()

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

class LabelCell: CellType {
    var labelText: String = ""
    init(labelText: String) {
        self.labelText = labelText
    }
}

class TextfieldCell: CellType {
    var subtitileText: String = ""
    init(subtitileText: String) {
        self.subtitileText = subtitileText
    }
}

class LabelButtonCell: CellType {
}

class TextfieldButtonCell: CellType {
    var subtitileText: String = ""

    init(subtitileText: String) {
        self.subtitileText = subtitileText
    }
}

class TextfieldHalfCell: CellType {
    var subtitileText: String = ""
    init(subtitileText: String) {
        self.subtitileText = subtitileText
    }
}

class SeparatorCell: CellType {
}

class ButtonCell: CellType {
}
