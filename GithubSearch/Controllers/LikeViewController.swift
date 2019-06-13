//
//  LikeViewController.swift
//  GithubSearch
//
//  Created by SIMA on 07/06/2019.
//  Copyright © 2019 TJ. All rights reserved.
//

import UIKit
import RealmSwift

class LikeViewController: UITableViewController {
    
    var userListCell: UserListCell?
    let realm = try! Realm()
    var users: Results<GithubUser>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UserListCell.self, forCellReuseIdentifier: "Cell")
        userListCell = UserListCell(style: .default, reuseIdentifier: "Cell")
        self.users = self.realm.objects(GithubUser.self)
        self.title = "LIKE"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? UserListCell else {
            fatalError("Not found UserListCell")
        }
        cell.delegate = self
//        print(self.users?[indexPath.row].isLike)
        cell.setUI(user: (self.users?[indexPath.row])!, at: indexPath.row)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension LikeViewController: UserListCellDelegate {
    func clicked(iSelected: Bool, index: Int) {
        
    }
    
    
}
