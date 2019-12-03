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
    
    static func saveImageToPhotoLibrary(using grid: Grid,
                            contextSize: CGSize,
                            completion: @escaping (Bool) -> Void) {
        
        UIGraphicsBeginImageContext(contextSize)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            completion(false)
            return
        }
        
        context.setFillColor(UIColor.systemBackground.cgColor)
        context.fill(CGRect(origin: CGPoint(x: 0, y: 0), size: contextSize))
        
        func addShape(in rect: CGRect) {
            switch grid.shape {
            case .dot:
                context.addEllipse(in: rect)
            case .square:
                context.addRect(rect)
            }
        }
        
        let size = contextSize.width / CGFloat(grid.size)
        
        switch grid.mirroring {
            
        case .none:
            for (xN, x) in grid.points.enumerated() {
                for (yN, shouldDraw) in x.enumerated() {
                    guard shouldDraw else { continue }
                    
                    addShape(in: CGRect(x: CGFloat(xN) * size, y: CGFloat(yN) * size, width: size, height: size))
                }
            }
        case .horizontal:
            for (xN, x) in grid.points.enumerated() {
                for (yN, shouldDraw) in x.enumerated() {
                    guard shouldDraw else { continue }
                    
                    addShape(in: CGRect(x: CGFloat(xN) * size, y: CGFloat(yN) * size, width: size, height: size))
                    addShape(in: CGRect(x: CGFloat(grid.size - xN - 1) * size, y: CGFloat(yN) * size, width: size, height: size))
                }
            }
        case .vertical:
            for (xN, x) in grid.points.enumerated() {
                for (yN, shouldDraw) in x.enumerated() {
                    guard shouldDraw else { continue }
                    
                    addShape(in: CGRect(x: CGFloat(xN) * size, y: CGFloat(yN) * size, width: size, height: size))
                    addShape(in: CGRect(x: CGFloat(xN) * size, y: CGFloat(grid.size - yN - 1) * size, width: size, height: size))
                }
            }
        case .both:
            for (xN, x) in grid.points.enumerated() {
                for (yN, shouldDraw) in x.enumerated() {
                    guard shouldDraw else { continue }
                    
                    addShape(in: CGRect(x: CGFloat(xN) * size, y: CGFloat(yN) * size, width: size, height: size))
                    addShape(in: CGRect(x: CGFloat(grid.size - xN - 1) * size, y: CGFloat(yN) * size, width: size, height: size))
                    addShape(in: CGRect(x: CGFloat(xN) * size, y: CGFloat(grid.size - yN - 1) * size, width: size, height: size))
                    addShape(in: CGRect(x: CGFloat(grid.size - xN - 1) * size, y: CGFloat(grid.size - yN - 1) * size, width: size, height: size))
                }
            }
        }
        
        context.setFillColor(UIColor.label.cgColor)
        context.fillPath()
        
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
    
    static func requestPhotoAdditionPermission(completion: @escaping (Bool) -> Void) {
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

