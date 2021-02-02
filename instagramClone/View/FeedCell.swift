//
//  FeedCell.swift
//  instagramClone
//
//  Created by dev.geeyong on 2021/02/02.
//

import UIKit

class FeedCell: UICollectionViewCell{
    //MARK: - Properties
    
    private let profileImageView: UIImageView = {
        
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true //false이면 이미지를 코너를 radius를 만드는데 안에 텍스트를 유지하고 만듬
        iv.isUserInteractionEnabled = true //isUserInteractionEnabled는 유저의 이벤트가 event queue로 부터 무시되고 삭제됐는지 판단하는 Boolean 값입니다. true = event는 정상적으로 view에게 전달
        iv.image = #imageLiteral(resourceName: "venom-7")
        return iv
    }()
    
    private lazy var usernameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("venom", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.addTarget(self, action: #selector(didTapUsername), for: .touchUpInside)
        return button
    }()
    private let postImageVIew: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true //false이면 이미지를 코너를 radius를 만드는데 안에 텍스트를 유지하고 만듬
        iv.isUserInteractionEnabled = true //isUserInteractionEnabled는 유저의 이벤트가 event queue로 부터 무시되고 삭제됐는지 판단하는 Boolean 값입니다. true = event는 정상적으로 view에게 전달
        iv.image = #imageLiteral(resourceName: "venom-7")
        return iv
    }()
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "like_unselected"), for: .normal)
        button.tintColor = .black
        return button
    }()
    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "send2"), for: .normal)
        button.tintColor = .black
        return button
    }()
    private lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "comment"), for: .normal)
        button.tintColor = .black
        return button
    }()
    private var likeLabel: UILabel = {
        let label = UILabel()
        label.text = "1 like"
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    private var captionLabel: UILabel = {
        let label = UILabel()
        label.text = "댓글 테스트"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    private var postTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "1 day ago"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 12)
        profileImageView.setDimensions(height: 40, width: 40)
        profileImageView.layer.cornerRadius = 40 / 2
        
        addSubview(usernameButton)
        usernameButton.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 8)
        
        addSubview(postImageVIew)
        postImageVIew.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8)
        postImageVIew.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        configureActionButton()
        
        addSubview(likeLabel)
        likeLabel.anchor(top: likeButton.bottomAnchor, left: leftAnchor, paddingTop: -4, paddingLeft: 8)
        addSubview(captionLabel)
        captionLabel.anchor(top: likeLabel.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 8)
        addSubview(postTimeLabel)
        postTimeLabel.anchor(top: captionLabel.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 8)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Actions
    
    @objc func didTapUsername(){
        print("did  tap username")
    }
    //MARK: - Helpers
    func configureActionButton(){
        let stackView = UIStackView(arrangedSubviews: [likeButton,commentButton,shareButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.anchor(top: postImageVIew.bottomAnchor, width: 120, height: 50)
    }
    
}
