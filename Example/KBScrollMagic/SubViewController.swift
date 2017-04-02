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
        tableView.bounces = false
    }
    
}

extension SubViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .`default`, reuseIdentifier: "cell")
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
}
