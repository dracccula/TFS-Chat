//
//  ProfileViewController.swift
//  TFS PROJECT
//
//  Created by Vladislav Kireev on 20.02.2020.
//  Copyright © 2020 VK. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIApplicationDelegate, UITextViewDelegate {
    
    
    @IBOutlet weak var profilePicture: UIImageView!
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
        disableEditMode()
        loadProfileData(dataManager: self.gcdDataManager)
    }
    @IBOutlet weak var saveButton: UIButton!
    @IBAction func saveButtonAction(_ sender: Any) {
        disableEditMode()
        saveProfileData(sender: gcdButton)
    }
    @IBOutlet weak var nameTextView: UITextView!
    @IBOutlet weak var aboutTextView: UITextView!
    
    @IBOutlet weak var editProfileButton: UIButton!
    @IBAction func editProfileAction(_ sender: Any) {
        enableEditMode()
    }
    @IBOutlet weak var gcdButton: UIButton!
    @IBAction func gcdButtonAction(_ sender: Any) {
        disableEditMode()
        saveProfileData(sender: gcdButton)
    }
    @IBOutlet weak var operationButton: UIButton!
    @IBAction func operationButtonAction(_ sender: Any) {
        disableEditMode()
        saveProfileData(sender: operationButton)
    }
    private let gcdDataManager = GCDDataManager()
    private let operationDataManager = OperationDataManager()
    var loadedProfileData: ProfileData = ProfileData()
    
    var delegate: InfoDataDelegate?
    private let spinner = Spinner()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            self.isModalInPresentation = true
        } else {
            // Fallback on earlier versions
        }
        profilePicture.makeRounded()
        changeProfileImageButton.layer.cornerRadius =  changeProfileImageButton.frame.height / 2
        imagePicker.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.hideKeyboardWhenTappedAround()
        self.loadProfileData(dataManager: self.gcdDataManager)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.passInfo()
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -250
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0
        self.view.setNeedsLayout()
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
    private var isUserPictureChanged = false
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.profilePicture.image = image
            self.isUserPictureChanged = true
            self.profileDataChanged()
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
            try data.write(to: directory.appendingPathComponent("profilePicture")!)
        } catch {
            print(error.localizedDescription)
        }
    }
    
//    // MARK: Enable button function
//    func setEnableButton(button: UIButton, enable: Bool) {
//        if enable {
//            button.isEnabled = true
//            button.alpha = 1
//        } else {
//            button.isEnabled = false
//            button.alpha = 0.5
//        }
//    }
    
    
    // MARK: Profile data change check
    @objc func profileDataChanged() {
        if  nameTextView.text == loadedProfileData.name &&
            aboutTextView.text == (loadedProfileData.about ?? "") &&
            !isUserPictureChanged
        {
            Utilities().setEnableButton(button: saveButton, enable: false)
            Utilities().setEnableButton(button: gcdButton, enable: false)
            Utilities().setEnableButton(button: operationButton, enable: false)
        } else {
            Utilities().setEnableButton(button: saveButton, enable: true)
            Utilities().setEnableButton(button: gcdButton, enable: true)
            Utilities().setEnableButton(button: operationButton, enable: true)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.profileDataChanged()
    }
    
    // MARK: Save profile data
    func saveProfileData(sender: UIButton!) {
        self.spinner.showActivityIndicator(uiView: self.view)
        
        let dataManager: ProfileDataManager = sender == gcdButton ? gcdDataManager : operationDataManager
        
        let onError = { [weak self] in
            let alert = UIAlertController(title: "Error", message: "Saving not succeed", preferredStyle: .alert)
            let retrySaveAction = UIAlertAction(title: "Retry", style: .default) { (action:UIAlertAction!) in
                alert.dismiss(animated: false)
                self?.saveProfileData(sender: sender)
            }
            let cancelAction = UIAlertAction(title: "OK", style: .cancel)
            
            alert.addAction(cancelAction)
            alert.addAction(retrySaveAction)
            
            self?.present(alert, animated: true)
            self?.spinner.hideActivityIndicator(uiView: self!.view)
        }
        
        let completion =  { [weak self] in
            let alert = UIAlertController(title: "Success", message: "Profile information saved", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel) { UIAlertAction in
                self?.spinner.hideActivityIndicator(uiView: self!.view)
                self?.loadProfileData(dataManager: dataManager) {
                    self?.disableEditMode()
                }
                
            }
            alert.addAction(cancelAction)
            
            self?.present(alert, animated: true)
        }
        
        let profileData = ProfileData()
        
        if nameTextView.text != loadedProfileData.name {
            profileData.name = nameTextView.text
        }

        if aboutTextView.text != loadedProfileData.about {
            profileData.about = aboutTextView.text
        }

        if isUserPictureChanged {
            profileData.picture = profilePicture.image
        }
        
        dataManager.saveProfileData(profileData: profileData, onError: onError, completion: completion)
    }
    
    // MARK: Load profile data
    private func loadProfileData(dataManager: ProfileDataManager, _ completion: (()->())? = nil) {
        self.spinner.showActivityIndicator(uiView: self.view)
        
        dataManager.readProfileData { [weak self] (profileData) -> Void in
            if profileData.name == nil {
                profileData.name = ""
            }
            if profileData.about == nil {
                profileData.about = ""
            }
            self?.loadedProfileData = profileData
            self?.nameTextView.text = profileData.name
            self?.aboutTextView.text = profileData.about
            if let image = profileData.picture {
                self?.profilePicture.image = image
            } else {
                self?.profilePicture.image = UIImage(named:"placeholder-user")
            }
            
            self?.spinner.hideActivityIndicator(uiView: self!.view)
            completion?()
        }
    }
    
    // MARK: Enable Edit mode
    func enableEditMode(){
        closeButton.isHidden = true
        cancelButton.isHidden = false
        saveButton.isHidden = false
        changeProfileImageButton.isHidden = false
        // TODO: Make enable/disable textview function
        nameTextView.isEditable = true
        Utilities().drawBorder(textView: nameTextView)
        nameTextView.delegate = self
        aboutTextView.isEditable = true
        Utilities().drawBorder(textView: aboutTextView)
        aboutTextView.delegate = self
        editProfileButton.isHidden = true
//        gcdButton.isHidden = false
//        operationButton.isHidden = false
        self.profileDataChanged()
    }
    
    // MARK: Disable Edit mode
    func disableEditMode(){
        closeButton.isHidden = false
        cancelButton.isHidden = true
        saveButton.isHidden = true
        changeProfileImageButton.isHidden = true
        nameTextView.isEditable = false
        nameTextView.layer.borderWidth = 0
        aboutTextView.isEditable = false
        aboutTextView.layer.borderWidth = 0
        editProfileButton.isHidden = false
//        gcdButton.isHidden = true
//        operationButton.isHidden = true
    }
}

protocol InfoDataDelegate {
    func passInfo()
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
