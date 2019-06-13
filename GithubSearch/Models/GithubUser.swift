//
//  GithubUser.swift
//  GithubSearch
//
//  Created by SIMA on 13/06/2019.
//  Copyright © 2019 TJ. All rights reserved.
//

import Foundation
import RealmSwift

class GithubUser: Object {
    @objc dynamic var avatar_url: String = ""
    @objc dynamic var login: String = ""
    @objc dynamic var score: Double = 0
    @objc dynamic var isLike: Bool = false
}
