//
//  ViewController.swift
//  TFS PROJECT
//
//  Created by Vladislav Kireev on 17.02.2020.
//  Copyright © 2020 VK. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var profileButton: UIButton!
    @IBAction func clickAvatarButton(_ sender: Any) {
        openProfileView()
    }
    @IBOutlet weak var conversationsTableView: UITableView!
    var statuses = [true, true, false, true, false]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "conversationCell")
        {
//                switch statuses[indexPath.item] {
//                case true:
//                    statusIndicator.backgroundColor = UIColor.green
//                case false:
//                    statusIndicator.backgroundColor = UIColor.red
//                }
            return cell
        }
        return UITableViewCell()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileButton.makeRounded()
        conversationsTableView.dataSource = self
        conversationsTableView.delegate = self
    }
    
    func openProfileView() {
    }

}

// MARK: Extension which make image rounded
extension UIButton {
    func makeRounded() {
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
