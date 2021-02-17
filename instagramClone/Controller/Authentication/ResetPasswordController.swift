//
//  ResetPasswordController.swift
//  instagramClone
//
//  Created by dev.geeyong on 2021/02/17.
//

import UIKit

protocol ResetPasswordControllerDelegate: class {
    func controllerDidSendResetPasswordLink(_ controller: ResetPasswordController)
}
class ResetPasswordController: UIViewController {
    //MARK: - Properties
    weak var delegate: ResetPasswordControllerDelegate?
    
    private var viewModel = ResetPasswordViewModel()
    private let iconImage: UIImageView = {
       let iv = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    private let resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("패스워드 리셋", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
        button.layer.cornerRadius = 5
        button.setHeight(50)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleResetButton), for: .touchUpInside)
        return button
    }()
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left") , for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        return button
    }()
    private let emailTextField: CustomTextField = {
        
        let tf = CustomTextField(placeholder: "Email")
        return tf
    }()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        configureUI()
        
    }
    //MARK: - Helpers
    
    func configureUI(){
        configureGradientLayer()
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        view.addSubview(backButton)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 16, paddingLeft: 16)
        
        view.addSubview(iconImage)
    
        
        iconImage.centerX(inView: view)
        iconImage.setDimensions(height: 80, width: 120)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField,resetButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        
        view.addSubview(stackView)
        stackView.anchor(top: iconImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                         paddingTop: 32, paddingLeft: 32,paddingRight: 32)
        
        
        
        
        
    }
    
    //MARK: - Actions
    
    @objc func handleResetButton(){
        guard let email = emailTextField.text else {return}
        showLoader(true)
        AuthService.resetPassword(withEmail: email) { error in
            if let error = error {
                self.showMessage(withTitle: "Error", message: error.localizedDescription)
                self.showLoader(false)
                return
            }
            self.delegate?.controllerDidSendResetPasswordLink(self)
        }
    }
    @objc func handleBackButton(){
        navigationController?.popViewController(animated: true)
    }
    @objc func textDidChange(sender: UITextField){
        if sender == emailTextField{
            viewModel.email = sender.text
        }
        updateForm()
    }
}

//MARK: - FormViewModel

extension ResetPasswordController: FormViewModel{
    func updateForm() {
        resetButton.backgroundColor = viewModel.buttonBackgroundColor
        resetButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        resetButton.isEnabled = true
    }
}
