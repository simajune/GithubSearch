

import Foundation
import Alamofire

class GithubAPIManager {
    
    static let shared = GithubAPIManager()
    
    func searchList(from str: String, completion: @escaping ([GithubUserModel]) -> ()) {
        //search할 때 사용될 매개변수
        
        let params = ["q": str]
        
        Alamofire.request(SEARCH_URL, method: .get, parameters: params)
            .responseData { (reponse) in
                var githubUserModel: [GithubUserModel] = []
                guard let value = reponse.result.value as? Data else { return }
        }
    }
}
