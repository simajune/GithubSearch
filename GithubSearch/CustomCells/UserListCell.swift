
import UIKit
import Kingfisher

protocol UserListCellDelegate {
    func clicked()
}

class UserListCell: UITableViewCell {
    
    //MARK:: - Property
    var isClicked: Bool = false
    
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
    
    //기업 리스트 뷰
    let orgScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .green
        return scrollView
    }()
    
    //기업 리스트 뷰
    let orgView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    //기업 이미지 뷰
    let orgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.borderWidth = 0.5
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    //MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setView()
        print("init")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print("prepare")
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
        let tapGetsture = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        
        self.addSubview(baseView)
        self.baseView.addSubview(profileImageView)
        self.baseView.addSubview(usernameLabel)
        self.baseView.addSubview(scoreLabel)
        self.baseView.addSubview(orgScrollView)
        self.orgScrollView.addSubview(orgView)
        
        self.addGestureRecognizer(tapGetsture)
        
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
        
        self.orgScrollView.snp.makeConstraints{
            $0.top.equalTo(self.profileImageView.snp.bottom).offset(3)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0)
            $0.leading.equalTo(profileImageView)
            $0.trailing.equalToSuperview()
        }
    }
    
    @objc func tapAction(_ sender: UITapGestureRecognizer){
        print("눌렸다")
        if(isClicked){
            self.isClicked = false
        }else{
            self.isClicked = true
        }
    }
    
    func setUI(user: GithubUserModel){
        self.profileImageView.kf.setImage(with: URL(string: user.avatar_url))
        self.usernameLabel.text = user.login
        self.scoreLabel.text = "score: \(user.score)"
        //        if(user.isClicked){
        //            self.orgScrollView.snp.updateConstraints{
        //                $0.height.equalTo(40)
        //            }
        //        }else{
        //            self.orgScrollView.snp.updateConstraints{
        //                $0.height.equalTo(0)
        //            }
        //        }
    }
}
