//
//  NotificationController.swift
//  instagramClone
//
//  Created by dev.geeyong on 2021/02/02.
//
import UIKit

private let reuseIdentifier = "NotificationCell"

class NotificationController: UITableViewController {
    
    //MARK: - Properties
    private var notification = [Notification](){
        didSet{
            tableView.reloadData()
        }
    }
    private let refresher = UIRefreshControl()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        fetchNotifications()
    }
    
    //MARK: - API
    func fetchNotifications(){
        NotificationService.fetchNotifications { notification in
            self.notification = notification
            self.checkIfUserIsFollowed()
        }
    }
    func checkIfUserIsFollowed(){
        notification.forEach{ notification in
            guard notification.type == .follow else {return}
            
            UserService.checkIfUserIsFollowed(uid: notification.uid) { isFollowed in
                if let index = self.notification.firstIndex(where: {$0.id == notification.id}){
                    self.notification[index].userIsFollowed = isFollowed
                }
            }
        }
    }
    //MARK: - Helpers
    
    func configureTableView(){
        view.backgroundColor = .white
        navigationItem.title = "알림"
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refresher
    }
    //MARK: - Actions
    @objc func handleRefresh(){
        notification.removeAll()
        fetchNotifications()
        refresher.endRefreshing()
    }
}




extension NotificationController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notification.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        cell.delegate = self
        cell.viewModel = NotificationViewModel(notification: notification[indexPath.row])
        return cell
    }
}

//MARK: - UITableViewDelegate

extension NotificationController{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showLoader(true)
        UserService.fetchUser(withUid: notification[indexPath.row].uid) { user in
            self.showLoader(false)
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
//MARK: - NotificationCellDelegate
extension NotificationController: NotificationCellDelegate{
    func cell(_ cell: NotificationCell, wantToFollow uid: String) {
        showLoader(true)
        UserService.follow(uid: uid) {_ in
            self.showLoader(false)
            cell.viewModel?.notification.userIsFollowed.toggle()
        }
    }
    
    func cell(_ cell: NotificationCell, wantToUnfollow uid: String) {
        showLoader(true)
        UserService.unfollow(uid: uid) {_ in
            self.showLoader(false)
            cell.viewModel?.notification.userIsFollowed.toggle()
        }
    }
    
    func cell(_ cell: NotificationCell, wantToViewPost uid: String) {
        showLoader(true)
        PostService.fetchPosts(withPostId: uid) { post in
            self.showLoader(false)
            let controller = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
            controller.selectPost = post
            self.navigationController?.pushViewController(controller, animated: true)
            
        }
    }
    
    
}
