//
//  CommnetKeyboardView.swift
//  instagramClone
//
//  Created by dev.geeyong on 2021/02/15.
//

import UIKit

protocol CommnetKeyboardViewDelegate: class {
    func inputView(_ inputView: CommnetKeyboardView, wantsTouploadComment comment: String)
}
class CommnetKeyboardView: UIView {
    //MARK: - Properties
    
    weak var delegate: CommnetKeyboardViewDelegate?
    private let commentTextView: InputTextView = {
       let tv = InputTextView()
        tv.placeholderText = "댓글을 입력해주세요."
        tv.font = UIFont.systemFont(ofSize: 15)
        tv.isScrollEnabled = false //키보드커스텀
        return tv
    }()
    
    private let postButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("입력", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handlePostTapped), for: .touchUpInside)
        return button
    }()
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        autoresizingMask = .flexibleHeight
        addSubview(postButton)
        postButton.anchor(top: topAnchor, right: rightAnchor, paddingRight: 8)
        postButton.setDimensions(height: 50, width: 50)
        
        addSubview(commentTextView)
        commentTextView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: postButton.leftAnchor,
                               paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        
        let divider = UIView()
        divider.backgroundColor = .lightGray
        addSubview(divider)
        divider.anchor(top: topAnchor, left:  leftAnchor, right: rightAnchor, height: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override var intrinsicContentSize: CGSize{ //키보드커스텀
        return .zero
    }
    //MARK: - Actions
    
    @objc func handlePostTapped(){
        delegate?.inputView(self, wantsTouploadComment: commentTextView.text)
    }
    
    func clearCommnetTextView(){
        commentTextView.text = nil
        commentTextView.placeholderLabel.isHidden = false
    }
}
