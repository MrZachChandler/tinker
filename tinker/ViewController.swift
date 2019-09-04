//
//  ViewController.swift
//  tinker
//
//  Created by Zachary Chandler on 9/3/19.
//  Copyright © 2019 Zach. All rights reserved.
//

import UIKit
import SnapKit
import Charts

class ViewController: UIViewController {  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.backgroundColor = .cyan
        addChart()
        addBottomSheetView()
    }
    
    func addChart() {
        let chart = LineChartView(frame: CGRect(x: 0, y:0, width: view.bounds.width, height: UIScreen.main.bounds.height - 150))
        view.addSubview(chart)
    }
    
    func addBottomSheetView() {
        let bottomSheetVC = FormViewController()
        
        self.addChild(bottomSheetVC)
        self.view.addSubview(bottomSheetVC.view)
        bottomSheetVC.didMove(toParent: self)
        
        let height = view.frame.height
        let width  = view.frame.width
        bottomSheetVC.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
    }
}

