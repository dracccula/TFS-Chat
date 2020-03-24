//
//  OperationDataManager.swift
//  TFS PROJECT
//
//  Created by Vladislav Kireev on 21.03.2020.
//  Copyright © 2020 VK. All rights reserved.
//

import UIKit

class SaveOperation: Operation {
    public var isSaved = false
}

class SaveTextOperation: SaveOperation {
    private var fileName: String
    private var text: String
    
    init(fileName: String, text: String) {
        self.fileName = fileName
        self.text = text
    }
    
    override func main() {
        sleep(1)
        self.isSaved = saveText(named: fileName, text: text)
    }
    
    private func saveText(named: String, text: String) -> Bool {
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
}

class SaveImageOperation: SaveOperation {
    private var fileName: String
    private var image: UIImage
    
    init(fileName: String, image: UIImage) {
        self.fileName = fileName
        self.image = image
    }
    
    override func main() {
        sleep(1)
        self.isSaved = saveImage(named: fileName, image: image)
    }
    
    func saveImage(named: String, image: UIImage) -> Bool {
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
}

class ReadTextOperation: Operation {
    private var fileName: String
    public var text: String?
    
    init(fileName: String) {
        self.fileName = fileName
    }
    
    override func main() {
        self.text = getSavedText(named: fileName)
    }
    
    func getSavedText(named: String) -> String? {
        if  let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false),
            let str = try? String(contentsOf: dir.appendingPathComponent(named), encoding: .utf8) {
                return str
        }
        return nil
    }
}

class ReadImageOperation: Operation {
    private var fileName: String
    public var image: UIImage?
    
    init(fileName: String) {
        self.fileName = fileName
    }
    
    override func main() {
        self.image = getSavedImage(named: fileName)
    }
    
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
}

class OperationDataManager: ProfileDataManager {
    
    private let nameFileName = "name"
    private let aboutFileName = "about"
    private let profilePictureFileName = "profilePicture"
    
    func readProfileData(completion: @escaping (_: ProfileData) -> Void) {
        var operations: [Operation] = []
        let operationQueue = OperationQueue()
        let completeOperation = Operation()
        let profileData = ProfileData()
        
        let readNameOperation = ReadTextOperation(fileName: nameFileName)
        readNameOperation.completionBlock = {
            profileData.name = readNameOperation.text
        }
        operations.append(readNameOperation)
        
        let readDescriptionOperation = ReadTextOperation(fileName: aboutFileName)
        readDescriptionOperation.completionBlock = {
            profileData.about = readDescriptionOperation.text
        }
        operations.append(readDescriptionOperation)
        
        let readImageOperation = ReadImageOperation(fileName: profilePictureFileName)
        readImageOperation.completionBlock = {
            profileData.picture = readImageOperation.image
        }
        operations.append(readImageOperation)
        
        completeOperation.completionBlock = {
            OperationQueue.main.addOperation {
                completion(profileData)
            }
        }
        
        for op in operations {
            completeOperation.addDependency(op)
            operationQueue.addOperation(op)
        }
        operationQueue.addOperation(completeOperation)
    }
    
    func saveProfileData (profileData: ProfileData, onError: @escaping () -> Void, completion: @escaping () -> Void) {
        var operations: [SaveOperation] = []
        let operationQueue = OperationQueue()
        let completeOperation = Operation()
        
        if let name = profileData.name {
            let saveNameOperation = SaveTextOperation(fileName: nameFileName, text: name)
            operations.append(saveNameOperation)
        }
        
        if let description = profileData.about {
            let saveDescriptionOperation = SaveTextOperation(fileName: aboutFileName, text: description)
            operations.append(saveDescriptionOperation)
        }
        
        if let image = profileData.picture {
            let saveImageOperation = SaveImageOperation(fileName: profilePictureFileName, image: image)
            operations.append(saveImageOperation)
        }
        
        completeOperation.completionBlock = {
            let smthNotSaved = operations.contains { !$0.isSaved }
            if smthNotSaved {
                OperationQueue.main.addOperation(onError)
            } else {
                OperationQueue.main.addOperation(completion)
            }
        }
        
        for op in operations {
            completeOperation.addDependency(op)
            operationQueue.addOperation(op)
        }
        operationQueue.addOperation(completeOperation)
        
        
    }
}

