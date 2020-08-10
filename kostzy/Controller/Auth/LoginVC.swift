//
//  LoginVC.swift
//  kostzy
//
//  Created by Rais on 14/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {
    
    //----------------------------------------------------------------
    // MARK:- Outlets
    //----------------------------------------------------------------
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var closeButtonOutlet: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    //----------------------------------------------------------------
    // MARK:- Variables
    //----------------------------------------------------------------
    let defaults = UserDefaults.standard
    let apiManager = BaseAPIManager()
    
    //----------------------------------------------------------------
    // MARK:- Action Methods
    //----------------------------------------------------------------
    @IBAction func closeButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signInButtonAction(_ sender: UIButton) {
        let payload = ["email": emailTextField.text, "password": passwordTextField.text]
        //let token = "Token \(defaults.dictionary(forKey: "userToken")!["token"] as! String)"
        apiManager.performPostRequest(payload: payload as [String : Any], url: "\(BaseAPIManager.authUrl)login/",
            token: "")
        { (data, response, error) in
            DispatchQueue.main.async {
                if let response = response as? HTTPURLResponse {
                    switch response.statusCode {
                        case 200:
                            self.defaults.set(true, forKey: "userIsLoggedIn")
                            self.defaults.set(data, forKey: "userToken")
                            self.dismiss(animated: true, completion: nil)
                        
                        case 400:
                            if let validErr = data?["message"] as? [String] {
                                self.setupAlert(msg: "\(validErr[0])")
                            } else if let mailErr = data?["email"] as? [String] {
                                self.setupAlert(msg: "\(mailErr[0]) (Email)")
                            } else if let passErr = data?["password"] as? [String] {
                                self.setupAlert(msg: "\(passErr[0]) (Password)")
                            }
                        
                        default:
                            self.setupAlert(msg: "Something Wrong, Try Again Later")
                    }
                } else if let error = error {
                    self.setupAlert(msg: error.localizedDescription)
                }
            }
        }
        
//        if emailTextField.text == savedUserDataDict["userEmail"] && passwordTextField.text == savedUserDataDict["userPassword"] {
//            defaults.set(true, forKey: "userIsLoggedIn")
//
//            dismiss(animated: true, completion: nil)
//        } else {
//            let alert = UIAlertController(title: "Wrong email and/or password", message: "Make sure you input the right email and password", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//
//            self.present(alert, animated: true)
//        }
    }
    
    
    //----------------------------------------------------------------
    // MARK:- Custom Methods
    //----------------------------------------------------------------
    private func setupAlert(msg: String) {
        let alert = UIAlertController(title: "Whoops!", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func setupTextField() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        emailTextField.keyboardType = .emailAddress
        passwordTextField.keyboardType = .default
        
        emailTextField.underlined()
        passwordTextField.underlined()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        let notificationCenter = NotificationCenter.default
        
        view.addGestureRecognizer(tapGesture)
        
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
        }
        return true
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = UIEdgeInsets.zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
    @objc func didTapView(gesture: UITapGestureRecognizer)  {
        view.endEditing(true)
    }
    
    
    //----------------------------------------------------------------
    // MARK:- View Life Cycle Methods
    //----------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        self.navigationController?.isNavigationBarHidden = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
