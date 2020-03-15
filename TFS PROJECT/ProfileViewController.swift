//
//  ProfileViewController.swift
//  TFS PROJECT
//
//  Created by Vladislav Kireev on 20.02.2020.
//  Copyright © 2020 VK. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var profileImage: UIImageView!
    let imagePicker = UIImagePickerController()
    @IBAction func changeProfileImageButtonAction(_ sender: UIButton)
    {
        showActionSheet(sender)
    }

    @IBOutlet weak var changeProfileImageButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBAction func closeButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var cancelButton: UIButton!
    @IBAction func cancelButtonAction(_ sender: Any) {
        setProfileImage()
        disableEditMode()
    }
    @IBOutlet weak var saveButton: UIButton!
    @IBAction func saveButtonAction(_ sender: Any) {
        disableEditMode()
        saveProfileImage(image: profileImage.image!)
    }
    @IBOutlet weak var editProfileButton: UIButton!
    @IBAction func editProfileAction(_ sender: Any) {
        enableEditMode()
    }
    
    var delegate: ImageDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            self.isModalInPresentation = true
        } else {
            // Fallback on earlier versions
        }
        profileImage.makeRounded()
        changeProfileImageButton.layer.cornerRadius =  changeProfileImageButton.frame.height / 2
        imagePicker.delegate = self
        setProfileImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let image = self.profileImage.image{
            delegate?.passImage(image: image)
        }
    }
    
    // MARK: Showing Action sheet for image chosing
    func showActionSheet(_ sender: UIButton) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))

        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))

        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }

        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: openCamera function
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.cameraCaptureMode = .photo
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    // MARK: openGallery function
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: imagePickerController
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                self.profileImage.image = image
            }
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Save profile image to file
    func saveProfileImage(image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return
        }
        do {
            try data.write(to: directory.appendingPathComponent("profilePicture.png")!)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: Read profile image from file
    func getSavedProfileImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
    
    func setProfileImage(){
        if let image = getSavedProfileImage(named: "profilePicture") {
            profileImage.image = image
        }
    }
    
    // MARK: Enable Edit mode
    func enableEditMode(){
        closeButton.isHidden = true
        cancelButton.isHidden = false
        saveButton.isHidden = false
        changeProfileImageButton.isHidden = false
        editProfileButton.isHidden = true
    }
    
    // MARK: Disable Edit mode
    func disableEditMode(){
        closeButton.isHidden = false
        cancelButton.isHidden = true
        saveButton.isHidden = true
        changeProfileImageButton.isHidden = true
        editProfileButton.isHidden = false
    }
}

protocol ImageDataDelegate {
    func passImage(image: UIImage)
}

// MARK: Extension which make image rounded
extension UIImageView {
    func makeRounded() {
        self.layer.borderWidth = 0
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.cornerRadius = 40
        self.clipsToBounds = true
    }
}

// MARK: Designable extension for UIButton
@IBDesignable extension UIButton {
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
    
    @IBInspectable var background: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.backgroundColor = uiColor.cgColor
        }
        get {
            guard let color = layer.backgroundColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}
