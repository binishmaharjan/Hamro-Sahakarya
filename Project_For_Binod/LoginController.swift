//
//  LoginController.swift
//  Project_For_Binod
//
//  Created by guest on 2017/12/26.
//  Copyright © 2017年 JEC. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

    //MARK: IBOutlets and Variable
    @IBOutlet var userTextField: UITextField_Designable!
    @IBOutlet var passwordTextField: UITextField_Designable!
    @IBOutlet var loginButton: UIButton_Designable!
    @IBOutlet var signUpButton: UIButton_Designable!
    @IBOutlet var forgotPasswordButton: UIButton!
    @IBOutlet var bannerLogoView: UIImageView!
    
    //Flag for is screen is up or not
    var isScreenUp : Bool = false
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting Delegate For The TextView
        userTextField.delegate = self
        passwordTextField.delegate = self
        
        //Customizing The Banner Logo
        bannerLogoView.layer.cornerRadius = 90
        bannerLogoView.clipsToBounds = true
        bannerLogoView.contentMode = .scaleAspectFill
        
        //Password Field
        passwordTextField.isSecureTextEntry = true
        
        
        //Move screen up when keyboard shows
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        print((navigationController?.navigationBar.bounds.size.height)! + UIApplication.shared.statusBarFrame.height)
        print(self.view.frame.origin.y)
        
    }
    
    //MARK: Action
    @IBAction func loginButtonClicked(_ sender: Any) {
        //Hide keyoboard no matter what the result is
        userTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        //if all data are not entered
        if userTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            userTextField.attributedPlaceholder = NSAttributedString(string: "username", attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor.red]))
            passwordTextField.attributedPlaceholder = NSAttributedString(string: "password", attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor.red]))
        }else{//All data are entered
            /*
             Sending request to the php file
            */
            loginRequest()
        }
    }
    
    
    //Send request to the php file
    func loginRequest(){
        //Creating short cut to the username and password
        let username = userTextField.text!.lowercased()
        let password = passwordTextField.text!
        
        //url component
        var urlComponent : URLComponents = URLComponents(string: "http://binish.php.xdomain.jp/hamro_sanstha/login.php?")!
        //adding query
        urlComponent.query = "username=\(username)&password=\(password)"
        
        //creating url
        guard let url = urlComponent.url else{
            return
        }
        
        
        //Starting data session
        let defaultSession : URLSession = URLSession(configuration: .default)
        var dataTask : URLSessionDataTask
        
        dataTask = defaultSession.dataTask(with: url, completionHandler: { (data, response, error) in
            //if error didnot occured
            if error == nil{
                //retriving the json data with do try
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                    //print(json)
                    
                    if json["id"] != nil{
                        //login Successful procced  to User Home Page
                        DispatchQueue.main.async {
                            //Saving the Current User in User Defaults
                            let defaultUser = UserDefaults.standard
                            defaultUser.set(json, forKey: "json")
                            
                            //Saving the value from UserDefault to user of AppDelegate
                            user = defaultUser.object(forKey: "json") as? NSDictionary
                            
                            //Loggin to Home Screen
                            appDelegate.login()
                        }
                        
                    }else{//login failed
                        DispatchQueue.main.async {
                            appDelegate.errorView(message: json["message"] as! String,color:UIColor(red: 255/255, green: 50/255, blue: 25/255, alpha: 1))
                        }
                    }
                }catch{
                    print("Error During Do Try : \(error)")
                    DispatchQueue.main.async {
                        let message = "Error!!!"
                        appDelegate.errorView(message: message, color: UIColor(red: 255/255, green: 50/255, blue: 25/255, alpha: 1))
                    }
                }
            }else{
                print("Error While Creating DataTask : \(String(describing: error))")
                DispatchQueue.main.async {
                    let message = "Error!!!"
                    appDelegate.errorView(message: message, color: UIColor(red: 255/255, green: 50/255, blue: 25/255, alpha: 1))
                }
            }
            
        })
        
        dataTask.resume()
    }
 
    //MARK: Keyboard
    //Functions to move screen up and down when keyboard appears
    @objc func keyboardWillShow(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if isScreenUp == false{
                self.view.frame.origin.y -= 200
                isScreenUp = true
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if isScreenUp == true{
                self.view.frame.origin.y += 200
                isScreenUp = false
            }
        }
    }

}

//Extension
extension LoginController : UITextFieldDelegate{
    
    //Function to hide the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
