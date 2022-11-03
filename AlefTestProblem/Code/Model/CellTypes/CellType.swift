//
//  CellType.swift
//  AlefTestProblem
//
//  Created by Ruslan Abbasov on 03.11.2022.
//

import UIKit
import Combine

public struct LabelCell: Hashable {
    var labelText: String
}

public struct TextfieldCell: Hashable {
    var subtitileText: String
}

public struct LabelButtonCell: Hashable {
}

public struct TextfieldButtonCell: Hashable {
    var subtitileText: String
    var index: Int
}

public struct TextfieldHalfCell: Hashable {
    var subtitileText: String
    var index: Int
}

public struct SeparatorCell: Hashable {
    var index: Int
}

public struct ButtonCell: Hashable {
}
