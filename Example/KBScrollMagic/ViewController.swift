//
//  ViewController.swift
//  KBScrollMagic
//
//  Created by liuxingqipan on 04/02/2017.
//  Copyright (c) 2017 liuxingqipan. All rights reserved.
//

import UIKit
import SnapKit
import VTMagic
import KBScrollMagic
import MJRefresh

class ViewController: UIViewController {

    fileprivate let magicVC = VTMagicController()
    fileprivate let listArr = ["推荐", "热点", "视频", "图片", "段子", "社会", "娱乐", "社会"]
    
    let size = UIScreen.main.bounds.size
    
    var lastPoint: CGPoint?
    
    var isTableViewBounces = true
    
    fileprivate let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    fileprivate let headerIV = UIImageView()
    fileprivate let scrollBackView: UIView = {
        let view = UIView()
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        scrollView.contentSize = CGSize(width: size.width, height: size.height + 200)
        view.addSubview(scrollView)
        scrollView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(headerRefreshHandle))

        scrollView.addSubview(scrollBackView)
        
        headerIV.image = UIImage(named: "image_0")
        scrollBackView.addSubview(headerIV)
        
        createMenu()
        self.addChildViewController(self.magicVC)
        scrollView.addSubview(self.magicVC.view)
        self.view.setNeedsUpdateConstraints()
        self.magicVC.magicView.reloadData()
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview();
        }
        
        scrollBackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalTo(self.magicVC.view.snp.bottom)
        }
        
        headerIV.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(200)
        }
        
        let settingItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(settingItemHandle))
        navigationItem.rightBarButtonItem = settingItem
    }
    
    func createMenu() {
        magicVC.magicView.backgroundColor = UIColor.white
        magicVC.view.translatesAutoresizingMaskIntoConstraints = false;
        magicVC.magicView.navigationColor = .white
        //mRGB(35, 38, 45);
        magicVC.magicView.sliderColor = .black
        //mRGB(35, 38, 45);
        magicVC.magicView.switchStyle = .default;
        self.magicVC.magicView.navigationHeight = 44.0;
        self.magicVC.magicView.sliderExtension = 0.0;
        self.magicVC.magicView.sliderHeight = 2.0;
        self.magicVC.magicView.dataSource = self;
        self.magicVC.magicView.delegate = self;
    }
    
    override func updateViewConstraints() {
        self.magicVC.view.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(200);
            make.left.right.equalToSuperview();
            make.height.equalTo(size.height)
        }
        
        super.updateViewConstraints()
    }
    
    func settingItemHandle() {
        isTableViewBounces = !isTableViewBounces
        
        magicVC.magicView.reloadData()
        
        let alert = UIAlertController(title: "Changed", message: "tableView.bounces = \(isTableViewBounces ? "true" : "false")", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func headerRefreshHandle() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.scrollView.mj_header.endRefreshing()
        }
    }
}

extension ViewController: KBScrollMagicDelegate {
    
    func scrollMagicDidEndDrag(when superScrollView: UIScrollView, offSetY: CGFloat) {
        if offSetY < -44 {
            superScrollView.mj_header.beginRefreshing()
        }
    }
}

extension ViewController: VTMagicViewDelegate {
    
    func magicView(_ magicView: VTMagicView, viewDidAppear viewController: UIViewController, atPage pageIndex: UInt) {
        
    }
    
}

extension ViewController: VTMagicViewDataSource {
    
    func menuTitles(for magicView: VTMagicView) -> [String] {
        return listArr
    }
    
    func magicView(_ magicView: VTMagicView, menuItemAt itemIndex: UInt) -> UIButton {
        let itemIdentifier = "itemIdentifier"
        var menuItem = magicView.dequeueReusableItem(withIdentifier: itemIdentifier)
        if menuItem == nil  {
            menuItem = UIButton(type:.custom)
            menuItem?.setTitleColor(.black, for: .normal)
            menuItem?.setTitleColor(.black, for: .selected)
            menuItem?.titleLabel?.textAlignment = .center
        }
        return menuItem!
    }
    
    func magicView(_ magicView: VTMagicView, viewControllerAtPage pageIndex: UInt) -> UIViewController {
        
        let itemIdentifier1 = "itemIdentifier.0"
        var ovc = magicView.dequeueReusablePage(withIdentifier: itemIdentifier1) as? SubViewController
        if ovc == nil {
            ovc = SubViewController()
            ovc?.tableView.kb.setDelegate(self)
            ovc?.tableView.kb.setinsetY(200)
            ovc?.tableView.kb.setSuperScrollView(scrollView)
        }
        ovc?.tableView.bounces = isTableViewBounces
        return ovc!
    }
}

