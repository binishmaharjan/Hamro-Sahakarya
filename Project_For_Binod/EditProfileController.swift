//
//  EditProfileController.swift
//  Project_For_Binod
//
//  Created by guest on 2018/02/05.
//  Copyright © 2018年 JEC. All rights reserved.
//

import UIKit

class EditProfileController: UIViewController {

    //MARK: IBOutlet and Varables
    @IBOutlet var bannerImageView: UIImageView!
    @IBOutlet var passwordTextView: UITextField_Designable!
    @IBOutlet var repeatPasswordTextView: UITextField_Designable!
    
    //Flag for is screen is up or not
    var isScreenUp : Bool = false
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        //Customizing Banner Logo
        bannerImageView.layer.cornerRadius = 90
        bannerImageView.clipsToBounds = true
        
        //Setting the delegate to the textFields
        passwordTextView.delegate = self
        repeatPasswordTextView.delegate = self
        
        //Password Field
        passwordTextView.isSecureTextEntry = true
        repeatPasswordTextView.isSecureTextEntry = true
        
        //Set Title for Navigation Bar
        navigationItem.title = "CHANGE PASSWORD"
        
        //Move screen up when keyboard shows
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    @IBAction func changeButtonClicked(_ sender: Any) {
        //If All textfields are not filled
        if passwordTextView.text!.isEmpty || repeatPasswordTextView.text!.isEmpty {
            passwordTextView.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSForegroundColorAttributeName : UIColor.red])
            repeatPasswordTextView.attributedPlaceholder = NSAttributedString(string: "repeat password", attributes: [NSForegroundColorAttributeName : UIColor.red])
        }else{//Data was passed properly
            // Creating Shortcut
            let password : String = passwordTextView.text!
            let repeatPassword : String = repeatPasswordTextView.text!
            guard let id = user?["id"] else {
                print("Error while guarding")
                return
            }
            
            //If password donot match
            if password != repeatPassword{
                DispatchQueue.main.async {
                    appDelegate.errorView(message: "Password Doesnot Match", color:UIColor(red: 255/255, green: 50/255, blue: 25/255, alpha: 1))
                }
                return
            }
            
            //Creating the url
            var urlComponent = URLComponents(string: "http://binish.php.xdomain.jp/hamro_sanstha/changepassword.php?");
            urlComponent?.query = "password=\(password)&id=\(id)";
            let url = urlComponent?.url
            //print(url!)
            
            //Starting the Session
            let defaultSession = URLSession(configuration: .default)
            var dataTask :URLSessionDataTask
            
            dataTask = defaultSession.dataTask(with: url!, completionHandler: { (data, response, error) in
                if error == nil{
                    do{
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                        
                        guard let status = json["status"] as? String else{
                            print("Error While Getting The status")
                            return
                        }
                        
                        //Status 200 : Successful
                        if status == "200"{
                            DispatchQueue.main.async {
                                appDelegate.errorView(message: json["message"] as! String,color: UIColor(red: 50/255, green: 255/255, blue: 25/255, alpha: 1))
                            }
                            
                            //Logging out when reset is succesful with delay 0
                           DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                            self.logoutWhenSuccessful()
                           })
                            
                        }else{//Status 400 : Failed
                            DispatchQueue.main.async {
                                appDelegate.errorView(message: json["message"] as! String, color:UIColor(red: 255/255, green: 50/255, blue: 25/255, alpha: 1))
                            }
                        }
                        
                    }catch{
                        print("Caught Error : \(error)")
                        DispatchQueue.main.async {
                            appDelegate.errorView(message: "Error", color:UIColor(red: 255/255, green: 50/255, blue: 25/255, alpha: 1))
                        }
                        return
                    }
                    
                }else{
                    print("Error = \(String(describing: error))")
                    DispatchQueue.main.async {
                        appDelegate.errorView(message: "Error", color:UIColor(red: 255/255, green: 50/255, blue: 25/255, alpha: 1))
                    }
                    return
                }
            })
            
            dataTask.resume()
            
           
        }
    }
    
    //Loggin out  when password is successfully changed
    func logoutWhenSuccessful(){
        let userDefault = UserDefaults.standard
        userDefault.removeObject(forKey: "json")
        userDefault.synchronize()
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginNavigation")
        self.present(loginViewController!, animated: true, completion: nil)
    }
    
    //MARK: Keyboard
    //Functions to move screen up and down when keyboard appears
    @objc func keyboardWillShow(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if isScreenUp == false{
                self.view.frame.origin.y -= 180
                isScreenUp = true
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if isScreenUp == true{
                self.view.frame.origin.y += 180
                isScreenUp = false
            }
        }
    }
}

extension EditProfileController : UITextFieldDelegate{
    
    //Function to hide keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        passwordTextView.resignFirstResponder()
        repeatPasswordTextView.resignFirstResponder()
        return true
        
    }
}
