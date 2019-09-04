//
//  ScrollableBottomSheetViewController.swift
//  BottomSheet
//
//  Created by Ahmed Elassuty on 10/15/16.
//  Copyright © 2016 Ahmed Elassuty. All rights reserved.
//

import UIKit
import SnapKit

class ScrollableBottomSheetViewController: BottomSheetViewController {
    var tableView: UITableView!
    
    override var curPosition: Position {
        didSet {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: view.frame)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.layer.shadowRadius = 10
        tableView.layer.shadowColor = UIColor.darkGray.cgColor
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)

        view.addSubview(tableView)
    }
    
    @objc override func panGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)

        let y = self.view.frame.minY
        if (y + translation.y >= fullView) && (y + translation.y <= partialView) {
            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
        if recognizer.state == .ended {
            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            
            duration = duration > 1.3 ? 1 : duration
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if  velocity.y >= 0 {
                    self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: self.view.frame.height)
                } else {
                    self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
                }
                
                }, completion: { [weak self] _ in
                    if ( velocity.y < 0 ) {
                        self?.tableView.isScrollEnabled = true
                        self?.curPosition = .top
                    } else { self?.curPosition = .bottom }
            })
        }
    }
    
    override func subViewUserInteration(enable enabled: Bool) {
        tableView.isScrollEnabled = enabled
    }
    
    override func setUpView() {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 30))
        header.backgroundColor = .groupTableViewBackground
        header.layer.cornerRadius = 20
        header.clipsToBounds = true
        
        view.insertSubview(header, belowSubview: tableView)
        
        header.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(30)
            make.bottom.equalTo(tableView.snp.top).inset(-10)
        }
        
        let hideView = UIView()
        hideView.backgroundColor = .white
        view.insertSubview(hideView, belowSubview: tableView)
        
        hideView.snp.makeConstraints { (make) in
            make.top.equalTo(tableView.snp.bottom).inset(view.frame.height/2)
            make.bottom.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom)
            make.bottom.leading.trailing.equalToSuperview()
        }
    }
}

extension ScrollableBottomSheetViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

//MARK: UIGestureRecognizerDelegate
extension ScrollableBottomSheetViewController {
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let gesture = (gestureRecognizer as! UIPanGestureRecognizer)
        let direction = gesture.velocity(in: view).y
        
        let y = view.frame.minY
        if (y == fullView && tableView.contentOffset.y == 0 && direction > 0) || (y == partialView) {
            subViewUserInteration(enable: false)
        } else {
            subViewUserInteration(enable: true)
        }
        
        return false
    }
}
