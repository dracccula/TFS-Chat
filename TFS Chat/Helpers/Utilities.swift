//
//  Helpers.swift
//  TFS Chat
//
//  Created by Vladislav Kireev on 11.04.2020.
//  Copyright © 2020 VK. All rights reserved.
//

import UIKit

public class Utilities {
    
    // MARK: Enable button function
    func setEnableButton(button: UIButton, enable: Bool) {
        if enable {
            button.isEnabled = true
            button.alpha = 1
        } else {
            button.isEnabled = false
            button.alpha = 0.5
        }
    }
    
    func drawBorder(textView: UITextView) {
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 5
    }
}
