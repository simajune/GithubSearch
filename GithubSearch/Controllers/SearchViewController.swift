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

class SearchViewController: UIViewController {
    
    //MARK: - Property
    var userList: [GithubUserModel] = []
    let disposeBag = DisposeBag()
    
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
    }
    
    //MARK: - Method
    private func setController(){
        mainSearchBar.delegate = self
        
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
        print("cellForRows")
        cell.setUI(user: self.userList[indexPath.row])
        return cell
    }
    
    
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? UserListCell else{
            fatalError("Not found UserListCell")
        }
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}

extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
}
