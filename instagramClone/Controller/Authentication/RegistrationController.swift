//
//  RegistrationController.swift
//  instagramClone
//
//  Created by dev.geeyong on 2021/02/02.
//

import UIKit

class RegistrationController: UIViewController {
    
    //MARK: - Properties
    private var viewModel = RegistrationViewModel()
    private var profileImage: UIImage?
    private let pushImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(setUserImage), for: .touchUpInside)
         
        return button
    }()
    private let emailTextField: CustomTextField = {
        
        let tf = CustomTextField(placeholder: "Email")
        return tf
    }()
    
    private let passwordTextField: CustomTextField = {
       let tf = CustomTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    private let fullnameTextField = CustomTextField(placeholder: "fullname")
    private let usernameTextField = CustomTextField(placeholder: "username")
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
        button.layer.cornerRadius = 5
        button.setHeight(50)
        button.isEnabled = false
        button.addTarget(self, action: #selector(pushSignUpButton), for: .touchUpInside)
        return button
    }()
    private let alreadyAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "already have an account?  ", secondPart: "Log In")
        button.addTarget(self, action: #selector(showloginPage), for: .touchUpInside)
        return button
    }()
    //MARK: - Actions
    
    @objc func showloginPage(){
        navigationController?.popViewController(animated: true)
    }
    @objc func setUserImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    @objc func pushSignUpButton(){
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        guard let fullname = fullnameTextField.text else {return}
        guard let username = usernameTextField.text?.lowercased() else {return}
        guard let profileImage = self.profileImage else {return}
        
        let credentials = AuthCredentials(email: email, password: password, fullname: fullname, username: username, profileImage: profileImage)
        AuthService.registerUser(withCredential: credentials) { error in
            if let error = error {
                print("debug failed to register user \(error.localizedDescription)")
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func textDidChange(sender: UITextField){
        if sender == emailTextField{
            viewModel.email = sender.text
        }
        else if sender == passwordTextField{
            viewModel.password = sender.text
        }
        else if sender == fullnameTextField{
            viewModel.fullname = sender.text
        }
        else{
            viewModel.username = sender.text
        }
        updateForm()

    }
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObservers()
    }
    
    //MARK: - Helpers
    
    func configureUI(){
        configureGradientLayer()
        view.addSubview(pushImageButton)
        pushImageButton.centerX(inView: view)
        pushImageButton.setDimensions(height: 140, width: 140)
        pushImageButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField,passwordTextField,fullnameTextField,usernameTextField,signUpButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        
        view.addSubview(stackView)
        stackView.anchor(top: pushImageButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                         paddingTop: 32, paddingLeft: 32,paddingRight: 32)
        
        view.addSubview(alreadyAccountButton)
        alreadyAccountButton.centerX(inView: view)
        alreadyAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 32)
    
    }
    func configureNotificationObservers(){
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullnameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
}

//MARK: - FormViewModel
extension RegistrationController: FormViewModel{
    func updateForm() {
        signUpButton.backgroundColor = viewModel.buttonBackgroundColor
        signUpButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        signUpButton.isEnabled = true
    }
}

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectImage = info[.editedImage] as? UIImage else {
            return
        }
        profileImage = selectImage
        pushImageButton.layer.cornerRadius = pushImageButton.frame.width / 2
        pushImageButton.layer.masksToBounds = true
        pushImageButton.layer.borderColor = UIColor.white.cgColor
        pushImageButton.layer.borderWidth = 2
        pushImageButton.setImage(selectImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        dismiss(animated: true, completion: nil)
        
        
    }
}
