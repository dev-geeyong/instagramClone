//
//  CommentCell.swift
//  instagramClone
//
//  Created by dev.geeyong on 2021/02/15.
//

import UIKit

class CommentCell: UICollectionViewCell {
    //MARK: - Properties
    
    private let profileImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let commentLable: UILabel = {
        let label = UILabel()
        
        let attributedString = NSMutableAttributedString(string: "joker ", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedString.append(NSAttributedString(string: "댓글 테스트입니다..", attributes: [.font: UIFont.systemFont(ofSize: 14)]))
        
        label.attributedText = attributedString
        return label
    }()
    
   
    //MARK: - Lifecycle
    
    override init(frame: CGRect){
        super.init(frame: frame)
        addSubview(profileImageView)
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 8)
        profileImageView.setDimensions(height: 40, width: 40)
        profileImageView.layer.cornerRadius = 40/2
        
        addSubview(commentLable)
        commentLable.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
