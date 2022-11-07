//
//  CellType.swift
//  AlefTestProblem
//
//  Created by Ruslan Abbasov on 03.11.2022.
//

import Foundation

protocol CellTypeProtocol: Hashable, Identifiable {
}

class CellPrototype: CellTypeProtocol {
    static func == (lhs: CellPrototype, rhs: CellPrototype) -> Bool {
        return lhs.id == rhs.id
    }

    var prototypeId = UUID()

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

class LabelCellPrototype: CellPrototype {
    var labelText: String = ""
    init(labelText: String) {
        self.labelText = labelText
    }
}

class TextfieldCellPrototype: CellPrototype {
    var subtitileText: String = ""
    init(subtitileText: String) {
        self.subtitileText = subtitileText
    }
}

class LabelButtonCellPrototype: CellPrototype {
}

class TextfieldButtonCellPrototype: CellPrototype {
    var subtitileText: String = ""

    init(subtitileText: String) {
        self.subtitileText = subtitileText
    }
}

class TextfieldHalfCellPrototype: CellPrototype {
    var subtitileText: String = ""
    var linkedCellId: UUID?
    init(subtitileText: String) {
        self.subtitileText = subtitileText
    }
}

class SeparatorCellPrototype: CellPrototype {
}

class ButtonCellPrototype: CellPrototype {
}
