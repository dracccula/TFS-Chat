//
//  GCDDataManager.swift
//  TFS PROJECT
//
//  Created by Vladislav Kireev on 21.03.2020.
//  Copyright © 2020 VK. All rights reserved.
//

import UIKit

class GCDDataManager: ProfileDataManager {
    
    private let nameFileName = "name"
    private let aboutFileName = "about"
    private let profilePictureFileName = "profilePicture"
    
    func readProfileData(completion: @escaping (_: ProfileData) -> Void) {
        DispatchQueue.global().async {
            let profileData = ProfileData()
            if let name = self.getSavedText(named: self.nameFileName) {
                profileData.name = name
            }
            if let description = self.getSavedText(named: self.aboutFileName) {
                profileData.about = description
            }
            if let image = self.getSavedPicture(named: self.profilePictureFileName) {
                profileData.picture = image
            }
            DispatchQueue.main.async {
                completion(profileData)
            }
        }
    }
    
    
    
    func saveProfileData (profileData: ProfileData, onError: @escaping () -> Void, completion: @escaping () -> Void) {
        DispatchQueue.global().async {
            var saveClosures: [() -> Bool] = []
            
            if let name = profileData.name {
                saveClosures.append {
                    return self.saveText(named: self.nameFileName, text: name)
                }
            }
            
            if let about = profileData.about {
                saveClosures.append {
                    return self.saveText(named: self.aboutFileName, text: about)
                }
            }
            
            if let image = profileData.picture {
                saveClosures.append {
                    return self.saveProfilePicture(named: self.profilePictureFileName, image: image)
                }
            }
            
            for closure in saveClosures {
                let isSaved = closure()
                if !isSaved {
                    DispatchQueue.main.async {
                        onError()
                    }
                    return
                }
            }
            
            DispatchQueue.main.async {
                completion()
            }
        }
        
    }
    
    func saveText(named: String, text: String) -> Bool {
        if  let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) {
            do {
                try text.write(to: dir.appendingPathComponent(named), atomically: false, encoding: .utf8)
                 return true
            } catch {
                return false
            }
        }
        return false
    }
    
    func getSavedText(named: String) -> String? {
        if  let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false),
            let str = try? String(contentsOf: dir.appendingPathComponent(named), encoding: .utf8) {
                return str
        }
        return nil
    }
    
    func saveProfilePicture(named: String, image: UIImage) -> Bool {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent(named))
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func getSavedPicture(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
    
}
