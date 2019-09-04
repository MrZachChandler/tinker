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
    
    var bottomSheetVC: FormViewController?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.backgroundColor = .cyan
        addChart()
        addBottomSheetView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        addBottomSheetView()
    }
    
    func addChart() {
        let chart = LineChartView(frame: CGRect(x: 0, y:0, width: view.bounds.width, height: UIScreen.main.bounds.height - 150))
        view.addSubview(chart)
        
        chart.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(100)
        }
    }
    
    func addBottomSheetView() {
        if bottomSheetVC != nil {
            bottomSheetVC?.removeFromParent()
            bottomSheetVC?.view.removeFromSuperview()
            bottomSheetVC = nil
        }
        
        bottomSheetVC = FormViewController()
        
        self.addChild(bottomSheetVC!)
        self.view.addSubview(bottomSheetVC!.view)
        bottomSheetVC!.didMove(toParent: self)
        
        let height = view.frame.height
        let width  = view.frame.width
        bottomSheetVC!.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
    }
}

