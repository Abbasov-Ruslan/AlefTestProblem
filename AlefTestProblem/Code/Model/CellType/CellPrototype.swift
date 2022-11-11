//
//  CellType.swift
//  AlefTestProblem
//
//  Created by Ruslan Abbasov on 03.11.2022.
//

import Foundation

protocol CellTypeProtocol: Hashable, Identifiable {
}

protocol CellIdentifierProtocol {
    var cellIdentifieer: String { get }
}

class CellPrototype: CellTypeProtocol, CellIdentifierProtocol {
    public var cellIdentifieer: String = "CellPrototype"

    public var prototypeId = UUID()

    public static func == (lhs: CellPrototype, rhs: CellPrototype) -> Bool {
        return lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

class LabelCellPrototype: CellPrototype {
    public var labelText: String = ""

    init(labelText: String) {
        super.init()
        self.labelText = labelText
        self.cellIdentifieer = "LabelTableViewCell"
    }
}

class TextfieldCellPrototype: CellPrototype {
    public var subtitileText: String = ""

    init(subtitileText: String) {
        super.init()
        self.subtitileText = subtitileText
        self.cellIdentifieer = "TextFieldTableViewCell"
    }
}

class LabelButtonCellPrototype: CellPrototype {
    override init() {
        super.init()
        self.cellIdentifieer = "LabelButtonTableViewCell"
    }
}

class TextfieldButtonCellPrototype: CellPrototype {
    public var subtitileText: String = ""
    public var text: String = ""

    init(subtitileText: String) {
        super.init()
        self.subtitileText = subtitileText
        self.cellIdentifieer = "TextFieldButtonTableViewCell"
    }
}

class TextfieldHalfCellPrototype: CellPrototype {
    public var subtitileText: String = ""
    public var text: String = ""
    public var linkedCellId: UUID?

    init(subtitileText: String) {
        super.init()
        self.subtitileText = subtitileText
        self.cellIdentifieer = "TextFieldHalfTableViewCell"
    }
}

class SeparatorCellPrototype: CellPrototype {
    override init() {
        super.init()
        self.cellIdentifieer = "SeparatorTableViewCell"
    }
}

class ButtonCellPrototype: CellPrototype {
    override init() {
        super.init()
        self.cellIdentifieer = "ButtonTableViewCell"
    }
}
