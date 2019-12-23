//
//  Grid.swift
//  Rorschach
//
//  Created by Spencer Curtis on 12/1/19.
//  Copyright © 2019 Spencer Curtis. All rights reserved.
//

import UIKit

enum Colors {
    static var normal = UIColor(named: "Normal")!.cgColor
    static var inverted = UIColor(named: "Inverted")!.cgColor
}

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

struct Point {
    var value: Bool {
        didSet {
            if value {
                color = Colors.normal
            } else {
                color = Colors.inverted
            }
        }
    }
    
    private(set) var color: CGColor = UIColor.black.cgColor
}

struct Grid {
    
    var points: [[Point]] = []
    var shape: Shape = .square
    var mirroring: Mirroring = .both
    var size: Int {
        didSet {
            resetGrid()
            indexSize = size - 1
            if size % 2 != 0 {
                halfSize = size / 2
            } else {
                halfSize = size / 2 - 1
            }
        }
    }
    
    var halfSize: Int = 0
    var indexSize: Int = 0
    
    init(size: Int = 16) {
        self.size = size
        resetGrid()
    }
    
    mutating func resetGrid() {
        
        let array = Array(repeating: Point(value: false), count: size)
        
        var points: [[Point]] = Array(repeating: array, count: size)
        
        for x in 0..<size {
            for y in 0..<size {
                points[x][y].value = Bool.random()
            }
        }
        self.points = points
    }
}
