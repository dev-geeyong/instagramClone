//
//  FeedCell.swift
//  instagramClone
//
//  Created by dev.geeyong on 2021/02/02.
//

import UIKit

protocol FeedCellDelegate: class {
    func cell(_ cell: FeedCell, wantsToShowCommentsFor post: Post)
    func cell(_ cell: FeedCell, didLike post: Post)
    func cell(_ cell: FeedCell, wantsToShowProfileFor uid: String)
}

class FeedCell: UICollectionViewCell{
    //MARK: - Properties
    
    var viewModel: PostViewModel? {
        didSet {configure()}
    }
    
    weak var delegate: FeedCellDelegate?
    private lazy var profileImageView: UIImageView = {
        
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true //false이면 이미지를 코너를 radius를 만드는데 안에 텍스트를 유지하고 만듬
        iv.isUserInteractionEnabled = true //isUserInteractionEnabled는 유저의 이벤트가 event queue로 부터 무시되고 삭제됐는지 판단하는 Boolean 값입니다. true = event는 정상적으로 view에게 전달
        iv.backgroundColor = .lightGray
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapUsername))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tap)
        
        return iv
    }()
    
    private lazy var usernameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.black, for: .normal)
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
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "like_unselected"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didtapLikeButton), for: .touchUpInside)
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
        button.addTarget(self, action: #selector(didTapComments), for: .touchUpInside)
        return button
    }()
    private var likeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    private var captionLabel: UILabel = {
        let label = UILabel()
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
    @objc func didTapComments(){
        guard let viewModel = viewModel else{return}
        delegate?.cell(self, wantsToShowCommentsFor: viewModel.post)
    }
    @objc func didTapUsername(){
        guard let viewModel = viewModel else {
            return
        }
        delegate?.cell(self, wantsToShowProfileFor: viewModel.post.ownerUid)
    }
    @objc func didtapLikeButton(){
        guard let viewModel = viewModel else{return}
        delegate?.cell(self, didLike: viewModel.post)
        
    }
    //MARK: - Helpers
    func configure(){
        guard let viewModel = viewModel else{return}
        captionLabel.text = viewModel.caption
        postImageVIew.sd_setImage(with: viewModel.imageURL)
        likeLabel.text = viewModel.likeString
        profileImageView.sd_setImage(with: viewModel.userProfileImageUrl)
        usernameButton.setTitle(viewModel.username, for: .normal)
        
        likeButton.tintColor = viewModel.likeButtonTintColor
        likeButton.setImage(viewModel.likeButtonImage, for: .normal)
        
    }
    func configureActionButton(){
        let stackView = UIStackView(arrangedSubviews: [likeButton,commentButton,shareButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.anchor(top: postImageVIew.bottomAnchor, width: 120, height: 50)
    }
    
}
