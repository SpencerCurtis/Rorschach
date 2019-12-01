//
//  RorschachView.swift
//  Rorschach
//
//  Created by Spencer Curtis on 12/1/19.
//  Copyright © 2019 Spencer Curtis. All rights reserved.
//

import UIKit

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

class RorschachView: UIView {
    
    var gridSize: CGFloat = 7
    var spacing: Bool = false
    var shape: Shape = .square
    var mirroring: Mirroring = .none
    
    var shouldRedrawSameGrid = false
    
    var previousGrid: [CGPoint] = []
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        func addShape(in rect: CGRect) {
            switch shape {
            case .dot:
                context.addEllipse(in: rect)
            case .square:
                context.addRect(rect)
            }
        }
        
        let size = rect.width / gridSize
        
        guard !shouldRedrawSameGrid else {
            for point in previousGrid {
                addShape(in: CGRect(x: point.x, y: point.y, width: size, height: size))
            }
            context.fillPath()
            shouldRedrawSameGrid = false
            return
        }
        
        var previousGrid: [CGPoint] = []
        
        for x in stride(from: 0, through: rect.width, by: size) {
            for y in stride(from: 0, through: rect.height, by: size) {
                
                guard Bool.random() else { continue }
                
                context.setFillColor(UIColor.black.cgColor)
                
                switch mirroring {
                case .none:
                    
                    let ellipse = CGRect(x: x, y: y, width: size, height: size)
                    
                    previousGrid.append(CGPoint(x: x, y: y))
                    addShape(in: ellipse)
                    
                case .horizontal:
                    
                    guard x < rect.width / 2 else { continue }
                    
                    let ellipse = CGRect(x: x, y: y, width: size, height: size)
                    
                    let mirroredX = rect.width - x
                    let horizontalMirroredEllipse = CGRect(x: mirroredX - size, y: y, width: size, height: size)
                    
                    previousGrid.append(CGPoint(x: x, y: y))
                    previousGrid.append(CGPoint(x: mirroredX - size, y: y))
                    
                    addShape(in: ellipse)
                    addShape(in: horizontalMirroredEllipse)
                    
                    
                case .vertical:
                    
                    guard y < rect.height / 2 else { continue }
                    let mirroredY = rect.height - y
                    let ellipse = CGRect(x: x, y: y, width: size, height: size)
                    let verticalMirroredEllipse = CGRect(x: x, y: mirroredY - size, width: size, height: size)
                
                    previousGrid.append(CGPoint(x: x, y: mirroredY - size))
                    addShape(in: ellipse)
                    addShape(in: verticalMirroredEllipse)
                    
                case .both:
                    
                    guard x < rect.width / 2 &&
                        y < rect.height / 2 else { continue }
                    
                    let mirroredX = rect.width - x
                    let mirroredY = rect.height - y
                    let ellipse = CGRect(x: x, y: y, width: size, height: size)
                    let horizontalMirroredEllipse = CGRect(x: mirroredX - size, y: y, width: size, height: size)
                    
                    let verticalMirroredEllipse = CGRect(x: x, y: mirroredY - size, width: size, height: size)
                    let bothMirroredEllipse = CGRect(x: mirroredX - size, y: mirroredY - size, width: size, height: size)
                    
                    previousGrid.append(CGPoint(x: x, y: y))
                    previousGrid.append(CGPoint(x: mirroredX - size, y: y))
                    previousGrid.append(CGPoint(x: x, y: mirroredY - size))
                    previousGrid.append(CGPoint(x: mirroredX - size, y: mirroredY - size))
                    
                    addShape(in: ellipse)
                    addShape(in: verticalMirroredEllipse)
                    addShape(in: horizontalMirroredEllipse)
                    addShape(in: bothMirroredEllipse)
                }
            }
        }
        context.fillPath()
        self.previousGrid = previousGrid
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
