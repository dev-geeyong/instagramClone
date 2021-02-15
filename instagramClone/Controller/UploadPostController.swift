//
//  UploadPostController.swift
//  instagramClone
//
//  Created by dev.geeyong on 2021/02/15.
//

import UIKit

protocol UploadPostControllerDelegate: class {
    func controllerDidFinishUploadingPost(_ controller: UploadPostController)
}
class UploadPostController: UIViewController {
    
    //MARK: - Properties
    weak var delegate: UploadPostControllerDelegate?
    var curruntUser: User?
    
    var selectedImage: UIImage?{
        didSet { photoImageView.image = selectedImage }
    }
    
    private let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    
    private lazy var captionTextView: InputTextView = {
        let tv = InputTextView()
        tv.placeholderText = "글을 입력해주세요.."
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.delegate = self
        return tv
    }()
    
    private let chracterCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0/100"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Actions
    
    @objc func didTapCancel(){
        dismiss(animated: true, completion: nil)
    }
    @objc func didTapDone(){
        guard let image = selectedImage else { return }
        guard let caption = captionTextView.text  else {
            return
        }
        guard let user = curruntUser else {
            return
        }
        showLoader(true)
        PostService.uploadPost(caption: caption, image: image, user: user){error in
            self.showLoader(false)
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.delegate?.controllerDidFinishUploadingPost(self)
        }
        
    }
    //MARK: - Helpers
    func checkMaxLength(_ textView: UITextView){
        if (textView.text.count) > 100 {
            textView.deleteBackward()
        }
        
    }
    func configureUI(){
        view.backgroundColor = .white
        navigationItem.title = "글쓰기"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(didTapCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "등록",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapDone))
        view.addSubview(photoImageView)
        photoImageView.setDimensions(height: 180, width: 180)
        photoImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 16)
        photoImageView.centerX(inView: view)
        photoImageView.layer.cornerRadius = 10
        
        view.addSubview(captionTextView)
        captionTextView.anchor(top: photoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 12, paddingRight: 12, height: 64)
        
        view.addSubview(chracterCountLabel)
        chracterCountLabel.anchor(top: captionTextView.bottomAnchor, right: view.rightAnchor, paddingTop: 16, paddingRight: 12)
    }
}

extension UploadPostController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        checkMaxLength(textView)
        let count = textView.text.count
        chracterCountLabel.text = "\(count)/100"
    }
}
