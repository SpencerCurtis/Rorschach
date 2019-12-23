//
//  ViewController.swift
//  Rorschach
//
//  Created by Spencer Curtis on 12/1/19.
//  Copyright © 2019 Spencer Curtis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mirroringSelector: UISegmentedControl!
    @IBOutlet weak var shapeSelector: UISegmentedControl!
    @IBOutlet weak var rorschachView: RorschachView!
    @IBOutlet weak var gridSizeSlider: UISlider!
    @IBOutlet weak var gridSizeLabel: UILabel!
    
    var gridItemTapRecognizer: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        rorschachView.grid.size = 16
        gridSizeLabel.text = "Grid Size: \(Int(gridSizeSlider.value))"
        
        gridItemTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleGridItemSelection))
        rorschachView.addGestureRecognizer(gridItemTapRecognizer)
    }
    
    @objc func toggleGridItemSelection(_ recognizer: UITapGestureRecognizer) {
        let point = recognizer.location(in: rorschachView)
        
        rorschachView.toggleDrawing(at: point)
    }

    @IBAction func redraw(_ sender: Any) {
        rorschachView.grid.resetGrid()
        rorschachView.setNeedsDisplay()
    }
    
    @IBAction func changeMirroring(_ sender: Any) {
        rorschachView.grid.mirroring = Mirroring.allCases[mirroringSelector.selectedSegmentIndex]
        rorschachView.grid.resetGrid()
        rorschachView.setNeedsDisplay()
    }
    
    @IBAction func changeShape(_ sender: Any) {
        rorschachView.grid.shape = Shape.allCases[shapeSelector.selectedSegmentIndex]
        rorschachView.setNeedsDisplay()
    }
    
    @IBAction func changeGridSize(_ sender: Any) {
        
        let gridSize = rorschachView.grid.size
        let newGridSize = Int(gridSizeSlider.value)
        
        if gridSize != newGridSize {
            rorschachView.grid.size = Int(gridSizeSlider.value)
            gridSizeLabel.text = "Grid Size: \(Int(gridSizeSlider.value))"
            rorschachView.setNeedsDisplay()
        }
    }
    
    @IBAction func saveImage(_ sender: Any) {
        ImageRenderer.saveImageToPhotoLibrary(using: rorschachView.grid, contextSize: CGSize(width: 10000, height: 10000)) { (success) in
            
            var title: String
            title = success ? "Image saved successfully!" : "Image was unable to be saved."
            
            let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

