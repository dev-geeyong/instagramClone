//
//  MainTabController.swift
//  instagramClone
//
//  Created by dev.geeyong on 2021/01/27.
//


import UIKit
import Firebase
import YPImagePicker

class MainTabController: UITabBarController{
    //MARK: - Propertie
    var user: User? {
        didSet{
            guard let user = user else {return}
            configureViewController(withUser: user)
            
        }
    }
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
  
        checkIfUserIsLoggedIn()
        fetchUser()
    }
    //MARK: - API
    func fetchUser(){
        UserService.fetchUser { user in
            self.user = user
        }
    }
    func checkIfUserIsLoggedIn(){
        if Auth.auth().currentUser == nil{ //로그인 상태가 아니면 로그인 화면으로
            DispatchQueue.main.async {
                let controller = LoginController()
                controller.delegate = self
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }
    }

    //MARK: - Helpers
    func configureViewController(withUser user: User) {
        self.delegate = self
        let layout = UICollectionViewFlowLayout()
        let feed = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: FeedController(collectionViewLayout: layout))
        
        let search = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"), rootViewController: SearchController())
        let imageSelector = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"), rootViewController: ImageSelectorController())
        let notification = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"), rootViewController: NotificationController())
        
        let profileController = ProfileController(user: user)// profilecntroller에 init user
        let profile = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_selected"), rootViewController: profileController)
        
        viewControllers = [feed,search,imageSelector,notification,profile]
        
        tabBar.tintColor = .black
    }
    func templateNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController{
        
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .black
        return nav
    }
    func didFinishPickingMedia(_ picker: YPImagePicker){ //이미지 선택완료
        picker.didFinishPicking{items, _ in
            picker.dismiss(animated: true){
                guard let selectedImage = items.singlePhoto?.image else{return}
                let controller = UploadPostController()
                controller.selectedImage = selectedImage
                controller.delegate = self
                controller.curruntUser = self.user
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }
    }
}

extension MainTabController: AuthenticationDelegate{ //로그인뷰
    func authenticationDidComplete(){ //로그인뷰에서 로그인버튼을 누르면
        fetchUser()
        self.dismiss(animated: true, completion: nil)
    }
}
//MARK: - UITabBarControllerDelegate
extension MainTabController: UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let index = viewControllers?.firstIndex(of: viewController)
        if index == 2 { // 글올리기 탭바 터치시 YP오픈
            var config = YPImagePickerConfiguration()
            config.library.mediaType = .photo
            config.shouldSaveNewPicturesToAlbum = false
            config.startOnScreen = .library
            config.screens = [.library]
            config.hidesStatusBar = false
            config.hidesBottomBar = false
            config.library.maxNumberOfItems = 1
            
            let picker = YPImagePicker(configuration: config)
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true, completion: nil)
            didFinishPickingMedia(picker)
            
        }
        return true
    }
}

//MARK: - UploadPostControllerDelegate
extension MainTabController: UploadPostControllerDelegate{
    func controllerDidFinishUploadingPost(_ controller: UploadPostController) { // 글쓰기 업로드 버튼 클릭시
        selectedIndex = 0
        controller.dismiss(animated: true, completion: nil)
        
        guard let feedNav = viewControllers?.first as? UINavigationController else{return}
        guard let feed = feedNav.viewControllers.first as? FeedController else {return}
        
        feed.handeleRefresh() //피드 리플레쉬
    }
    
    
}
