//
//  CommentViewModel.swift
//  instagramClone
//
//  Created by dev.geeyong on 2021/02/16.
//

import UIKit

struct CommentViewModel {
    
    private let comment: Comment
    
    var profileImageURL: URL?{
        return URL(string: comment.profileImageURL)
    }
    
    init(comment: Comment){
        self.comment = comment
    }
    func commentLabelText() -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: "\(comment.username) ", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedString.append(NSAttributedString(string: comment.commentText, attributes: [.font: UIFont.systemFont(ofSize: 14)]))
        return attributedString
    }
    func size(forWidth width: CGFloat) -> CGSize {   //댓글 동적 셀 높이 설정
        let label = UILabel()
        label.numberOfLines = 0
        label.text = comment.commentText
        label.lineBreakMode = .byWordWrapping
        label.setWidth(width)
        return label.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
}
