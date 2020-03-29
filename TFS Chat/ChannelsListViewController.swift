//
//  ViewController.swift
//  TFS PROJECT
//
//  Created by Vladislav Kireev on 17.02.2020.
//  Copyright © 2020 VK. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, InfoDataDelegate {
    
    @IBOutlet weak var profileButton: UIButton!
    @IBAction func clickAvatarButton(_ sender: Any) {
    }
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var channelsTableView: UITableView!
    private let spinner = SpinnerUtils()
    enum TableSection: Int {
        case online, offline
    }
    var contactsMessagesArray: [ConversationViewCell.ConversationCellModel] = [
        ConversationViewCell.ConversationCellModel(id: 1, name: "Buddha", message: "You yourself, as much as anybody in the entire universe, deserve your love and affection.", date: Date.init(timeIntervalSince1970: 1583589958), isOnline: true, hasUnreadMessages: true),
        ConversationViewCell.ConversationCellModel(id: 2, name: "Mother Teresa", message: "Love until it hurts. Real love is always painful and hurts: then it is real and pure.", date: Date.init(timeIntervalSince1970: 1583780758), isOnline: false, hasUnreadMessages: true),
        ConversationViewCell.ConversationCellModel(id: 3, name: "Alan Paton", message: "It is my belief that the only power which can resist the power of fear is the power of love.", date: Date.init(timeIntervalSince1970: 1583319615), isOnline: false, hasUnreadMessages: false),
        ConversationViewCell.ConversationCellModel(id: 4, name: "Nelson Aldrich Rockefeller", message: "Never forget that the most powerful force on earth is love.", date: Date.init(timeIntervalSince1970: 1581081000), isOnline: true, hasUnreadMessages: false),
        ConversationViewCell.ConversationCellModel(id: 5, name: "F. Melvin Hammond", message: "Can we do too much for the Lord? Certainly we all love Him. Therefore, I implore us, keep His commandments and become more like Him. Come unto Christ, eat the bread of life, drink the living water, and feast on His limitless love. He is our Savior, our Master, of whom I bear my humble witness.", date: Date.init(timeIntervalSince1970: 1583265600), isOnline: true, hasUnreadMessages: true),
        ConversationViewCell.ConversationCellModel(id: 6, name: "Martin Luther King", message: nil, date: Date.init(timeIntervalSince1970: 1581084358), isOnline: true, hasUnreadMessages: false),
        ConversationViewCell.ConversationCellModel(id: 7, name: "Zsa Zsa Gabor", message: "One of my theories is that men love with their eyes; women love with their ears.", date: Date.init(timeIntervalSince1970: 1583780758), isOnline: false, hasUnreadMessages: false),
        ConversationViewCell.ConversationCellModel(id: 8, name: "Alexander Smith", message: nil, date: Date.init(timeIntervalSince1970: 1583319615), isOnline: false, hasUnreadMessages: true),
        ConversationViewCell.ConversationCellModel(id: 9, name: "Alexander Pushkin", message: "I loved you; even now I may confess, Some embers of my love their fire retain; But do not let it cause you more distress, I do not want to sadden you again. Hopeless and tongue tied, yet I loved you dearly With pangs the jealous and the timid know; So tenderly I loved you, so sincerely, I pray God grant another love you so.", date: Date.init(timeIntervalSince1970: 1583780758), isOnline: true, hasUnreadMessages: false),
        ConversationViewCell.ConversationCellModel(id: 10, name: "James Thurber", message: "I have always thought of a dog lover as a dog that was in love with another dog.", date: Date.init(timeIntervalSince1970: 1583319615), isOnline: true, hasUnreadMessages: false)]
    
    var channelsArray : [ChannelCellModel] = []
    
    var onlineConversations : [ConversationViewCell.ConversationCellModel] = []
    var offlineConversations : [ConversationViewCell.ConversationCellModel] = []
    
    private lazy var db = Firestore.firestore()
    private lazy var reference = db.collection("channels")
    
    func sortArray(source: [ConversationViewCell.ConversationCellModel], isOnline: Bool) -> [ConversationViewCell.ConversationCellModel]{
        return source.filter{$0.isOnline == isOnline}
    }
    
    private func getChannels(){
        spinner.showActivityIndicator(uiView: self.view)
        DispatchQueue.main.async {
            self.reference.addSnapshotListener { snapshot, error in
                snapshot!.documents.forEach { data in
                    let identifier = data.data()["identifier"] as? String
                    let name = data.data()["name"] as? String
                    let lastMessage = data.data()["lastMessage"] as? String
                    let lastActivity = data.data()["lastActivity"] as? Timestamp
                    //                print("\(identifier ?? "id"), \(name ?? "Untitled"), \(lastMessage ?? "No messages"), \(lastActivity)")
                    self.channelsArray.append(ChannelCellModel(identifier: identifier, name: name, lastMessage: lastMessage, lastActivity: lastActivity?.dateValue() ?? Date()))
                    self.channelsTableView.reloadData()
                }
            }
            self.spinner.hideActivityIndicator(uiView: self.view)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
      return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channelsArray.count
//        if section == 0{
//            return onlineConversations.count
//        } else {
//            return offlineConversations.count
//        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "All uncorted channels"
//           switch section {
//           case 0:
//               return "Online"
//           case 1:
//               return "History"
//           default:
//               return nil
//           }
       }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "channelCell", for: indexPath) as! ChannelViewCell
        cell.configure(with: channelsArray[indexPath.row])
        return cell
//        if indexPath.section == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "conversationCell", for: indexPath) as! ConversationViewCell
//            cell.configure(with: onlineConversations[indexPath.row])
//            return cell
//        } else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "conversationCell", for: indexPath) as! ConversationViewCell
//            cell.configure(with: offlineConversations[indexPath.row])
//            return cell
//        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard =  UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: "ConversationViewController") as? ConversationViewController
            else {
                return print("Error")
        }
        let name = channelsArray[indexPath.row].name
        vc.title = name
        self.navigationController?.pushViewController(vc, animated: true)
//        switch indexPath.section {
//        case 0:
//            let name = onlineConversations[indexPath.row].name
//            vc.title = name
//            self.navigationController?.pushViewController(vc, animated: true)
//        case 1:
//            let name = offlineConversations[indexPath.row].name
//            vc.title = name
//            self.navigationController?.pushViewController(vc, animated: true)
//        default:
//            print("Error")
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getChannels()
        profileButton.makeRounded()
        if let image = GCDDataManager().getSavedPicture(named: "profilePicture") {
            profileButton.setImage(image, for: .normal)
        }
        if let name = GCDDataManager().getSavedText(named: "name") {
            profileName.text = name
        }
//        onlineConversations = sortArray(source: contactsMessagesArray, isOnline: true)
//        offlineConversations = sortArray(source: contactsMessagesArray, isOnline: false)
        channelsTableView.dataSource = self
        channelsTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        channelsTableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if let destination = segue.destination as? ProfileViewController {
               destination.delegate = self
           }
       }
       
       func passInfo() {
        if let image = GCDDataManager().getSavedPicture(named: "profilePicture") {
            profileButton.setImage(image, for: .normal)
        }
        self.profileName.text = GCDDataManager().getSavedText(named: "name")
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
