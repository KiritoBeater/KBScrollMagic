//
//  SubViewController.swift
//  SwiftTest
//
//  Created by liyang on 2017/4/1.
//  Copyright © 2017年 Wolf Street. All rights reserved.
//

import UIKit

class SubViewController: UITableViewController {
    
    var panHandle: ((UITableView, UIPanGestureRecognizer)->Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.rowHeight = SubGridCell.cellHeight
        tableView.register(SubGridCell.self, forCellReuseIdentifier: SubGridCell.cellIdentifier)
    }
    
}

extension SubViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 13
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SubGridCell.cellIdentifier) as! SubGridCell
        cell.coverIV.image = UIImage(named: "image_\(indexPath.row)")
        return cell
    }
}
