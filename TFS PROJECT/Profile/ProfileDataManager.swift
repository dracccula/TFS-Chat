//
//  ProfileDataManager.swift
//  TFS PROJECT
//
//  Created by Vladislav Kireev on 21.03.2020.
//  Copyright © 2020 VK. All rights reserved.
//

protocol ProfileDataManager {
    func readProfileData(completion: @escaping (_: ProfileData) -> Void)
    func saveProfileData (profileData: ProfileData, onError: @escaping () -> Void, completion: @escaping () -> Void)
}
