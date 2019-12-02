//
//  RorschachView.swift
//  Rorschach
//
//  Created by Spencer Curtis on 12/1/19.
//  Copyright © 2019 Spencer Curtis. All rights reserved.
//

import UIKit


class RorschachView: UIView {
    
    var grid: Grid = Grid(size: 16) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        grid.resetGrid()
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        func addShape(in rect: CGRect) {
            switch grid.shape {
            case .dot:
                context.addEllipse(in: rect)
            case .square:
                context.addRect(rect)
            }
        }
        
        let size = rect.width / CGFloat(grid.size)
        
        let halfGridSize = grid.size / 2
        
        for nX in 0..<grid.size {
            let nX = CGFloat(nX)
            
            for nY in 0..<grid.size {
                let nY = CGFloat(nY)
                
                let random = Bool.random()
                
                guard random == true else { continue }
                
                context.setFillColor(UIColor.black.cgColor)
                
                let x = nX * size
                let y = nY * size
                
                switch grid.mirroring {
                case .none:
                    
                    grid.points[Int(nX)][Int(nY)] = true
                    
                    let ellipse = CGRect(x: x, y: y, width: size, height: size)
                    addShape(in: ellipse)
                    
                case .horizontal:
                    
                    guard Int(nX) <= halfGridSize else { continue }
                    
                    grid.points[Int(nX)][Int(nY)] = true
                    
                    let ellipse = CGRect(x: x, y: y, width: size, height: size)
                    let mirroredX = rect.width - x
                    let horizontalMirroredEllipse = CGRect(x: mirroredX - size, y: y, width: size, height: size)
                    
                    addShape(in: ellipse)
                    addShape(in: horizontalMirroredEllipse)
                    
                case .vertical:
                    
                    guard Int(nY) <= halfGridSize else { continue }
                    
                    grid.points[Int(nX)][Int(nY)] = true
                    
                    let mirroredY = rect.height - y
                    let ellipse = CGRect(x: x, y: y, width: size, height: size)
                    let verticalMirroredEllipse = CGRect(x: x, y: mirroredY - size, width: size, height: size)
                    
                    addShape(in: ellipse)
                    addShape(in: verticalMirroredEllipse)
                    
                case .both:
                    
                    guard Int(nX) <= halfGridSize &&
                        Int(nY) <= halfGridSize else { continue }
                    
                    grid.points[Int(nX)][Int(nY)] = true
                    
                    let mirroredX = rect.width - x
                    let mirroredY = rect.height - y
                    let ellipse = CGRect(x: x, y: y, width: size, height: size)
                    let horizontalMirroredEllipse = CGRect(x: mirroredX - size, y: y, width: size, height: size)
                    
                    let verticalMirroredEllipse = CGRect(x: x, y: mirroredY - size, width: size, height: size)
                    let bothMirroredEllipse = CGRect(x: mirroredX - size, y: mirroredY - size, width: size, height: size)
                    
                    addShape(in: ellipse)
                    addShape(in: verticalMirroredEllipse)
                    addShape(in: horizontalMirroredEllipse)
                    addShape(in: bothMirroredEllipse)
                }
            }
        }
        
        context.setFillColor(UIColor.white.cgColor)
        context.fillPath()
    }
    
    func addShape(shape: Shape, in rect: CGRect, context: CGContext) {
        switch shape {
        case .dot:
            context.addEllipse(in: rect)
        case .square:
            context.addRect(rect)
        }
    }
}

extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}
