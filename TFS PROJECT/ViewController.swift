//
//  ViewController.swift
//  TFS PROJECT
//
//  Created by Vladislav Kireev on 17.02.2020.
//  Copyright © 2020 VK. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loader.startAnimating()
    }


}

