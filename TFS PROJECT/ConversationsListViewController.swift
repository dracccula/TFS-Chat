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
    }
    @IBOutlet weak var conversationsTableView: UITableView!
    enum TableSection: Int {
        case online, offline
    }
    var messagesArray: [ConversationViewCell.ConversationCellModel] = [ConversationViewCell.ConversationCellModel(name: "Buddha", message: "You yourself, as much as anybody in the entire universe, deserve your love and affection.", date: Date.init(timeIntervalSince1970: 1583589958), isOnline: true, hasUnreadMessages: true), ConversationViewCell.ConversationCellModel(name: "Mother Teresa", message: "Love until it hurts. Real love is always painful and hurts: then it is real and pure.", date: Date.init(timeIntervalSince1970: 1583780758), isOnline: false, hasUnreadMessages: false), ConversationViewCell.ConversationCellModel(name: "Alan Paton", message: "It is my belief that the only power which can resist the power of fear is the power of love.", date: Date.init(timeIntervalSince1970: 1583319615), isOnline: false, hasUnreadMessages: false), ConversationViewCell.ConversationCellModel(name: "Nelson Aldrich Rockefeller", message: "Never forget that the most powerful force on earth is love.", date: Date.init(timeIntervalSince1970: 1581081000), isOnline: true, hasUnreadMessages: false), ConversationViewCell.ConversationCellModel(name: "F. Melvin Hammond", message: "Can we do too much for the Lord? Certainly we all love Him. Therefore, I implore us, keep His commandments and become more like Him. Come unto Christ, eat the bread of life, drink the living water, and feast on His limitless love. He is our Savior, our Master, of whom I bear my humble witness.", date: Date.init(timeIntervalSince1970: 1583265600), isOnline: true, hasUnreadMessages: true), ConversationViewCell.ConversationCellModel(name: "Martin Luther King", message: nil, date: Date.init(timeIntervalSince1970: 1581084358), isOnline: true, hasUnreadMessages: false)]
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
      return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return messagesArray.map{$0.isOnline}.filter{$0 == true}.count
        } else {
            return messagesArray.map{$0.isOnline}.filter{$0 == false}.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
           switch section {
           case 0:
               return "Online"
           case 1:
               return "History"
           default:
               return nil
           }
       }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "conversationCell", for: indexPath) as! ConversationViewCell
            cell.configure(with: messagesArray.filter{$0.isOnline == true}[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "conversationCell", for: indexPath) as! ConversationViewCell
            cell.configure(with: messagesArray.filter{$0.isOnline == false}[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let storyBoard =  UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyBoard.instantiateViewController(withIdentifier: "ConversationViewController") as! ConversationViewController
        switch indexPath.section {
        case 0:
            let name = messagesArray.filter{$0.isOnline == true}[indexPath.row].name
            print(name)
//            vc.title = name
//            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let name = messagesArray.filter{$0.isOnline == false}[indexPath.row].name
            print(name)
//            vc.title = name
//            self.navigationController?.pushViewController(vc, animated: true)
        default:
            print("Unknown")
//            vc.title = "Unknown"
//            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileButton.makeRounded()
        conversationsTableView.dataSource = self
        conversationsTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        conversationsTableView.reloadData()
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
