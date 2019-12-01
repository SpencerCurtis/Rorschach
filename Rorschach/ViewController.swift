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
    
//    lazy var link: CADisplayLink = {
//        let link = CADisplayLink(target: self, selector: #selector(reloadRorschachView))
//        link.preferredFramesPerSecond = 2
//        link.add(to: .current, forMode: .default)
//        return link
//    }()
//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeMirroring(self)
        changeGridSize(self)
//        _ = link
    }

    @IBAction func redraw(_ sender: Any) {
        rorschachView.setNeedsDisplay()
    }
    
    @IBAction func changeMirroring(_ sender: Any) {
        rorschachView.mirroring = Mirroring.allCases[mirroringSelector.selectedSegmentIndex]
        rorschachView.setNeedsDisplay()
    }
    
    @IBAction func changeShape(_ sender: Any) {
        rorschachView.shape = Shape.allCases[shapeSelector.selectedSegmentIndex]
        rorschachView.shouldRedrawSameGrid = true
        rorschachView.setNeedsDisplay()
    }
    
    @IBAction func changeGridSize(_ sender: Any) {
        rorschachView.gridSize = CGFloat(Int(gridSizeSlider.value))
        gridSizeLabel.text = "Grid Size: \(Int(gridSizeSlider.value))"
        rorschachView.setNeedsDisplay()
    }
    
    
    @objc func reloadRorschachView() {
        rorschachView.setNeedsDisplay()
    }
}

