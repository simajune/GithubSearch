//
//  GithubUserModel.swift
//  GithubSearch
//
//  Created by SIMA on 07/06/2019.
//  Copyright © 2019 TJ. All rights reserved.
//

import SwiftyJSON

class GithubUserModel {
    
    var avatar_url: String
    var login: String
    var score: Double
    var isLike: Bool = false
    
    init?(dic: [String: Any]) {
        guard let avatar_url = dic["avatar_url"] as? String else{ return nil }
        self.avatar_url = avatar_url
        guard let login = dic["login"] as? String else { return nil }
        self.login = login
        guard let score = dic["score"] as? Double else { return nil }
        self.score = score
    }
    
    init?(json: JSON) {
        guard let avatar_url = json["avatar_url"].string else { return nil }
        self.avatar_url = avatar_url
        guard let login = json["login"].string else { return nil }
        self.login = login
        guard let score = json["score"].double else { return nil }
        self.score = score
    }
}
