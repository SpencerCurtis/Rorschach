//
//  Grid.swift
//  Rorschach
//
//  Created by Spencer Curtis on 12/1/19.
//  Copyright © 2019 Spencer Curtis. All rights reserved.
//

import Foundation

enum Mirroring: CaseIterable {
    case none
    case horizontal
    case vertical
    case both
}

enum Shape: CaseIterable {
    case square
    case dot
}

struct Grid {
    
    var points: [[Bool]] = []
    var shape: Shape = .square
    var mirroring: Mirroring = .none
    var shouldRedrawSameGrid = false
    var size: Int {
        didSet {
            resetGrid()
        }
    }
    
    init(size: Int = 16) {
        self.size = size
        resetGrid()
    }
    
    mutating func resetGrid() {
        var points: [[Bool]] = []
        let array = Array(repeating: false, count: size)
        for _ in 0..<size {
            points.append(array)
        }
        self.points = points
    }
}
