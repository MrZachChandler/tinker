//
//  FormViewController.swift
//  tinker
//
//  Created by Zachary Chandler on 9/3/19.
//  Copyright © 2019 Zach. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SwipeMenuViewController
    
class FormViewController: BottomSheetViewController {
    
    private var datas: [String] = ["Bulbasaur","Caterpie", "Golem", "Jynx", "Marshtomp", "Salamence", "Riolu", "Araquanid"]
    
    var options = SwipeMenuViewOptions()
    var dataCount: Int = 8
    open var swipeMenuView: SwipeMenuView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addMenu()
    }
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        swipeMenuView.willChangeOrientation()
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addSwipeMenuViewConstraints()
        setUpView()
    }
    
    private func addSwipeMenuViewConstraints() {
        swipeMenuView.translatesAutoresizingMaskIntoConstraints = false
        swipeMenuView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
//            make.top.equalToSuperview()
//            make.leading.equalToSuperview()
//            make.trailing.equalToSuperview()
//            make.height.equalTo(30)
//            make.bottom.equalTo(view.snp.top).inset(-10)
        })
    }
    
    func addMenu() {
        datas.forEach { data in
            let vc = TableViewController()
            vc.title = data
            vc.content = data
            self.addChild(vc)
        }
        
        swipeMenuView = SwipeMenuView(frame: view.frame)
        swipeMenuView.delegate = self
        swipeMenuView.dataSource = self
        view.addSubview(swipeMenuView)
        
    }

    
//    override func setUpView() {
//        tableView.snp.makeConstraints { make in
//            make.top.equalTo(swipeMenuView.snp.bottom)
//            make.bottom.leading.trailing.equalToSuperview()
//        }
//
//        let hideView = UIView()
//        hideView.backgroundColor = .white
//        view.insertSubview(hideView, belowSubview: tableView)
//
//        hideView.snp.makeConstraints { (make) in
//            make.top.equalTo(tableView.snp.bottom).inset(view.frame.height/2)
//            make.bottom.leading.trailing.equalToSuperview()
//        }
//    }
}


extension FormViewController: SwipeMenuViewDelegate, SwipeMenuViewDataSource {
    func swipeMenuView(_ swipeMenuView: SwipeMenuView, viewWillSetupAt currentIndex: Int) {
        print("will setup SwipeMenuView")
    }
    
    func swipeMenuView(_ swipeMenuView: SwipeMenuView, viewDidSetupAt currentIndex: Int) {
        print("did setup SwipeMenuView")
    }
    
    func swipeMenuView(_ swipeMenuView: SwipeMenuView, willChangeIndexFrom fromIndex: Int, to toIndex: Int) {
        print("will change from section\(fromIndex + 1)  to section\(toIndex + 1)")
    }
    
    func swipeMenuView(_ swipeMenuView: SwipeMenuView, didChangeIndexFrom fromIndex: Int, to toIndex: Int) {
        print("did change from section\(fromIndex + 1)  to section\(toIndex + 1)")
    }
    
    /// MARK - SwipeMenuViewDataSource
    
    func numberOfPages(in swipeMenuView: SwipeMenuView) -> Int {
        return children.count
    }
    
    func swipeMenuView(_ swipeMenuView: SwipeMenuView, titleForPageAt index: Int) -> String {
        return children[index].title ?? ""
    }
    
    func swipeMenuView(_ swipeMenuView: SwipeMenuView, viewControllerForPageAt index: Int) -> UIViewController {
        let vc = children[index] as! TableViewController
        vc.didMove(toParent: self)
        vc.content = datas[index]
        
        return vc
    }
}

class TableViewController: UITableViewController {
    var content: String = "" {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header =  UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 40))
        let label = UILabel(frame:  CGRect(x: 0, y: 0, width: view.bounds.width, height: 40))
        label.text = content
        header.addSubview(label)
        return header
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "index: \(indexPath.row)"
        cell.selectionStyle = .none
        
        return cell
    }
}
