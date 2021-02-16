//
//  CommentController.swift
//  instagramClone
//
//  Created by dev.geeyong on 2021/02/15.
//

import UIKit

private let reuseIdentifier = "CommentCell"

class CommentController: UICollectionViewController{
    
    //MARK: - Properties
    private let post: Post
    private var comments = [Comment]()
    private lazy var commnetInputView: CommnetKeyboardView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let cv = CommnetKeyboardView(frame: frame)
        cv.delegate = self
        return cv
    }()
    //MARK: - Lifecycle
    init(post: Post){
        self.post = post
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchComments()
    }
    
    override var inputAccessoryView: UIView?{ //키보드커스텀
        get {return commnetInputView}
    }
    override var canBecomeFirstResponder: Bool{ //키보드커스텀
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) { 
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    //MARK: - API
    
    func fetchComments(){
        CommentService.fetchComments(forPost: post.postId) { comments in
            self.comments = comments
            self.collectionView.reloadData()
        }
    }
    //MARK: - Helpers
    func configureCollectionView(){
        collectionView.backgroundColor = .white
        navigationItem.title = "댓글"
        collectionView.register(CommentCell.self , forCellWithReuseIdentifier: reuseIdentifier)
       //키보드내리기
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
    }
    
}
//MARK: - UICollectionViewControllerdatasorce
extension CommentController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CommentCell
        cell.viewModel = CommentViewModel(comment: comments[indexPath.row])
        
        return cell
    }
}
//MARK: - UICollectionViewDelegateFlowLayout

extension CommentController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = CommentViewModel(comment: comments[indexPath.row])
        //댓글 동적 셀 높이 설정
        let height = viewModel.size(forWidth: view.frame.width).height + 32
        return CGSize(width: view.frame.width, height: height)
    }
}

//MARK: - UICollectionViewDelegate
extension CommentController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let uid = comments[indexPath.row].uid
        UserService.fetchUser(withUid: uid) { user in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
            
        }
    }
}
//MARK: - CommnetKeyboardViewDelegate
extension CommentController: CommnetKeyboardViewDelegate{
    func inputView(_ inputView: CommnetKeyboardView, wantsTouploadComment comment: String) {
        
        showLoader(true)
        guard let tab = tabBarController as? MainTabController else {return}
        guard let user = tab.user else {return}
        CommentService.uploadComment(comment: comment, postID: post.postId, user: user) { error in
            self.showLoader(false)
            inputView.clearCommnetTextView()
            
            NotificationService.uploadNotification(toUid: self.post.ownerUid, fromUser: user, type: .comment, post: self.post)
        }
    }
    
    
}
