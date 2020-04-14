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
    
    @IBAction func addChannelButton(_ sender: Any) {
        showAlertToAddChannel()
    }
    @IBOutlet weak var profileButton: UIButton!
    @IBAction func clickAvatarButton(_ sender: Any) {
    }
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var channelsTableView: UITableView!
    private let spinner = Spinner()
    enum TableSection: Int {
        case online, offline
    }
    
    var sortedOnlineChannelsArray: [Channel] = []
    var sortedHistoryChannelsArray: [Channel] = []
    
    var firebase : FirebaseService = FirebaseService()
    
    private func getChannels() {
        firebase.getChannels { (channelsArray) in
            self.spinner.showActivityIndicator(uiView: self.view)
            self.sortedOnlineChannelsArray = channelsArray[0]
            self.sortedHistoryChannelsArray = channelsArray[1]
            self.channelsTableView.reloadData()
            self.spinner.hideActivityIndicator(uiView: self.view)
        }
    }
    
    private func showAlertToAddChannel() {
        let alert = UIAlertController(title: "Add new channel", message: "Enter a channel name", preferredStyle: .alert)
        alert.addTextField()
        let channelNameTextField = alert.textFields![0]
        let okButton = UIAlertAction(title: "OK", style: .default, handler: { alert in
            if !(channelNameTextField.text?.isEmpty)! {
                self.addChannel(channelName: channelNameTextField.text ?? "")
            }
        })
        okButton.isEnabled = false
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object:channelNameTextField,
                                                      queue: OperationQueue.main) { (notification) -> Void in
                                                        okButton.isEnabled = channelNameTextField.text != ""
        }
        alert.addAction(okButton)
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func addChannel(channelName: String) {
        firebase.addChannel(channelName: channelName) {
            self.spinner.showActivityIndicator(uiView: self.view)
            self.channelsTableView.reloadData()
            self.spinner.hideActivityIndicator(uiView: self.view)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
      return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return sortedOnlineChannelsArray.count
        } else {
            return sortedHistoryChannelsArray.count
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "channelCell", for: indexPath) as! ChannelViewCell
            cell.configure(with: sortedOnlineChannelsArray[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "channelCell", for: indexPath) as! ChannelViewCell
            cell.configure(with: sortedHistoryChannelsArray[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard =  UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: "ChannelViewController") as? ChannelViewController
            else {
                return print("Error")
        }
        switch indexPath.section {
        case 0:
            let name = sortedOnlineChannelsArray[indexPath.row].name
            vc.title = name
            vc.channel = sortedOnlineChannelsArray[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let name = sortedHistoryChannelsArray[indexPath.row].name
            vc.title = name
            vc.channel = sortedHistoryChannelsArray[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            print("Error")
        }
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
        channelsTableView.dataSource = self
        channelsTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getChannels()
//        clearChannels(exceptСhannelsArray: true)
//        getSortedChannelsArrays(source: channelsArray)
//        channelsTableView.reloadData()
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
