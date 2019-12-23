//
//  RorschachView.swift
//  Rorschach
//
//  Created by Spencer Curtis on 12/1/19.
//  Copyright © 2019 Spencer Curtis. All rights reserved.
//

import UIKit

class RorschachView: UIView {
    
    var grid: Grid = Grid() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        ImageRenderer.drawGrid(using: grid, context: context, size: rect.size)
    }
    
    func toggleDrawing(at point: CGPoint) {
        
        let itemWidth = bounds.width / CGFloat(grid.size)
        let itemHeight = bounds.height / CGFloat(grid.size)
        
        var xIndex = Int((point.x / itemWidth).rounded(.towardZero))
        var yIndex = Int((point.y / itemHeight).rounded(.towardZero))
        
        switch grid.mirroring {
        case .horizontal:
            if xIndex > grid.halfSize { xIndex = grid.size - xIndex - 1 }
        case .vertical:
            if yIndex > grid.halfSize { yIndex = grid.size - yIndex - 1 }
        case .both:
            if xIndex > grid.halfSize { xIndex = grid.size - xIndex - 1 }
            if yIndex > grid.halfSize { yIndex = grid.size - yIndex - 1 }
        default:
            break
        }
        
        grid.points[xIndex][yIndex].value.toggle()
        setNeedsDisplay()
    }
}
