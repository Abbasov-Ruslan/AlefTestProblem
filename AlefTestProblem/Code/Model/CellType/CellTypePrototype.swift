//
//  CellType.swift
//  AlefTestProblem
//
//  Created by Ruslan Abbasov on 03.11.2022.
//

import Foundation

protocol CellTypeProtocol: Hashable, Identifiable {
}

class CellTypePrototype: CellTypeProtocol {
    static func == (lhs: CellTypePrototype, rhs: CellTypePrototype) -> Bool {
        return lhs.id == rhs.id
    }

    var prototypeId = UUID()

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

class LabelCellPrototype: CellTypePrototype {
    var labelText: String = ""
    init(labelText: String) {
        self.labelText = labelText
    }
}

class TextfieldCellPrototype: CellTypePrototype {
    var subtitileText: String = ""
    init(subtitileText: String) {
        self.subtitileText = subtitileText
    }
}

class LabelButtonCellPrototype: CellTypePrototype {
}

class TextfieldButtonCellPrototype: CellTypePrototype {
    var subtitileText: String = ""

    init(subtitileText: String) {
        self.subtitileText = subtitileText
    }
}

class TextfieldHalfCellPrototype: CellTypePrototype {
    var subtitileText: String = ""
    var linkedCellId: UUID?
    init(subtitileText: String) {
        self.subtitileText = subtitileText
    }
}

class SeparatorCellPrototype: CellTypePrototype {
}

class ButtonCellPrototype: CellTypePrototype {
}
