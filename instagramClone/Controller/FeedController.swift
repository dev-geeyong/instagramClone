//
//  FeedController.swift
//  instagramClone
//
//  Created by dev.geeyong on 2021/02/02.
//

import  UIKit
import Firebase
private let reuseIdentifier = "Cell"


class FeedController: UICollectionViewController {
    //MARK: - Lifecycle
    private var posts = [Post](){
        didSet {  collectionView.reloadData()}
    }
    
    var selectPost: Post? {
        didSet{
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchPosts()
        if selectPost != nil {
            checkIfUserLikedPosts()
        }
        
    }
    
    //MARK: - Actions
    @objc func pushLogoutButton(){
        do{
            try Auth.auth().signOut()
            let controller = LoginController()
            controller.delegate = self.tabBarController as? MainTabController
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }catch{
            print("debug: failed to sgin out")
        }
        
    }
    @objc func handeleRefresh(){
        posts.removeAll()
        fetchPosts()
    }
    //MARK: - API
    func fetchPosts(){
        guard selectPost == nil else {return}
//        PostService.fetchPosts {posts in
//
//
//        }
        PostService.fetchFeedPosts { posts in
            self.posts = posts
            self.collectionView.refreshControl?.endRefreshing()
            self.checkIfUserLikedPosts()
        }
    }
    func checkIfUserLikedPosts(){
        if let selectPost = selectPost {
            PostService.checkIfUserLikedPost(post: selectPost) { didLike in
                self.selectPost?.didLike = didLike

            }
        }else{
        self.posts.forEach { post in
            PostService.checkIfUserLikedPost(post: post){didLike in
                if let index = self.posts.firstIndex(where: {$0.postId == post.postId}){
                    self.posts[index].didLike = didLike
                }
            }
        }
        }
    }
    //MARK: - helpers
    
    func configureUI(){
        collectionView.backgroundColor = .white
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        if selectPost == nil{
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout",
                                                               style: .plain,
                                                               target: self,
                                                               action: #selector(pushLogoutButton))
            navigationItem.title = "Feed"
            
            let refresher = UIRefreshControl()
            refresher.addTarget(self, action: #selector(handeleRefresh), for: .valueChanged)
            collectionView.refreshControl = refresher
            
        }
        
    }
    
}




//MARK: - UICollectionViewDataSource

extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectPost == nil ? posts.count : 1
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        cell.delegate = self
        if let selectPost = selectPost {
            cell.viewModel = PostViewModel(post: selectPost)
        }else{
            cell.viewModel = PostViewModel(post: posts[indexPath.row])
            
        }
        return cell
    }
}
//MARK: - UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        var height = width + 8 + 40 + 8
        height = height + 50
        height = height + 60
        
        return CGSize(width: width, height: height)
    }
}

extension FeedController: FeedCellDelegate{
    func cell(_ cell: FeedCell, wantsToShowProfileFor uid: String) {
        UserService.fetchUser(withUid: uid){ user in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
            
        }
    }
    
    func cell(_ cell: FeedCell, wantsToShowCommentsFor post: Post) {
        let controller = CommentController(post: post)
        navigationController?.pushViewController(controller, animated: true)
        
    }
    func cell(_ cell: FeedCell, didLike post: Post) {
        guard let tab = tabBarController as? MainTabController else{return}
        guard let user = tab.user else {return}
        
        cell.viewModel?.post.didLike.toggle()
        
        if post.didLike{
            PostService.unlikePost(post: post) { error in
                if let error = error {
                    print("unlike error")
                }
                cell.likeButton.setImage(#imageLiteral(resourceName: "like_unselected"), for: .normal)
                cell.likeButton.tintColor = .black
                cell.viewModel?.post.likes = post.likes - 1
            }
        }else{
            PostService.likePost(post: post) { error in
                if let error = error {
                    print("like error")
                }
                cell.likeButton.setImage(#imageLiteral(resourceName: "like_selected"), for: .normal)
                cell.likeButton.tintColor = .red
                cell.viewModel?.post.likes = post.likes + 1
                NotificationService.uploadNotification(toUid: post.ownerUid, fromUser: user, type: .like, post: post)
            }
        }
    }
}
