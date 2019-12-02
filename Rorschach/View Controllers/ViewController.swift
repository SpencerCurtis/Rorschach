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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeMirroring(self)
        changeGridSize(self)
        changeShape(self)
    }

    @IBAction func redraw(_ sender: Any) {
        rorschachView.setNeedsDisplay()
    }
    
    @IBAction func changeMirroring(_ sender: Any) {
        rorschachView.grid.mirroring = Mirroring.allCases[mirroringSelector.selectedSegmentIndex]
        rorschachView.setNeedsDisplay()
    }
    
    @IBAction func changeShape(_ sender: Any) {
        rorschachView.grid.shape = Shape.allCases[shapeSelector.selectedSegmentIndex]
//        rorschachView.grid.shouldRedrawSameGrid = true
        rorschachView.setNeedsDisplay()
    }
    
    @IBAction func changeGridSize(_ sender: Any) {
        rorschachView.grid.size = Int(gridSizeSlider.value)
        gridSizeLabel.text = "Grid Size: \(Int(gridSizeSlider.value))"
        rorschachView.setNeedsDisplay()
    }
    
    @IBAction func saveImage(_ sender: Any) {
        ImageRenderer.saveImageToPhotoLibrary(using: rorschachView.grid, contextSize: CGSize(width: 10000, height: 10000)) { (success) in
            
            var title: String
            
            title = success ? "Image saved successfully!" : "Image was unable to be saved."
            
            let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(okAction)
            
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func reloadRorschachView() {
        rorschachView.setNeedsDisplay()
    }
}

