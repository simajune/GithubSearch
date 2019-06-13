
import UIKit
import Kingfisher

protocol UserListCellDelegate {
    func clicked(iSelected: Bool, index: Int)
}

class UserListCell: UITableViewCell {
    
    //MARK:: - Property
    var isClicked: Bool = false
    var index: Int?
    var delegate: UserListCellDelegate?
    
    //컨텐츠 뷰
    let baseView: UIView = {
        let view = UIView()
        return view
    }()
    
    //썸네일 이미지
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        return imageView
    }()
    
    //유저 레이블
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .bold)
        label.textColor = .black
        label.text = "유저이름"
        return label
    }()
    
    //스코어 레이블
    let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        label.textColor = .gray
        label.text = "스코어"
        return label
    }()
    
    //좋아요 버튼
    let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "EmptyLike"), for: .normal)
        button.setImage(UIImage(named: "SelectedLike"), for: .selected)
        return button
    }()
    
    //MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("awakFromNib")
    }
    
    //MARK: - Method
    private func setView(){
        
        self.addSubview(baseView)
        self.baseView.addSubview(profileImageView)
        self.baseView.addSubview(usernameLabel)
        self.baseView.addSubview(scoreLabel)
        self.baseView.addSubview(likeButton)
        
        self.baseView.snp.makeConstraints {
            $0.top.leading.equalTo(self).offset(25)
            $0.bottom.trailing.equalTo(self).offset(-25)
        }
        
        self.profileImageView.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        self.usernameLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(self.profileImageView.snp.trailing).offset(5)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(self.scoreLabel)
        }
        
        self.scoreLabel.snp.makeConstraints {
            $0.top.equalTo(self.usernameLabel.snp.bottom).offset(3)
            $0.leading.equalTo(self.usernameLabel)
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(self.profileImageView.snp.bottom)
        }
        
        self.likeButton.snp.makeConstraints{
            $0.width.height.equalTo(20)
            $0.centerY.equalTo(baseView)
            $0.trailing.equalToSuperview()
        }
        
        self.likeButton.addTarget(self, action: #selector(likeButtonAction(_:)), for: .touchUpInside)
    }
    
    @objc private func likeButtonAction(_ sender: UIButton) {
        guard let index = index else { return }
        if(sender.isSelected){
            print("안눌림")
            delegate?.clicked(iSelected: false, index: index)
            sender.isSelected = false
        }else{
            delegate?.clicked(iSelected: true, index: index)
            print("눌림")
            sender.isSelected = true
        }
    }
    
    func setUI(user: GithubUserModel, at index: Int){
        self.index = index
        self.profileImageView.kf.setImage(with: URL(string: user.avatar_url))
        self.usernameLabel.text = user.login
        self.scoreLabel.text = "score: \(user.score)"
        self.likeButton.isSelected = user.isLike
    }
    
    func setUI(user: [String: Any], at index: Int){
        self.index = index
        self.profileImageView.kf.setImage(with: URL(string: user["avatar_url"] as! String))
        self.usernameLabel.text = user["login"] as? String
        self.scoreLabel.text = "score: \(user["score"] as! Double)"
        self.likeButton.isSelected = user["isLike"] as! Bool
    }
    
    func setUI(user: GithubUser, at index: Int){
        self.index = index
        self.profileImageView.kf.setImage(with: URL(string: user.avatar_url))
        self.usernameLabel.text = user.login
        self.scoreLabel.text = "score: \(user.score)"
        self.likeButton.isSelected = user.isLike
    }
}
