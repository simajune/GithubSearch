//
//  SearchViewController.swift
//  GithubSearch
//
//  Created by SIMA on 07/06/2019.
//  Copyright © 2019 TJ. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON
import RxSwift
import RxCocoa
import RealmSwift

class SearchViewController: UIViewController {
    
    //MARK: - Property
    var userList: [GithubUserModel] = []
    var disposeBag = DisposeBag()
    var user = GithubUser()
    var realm = try! Realm()
    lazy var users: Results<GithubUser> = { self.realm.objects(GithubUser.self) }()
    
    let mainSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        let textField: UITextField = searchBar.value(forKey: "searchField") as! UITextField
        textField.backgroundColor = .lightGray
        textField.textColor = .white
        searchBar.barTintColor = .white
        searchBar.tintColor = .white
        searchBar.layer.borderColor = UIColor.white.cgColor
        searchBar.layer.backgroundColor = UIColor.white.cgColor
        return searchBar
    }()
    
    let mainTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    let emptyView: UIView = {
        let view = UIView()
        return view
    }()
    
    var userListCell: UserListCell?
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setController()
        self.view.backgroundColor = .white
        self.title = "HOME"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setReactive()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        disposeBag = DisposeBag()
    }
    
    //MARK: - Method
    private func setController(){
        mainSearchBar.delegate = self
        
        mainTableView.register(UserListCell.self, forCellReuseIdentifier: "Cell")
        userListCell = UserListCell(style: .default, reuseIdentifier: "Cell")
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.estimatedRowHeight = 100
        mainTableView.rowHeight = UITableView.automaticDimension
        
        self.view.addSubview(mainTableView)
        self.view.addSubview(mainSearchBar)
        
        mainSearchBar.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.left.equalTo(self.view)
            $0.right.equalTo(self.view)
        }
        
        mainTableView.snp.makeConstraints {
            $0.top.equalTo(self.mainSearchBar.snp.bottom)
            $0.left.equalTo(self.view)
            $0.right.equalTo(self.view)
            $0.bottom.equalTo(self.view)
        }
    }
    
    private func setReactive(){
        mainSearchBar.rx.text.orEmpty
            .debounce(0.5, scheduler: MainScheduler.instance)
            .subscribe(onNext: { text in
                if(text == ""){
                    self.userList.removeAll()
                    self.mainTableView.reloadData()
                }else{
                    let params = ["q": text]
                    Alamofire.request(SEARCH_URL, method: .get, parameters: params).validate()
                        .responseJSON { (resposne) in
                            self.userList.removeAll()
                            print(resposne)
                            guard let users: [JSON] = JSON(resposne.result.value as Any)["items"].array else { return }
                            
                            for user in users {
                                if let userData = GithubUserModel(json: user) {
                                    self.userList.append(userData)
                                }
                            }
                            self.mainTableView.reloadData()
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
}

extension SearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? UserListCell else {
            fatalError("Not found UserListCell")
        }
        cell.delegate = self
        print(self.userList[indexPath.row].isLike)
        cell.setUI(user: self.userList[indexPath.row], at: indexPath.row)
        return cell
    }
    
    
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}

extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
}

extension SearchViewController: UserListCellDelegate {
    func clicked(iSelected: Bool, index: Int) {
        if(iSelected){
            print(self.userList)
            self.userList[index].isLike = true
            try! realm.write {
                let newGithubUser = GithubUser()
                newGithubUser.avatar_url = self.userList[index].avatar_url
                newGithubUser.login = self.userList[index].login
                newGithubUser.score = self.userList[index].score
                newGithubUser.isLike = self.userList[index].isLike
                
                realm.add(newGithubUser)
            }
            
            print(realm.objects(GithubUser.self))
            
        }else{
            
            try! realm.write {
                let newGithubUser = GithubUser()
                newGithubUser.avatar_url = self.userList[index].avatar_url
                newGithubUser.login = self.userList[index].login
                newGithubUser.score = self.userList[index].score
                newGithubUser.isLike = self.userList[index].isLike
                
                realm.delete(newGithubUser)
            }
            self.userList[index].isLike = false
        }
    }
}
