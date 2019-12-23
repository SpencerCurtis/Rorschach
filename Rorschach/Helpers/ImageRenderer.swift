//
//  ImageRenderer.swift
//  Rorschach
//
//  Created by Spencer Curtis on 12/1/19.
//  Copyright © 2019 Spencer Curtis. All rights reserved.
//

import UIKit
import Photos

class ImageRenderer {
    
    static func drawGrid(using grid: Grid,
        context: CGContext,
        size: CGSize) {
        
        context.setFillColor(UIColor.systemBackground.cgColor)
        context.fill(CGRect(origin: CGPoint(x: 0, y: 0), size: size))
        
        
        func addShape(in rect: CGRect) {
            switch grid.shape {
            case .dot:
                context.addEllipse(in: rect)
            case .square:
                context.addRect(rect)
            }
        }
        
        let itemSize = size.width / CGFloat(grid.size)
        
        for (xIndex, array) in grid.points.enumerated() {
            
            if grid.mirroring == .horizontal ||
                grid.mirroring == .both {
                
                guard xIndex <= grid.halfSize else { continue }
            }
            
            for (yIndex, point) in array.enumerated() {
                
                
                if grid.mirroring == .vertical ||
                    grid.mirroring == .both {
                    
                    guard yIndex <= grid.halfSize else { continue }
                }
                
                
                let x = CGFloat(xIndex) * itemSize
                let y = CGFloat(yIndex) * itemSize
                
                context.setFillColor(point.color)
                
                switch grid.mirroring {
                case .none:
                    
                    let ellipse = CGRect(x: x, y: y, width: itemSize, height: itemSize)
                    addShape(in: ellipse)
                    
                case .horizontal:
                    
                    guard xIndex <= grid.halfSize else { continue }
                    
                    let ellipse = CGRect(x: x, y: y, width: itemSize, height: itemSize)
                    let mirroredX = size.width - x
                    let horizontalMirroredEllipse = CGRect(x: mirroredX - itemSize, y: y, width: itemSize, height: itemSize)
                    
                    addShape(in: ellipse)
                    addShape(in: horizontalMirroredEllipse)
                    
                case .vertical:
                    
                    guard yIndex <= grid.halfSize else { continue }
                    
                    let mirroredY = size.height - y
                    let ellipse = CGRect(x: x, y: y, width: itemSize, height: itemSize)
                    let verticalMirroredEllipse = CGRect(x: x, y: mirroredY - itemSize, width: itemSize, height: itemSize)
                    
                    addShape(in: ellipse)
                    addShape(in: verticalMirroredEllipse)
                    
                case .both:
                    
                    guard xIndex <= grid.halfSize &&
                        yIndex <= grid.halfSize else { continue }
                    
                    let mirroredX = size.width - x
                    let mirroredY = size.height - y
                    let ellipse = CGRect(x: x, y: y, width: itemSize, height: itemSize)
                    let horizontalMirroredEllipse = CGRect(x: mirroredX - itemSize, y: y, width: itemSize, height: itemSize)
                    
                    let verticalMirroredEllipse = CGRect(x: x, y: mirroredY - itemSize, width: itemSize, height: itemSize)
                    let bothMirroredEllipse = CGRect(x: mirroredX - itemSize, y: mirroredY - itemSize, width: itemSize, height: itemSize)
                    
                    addShape(in: ellipse)
                    addShape(in: verticalMirroredEllipse)
                    addShape(in: horizontalMirroredEllipse)
                    addShape(in: bothMirroredEllipse)
                }
                context.fillPath()
            }
        }
        context.setFillColor(UIColor.label.cgColor)
        context.fillPath()
    }
                         
    
    static func saveImageToPhotoLibrary(using grid: Grid,
                                        contextSize: CGSize,
                                        completion: @escaping (Bool) -> Void) {
        
        UIGraphicsBeginImageContext(contextSize)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            completion(false)
            return
        }
        
        drawGrid(using: grid, context: context, size: contextSize)
        
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            completion(false)
            return
        }
        
        UIGraphicsEndImageContext()
        
        requestPhotoAdditionPermission { (hasPermission) in
            if hasPermission {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                }) { (success, error) in
                    if let error = error {
                        NSLog("Error saving image asset: \(error)")
                    }
                    completion(true)
                }
            }
        }
    }
    
    static private func requestPhotoAdditionPermission(completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                completion(true)
            default:
                NSLog("Photo Library access is not allowed.")
                completion(false)
            }
        }
    }
}

