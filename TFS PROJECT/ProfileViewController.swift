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
    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func editProfileAction(_ sender: Any) {
    }
    @IBOutlet weak var editProfileButton: UIButton!
    
    /* На этом этапе еще нет ни самой view, и нет аутлетов
    из-за этого фатальная ошибка
    Fatal error: Unexpectedly found nil while unwrapping an Optional value
    при вызове print("\(#function)  \(editProfileButton.frame)")*/
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /* На данном этапе размеры view не такие, какими они будут после вывода на экран.
     Поэтому, использовать вычисления, основанные на ширине / высоте view, в методе viewDidload не рекомендуется. */
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(#function) \(editProfileButton.frame)")
        profileImage.makeRounded()
        changeProfileImageButton.layer.cornerRadius =  changeProfileImageButton.frame.height / 2
        imagePicker.delegate = self
    }
    
    /* При вызове viewWillAppear, view уже находится в иерархии отображения (view hierarchy) и имеет актуальные размеры, так, что здесь можно производить расчеты, основанные на ширине / высоте view.
     так как viewDidAppear вызываеться после viewWillAppear у него уже тоже актуальные размеры */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("\(#function) \(editProfileButton.frame)")
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
