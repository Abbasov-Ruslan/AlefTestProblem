//
//  CellType.swift
//  AlefTestProblem
//
//  Created by Ruslan Abbasov on 03.11.2022.
//


struct LabelCell: Hashable {
    var labelText: String
}

struct TextfieldCell: Hashable {
    var subtitileText: String
}

struct LabelButtonCell: Hashable {
}

struct TextfieldButtonCell: Hashable {
    var subtitileText: String
    var index: Int
}

struct TextfieldHalfCell: Hashable {
    var subtitileText: String
    var index: Int
}

struct SeparatorCell: Hashable {
    var index: Int
}

struct ButtonCell: Hashable {
}
