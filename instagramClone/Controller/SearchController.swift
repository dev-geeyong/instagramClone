//
//  SearchController.swift
//  instagramClone
//
//  Created by dev.geeyong on 2021/02/02.
//

import  UIKit

private let reuseIdentifier = "UserCell"
private let postCellIdentifier = "ProfileCell"
class SearchController: UIViewController {
    //MARK: - Properties
    private let tableView = UITableView()
    private var users = [User]()
    private var posts = [Post]()
    private var filteredUsers = [User]()
    private let searchController = UISearchController(searchResultsController: nil)
    private var isSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    private lazy var collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.register(ProfileCell.self, forCellWithReuseIdentifier: postCellIdentifier)
        return cv
    }()
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        configureUI()
        fetchUsers()
        fetchPost()
    }
    //MARK: - API
    
    func fetchUsers(){
        UserService.fetchUsers { users in
            self.users = users
            self.tableView.reloadData()
        }
    }
    func fetchPost(){
        PostService.fetchPosts { post in
            self.posts = post
            self.collectionView.reloadData()
        }
    }
    //MARK: - Helpers
    
    func configureUI(){
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 64
        
        view.addSubview(tableView)
        tableView.fillSuperview()
        
        view.addSubview(collectionView)
        collectionView.fillSuperview()
        
        tableView.isHidden = true
        
    }
    func configureSearchController(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
}
//MARK: - UITableViewDataSource

extension SearchController: UITableViewDataSource {
    
 
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchMode ? filteredUsers.count : users.count
    }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        let user = isSearchMode ? filteredUsers[indexPath.row]  : users[indexPath.row]
        cell.viewModel = UserCellViewModel(user: user)
        return cell
    }
}

//MARK: - UITableViewDelegate
extension SearchController: UITableViewDelegate {
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = isSearchMode ? filteredUsers[indexPath.row]  : users[indexPath.row]
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else {
            return
        }
        filteredUsers = users.filter({
            $0.username.contains(searchText) ||
                $0.fullname.lowercased().contains(searchText)
        })
        self.tableView.reloadData()
        
    }
    
    
}
//MARK: - UICollectionViewDataSource UICollectionViewDelegate

extension SearchController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: postCellIdentifier, for: indexPath) as! ProfileCell
        cell.viewModel = PostViewModel(post: posts[indexPath.row])
        return cell
    }
    
    
}
extension SearchController : UICollectionViewDelegate{
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let controller = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        controller.selectPost = posts[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
}
//MARK: - UISearchBarDelegate

extension SearchController: UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        collectionView.isHidden = true
        tableView.isHidden = false
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        searchBar.text = nil
        
        collectionView.isHidden = false
        tableView.isHidden = true
    }
}


extension SearchController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
}
