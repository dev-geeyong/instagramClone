//
//  ProfileCell.swift
//  instagramClone
//
//  Created by dev.geeyong on 2021/02/09.
//

import UIKit

class ProfileCell: UICollectionViewCell{
    
    //MARK: - Properties
    var viewModel: PostViewModel? {
        didSet{configure()}
    }
    
    private let postImageVIew: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "venom-7")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        backgroundColor = .lightGray
        addSubview(postImageVIew)
        postImageVIew.fillSuperview()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(){
        guard let viewModel = viewModel else{return}
        postImageVIew.sd_setImage(with: viewModel.imageURL, completed: nil)
        
    }
    
}
