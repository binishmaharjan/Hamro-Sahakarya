//
//  HomeController.swift
//  Project_For_Binod
//
//  Created by guest on 2018/02/02.
//  Copyright © 2018年 JEC. All rights reserved.
//

import UIKit

class HomeController: UIViewController {

    //MARK: IBOutlets and Variable
    @IBOutlet var avaImage: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var fullnameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var adminSettingButton: UIBarButtonItem!
    @IBOutlet var balancelabel: UILabel!
    @IBOutlet var loanLabel: UILabel!
    @IBOutlet var lastUpdatedDate: UILabel!
    @IBOutlet var totalCollectionLbl: UILabel!
    @IBOutlet var loanGivenLbl: UILabel!
    @IBOutlet var expensenLbl: UILabel!
    @IBOutlet var extraLbl: UILabel!
    @IBOutlet var currentBalanceLbl: UILabel!
    @IBOutlet var noticeByLbl: UILabel!
    @IBOutlet var noticeLbl: UILabel!
    
    
    //Getting all data of member for overview
    var allUsers = [AnyObject]()
    
    //Vairalbes
    var totalCollection : Int = 0
    var expenses : Int = 0
    var extra : Int = 0
    var loanGiven : Int = 0
    var currentBalance : Int = 0
    
    //Number formatter
    var numberFormatter = NumberFormatter()
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()

       //Customizing The user Ava Picture
        avaImage.layer.cornerRadius = 50
        avaImage.clipsToBounds = true
        
        //Getting the user information form the user defaults
        let username : String = user?["username"] as! String
        let fullname : String = user!["fullname"] as! String
        let email : String = user?["email"] as! String
        let ava : String = user?["ava"] as! String
        guard let admin  = user?["admin"] as? String else {
            return
        }
      
        
        //Creating the shortcut
        usernameLabel.text = username.uppercased()
        fullnameLabel.text = fullname
        emailLabel.text = email
        
        //Disabling the admin if the user is not admin
        if !(admin == "2" || admin == "1"){
           adminSettingButton.title = ""
            adminSettingButton.image = UIImage()
            adminSettingButton.isEnabled = false
        }
        
        //Check if there is a path to profile image or not
        if ava != ""{
            let imageUrl = URL(string: ava)!
            DispatchQueue.main.async {
                let imageData = NSData(contentsOf: imageUrl)
                if let image = imageData{
                    self.avaImage.image = UIImage(data: image as Data)
                }
            }
        }
        
        //Setting the title of the navigation title
         self.navigationItem.title = username.uppercased()
        
        
        //Getting user balance and loan
        getUserBalanceAndLoan()
        
        //Loading all users
        searchUsers(searchedText: "")
        
        //Initializing the number formatter
        numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        
        //Filling the noticeboard
        readMessageFromNoticeBoard()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Getting user balance and loan
        getUserBalanceAndLoan()
        
        //Filling the noticeboard
        readMessageFromNoticeBoard()
        
        //Loading all users
        searchUsers(searchedText: "")
    }
    
    
    //MARK: Action
    //Edit Profile Button Clicked
    @IBAction func editProfileClicked(_ sender: Any) {
        let sheet = UIAlertController(title: "Edit Profile", message: nil, preferredStyle: .actionSheet)
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let pictureButton = UIAlertAction(title: "Update Profile Picture", style: .default) { (action) in
            self.changeAva()
        }
        
        let changePasswordButton = UIAlertAction(title: "Change Password", style: .default) { (action) in
            self.changePassword()
        }
        
        sheet.addAction(cancelButton)
        sheet.addAction(pictureButton)
        sheet.addAction(changePasswordButton)
        //Alert View Postion For The ipad 
        if let popoverController = sheet.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.present(sheet, animated: true, completion: nil)
    }
    
    
    //Logout button Clicked
    @IBAction func logoutButtonClicked(_ sender: Any) {
        let userDefault = UserDefaults.standard
        userDefault.removeObject(forKey: "json")
        userDefault.synchronize()
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginNavigation")
        self.present(loginViewController!, animated: true, completion: nil)
    }
    
    
    //Change Profile Piture
    func changeAva(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //Edit The profile Picture
    func changePassword(){
        //This is Actually Change Password Class//initially created ass edit profile
        let editProfileView = self.storyboard?.instantiateViewController(withIdentifier: "editProfile") as! EditProfileController
       _ = UINavigationController(rootViewController: editProfileView)
        self.navigationController?.pushViewController(editProfileView, animated: true)
    }
    
    
    //Creating the body of url with image as paramaeter to send the request to php
    func createBodyWithParam(parameters : [String : String],filePathKey : String?,imageDataKey : NSData,boundary : String)-> NSData{
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        let filename = "ava.jpg"
        
        let mimetype = "image/jpg"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    //Function to uplaod the picture to the server and the update the path of the image to database
    func uploadAva(){
        let id = user!["id"] as! String
        
        let address = URL(string: "http://binish.php.xdomain.jp/hamro_sanstha/uploadava.php")!
        var request = URLRequest(url: address)
        request.httpMethod = "POST"
        let param = ["id" : id]
        
        let boundary = "Boundary-\(NSUUID().uuidString)"
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        //Converting the image to JPEGRepresentation
        let imageData = UIImageJPEGRepresentation(avaImage.image!, 0.5)
        
        if imageData == nil {
            return
        }
        
        request.httpBody = createBodyWithParam(parameters: param, filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary) as Data
        
        //Creating URLSession and URLSessionDataTask
        let defaultSession : URLSession = URLSession(configuration: .default)
        var dataTask :URLSessionDataTask?
        
        
        dataTask = defaultSession.dataTask(with: request, completionHandler: { (data, response, error) in
            
            DispatchQueue.main.async {
                if error == nil{
                    do{
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                        
                        //Guard Let Method
                        guard let parseJSON = json else {
                            print("error while parsing")
                            return
                        }
                        //Printing the result to the console
                        //print(parseJSON)
                        
                        //Once photo is uploaded saving the new data to the userdefaults and user of appdelegate
                        let defaultUser = UserDefaults.standard
                        defaultUser.set(parseJSON, forKey: "json")
                        
                        user = defaultUser.object(forKey: "json") as? NSDictionary
                        
                    }catch{
                        print("Caught an error\n \(error)")
                        DispatchQueue.main.async {
                            let message = "Error!!!"
                            appDelegate.errorView(message: message, color: UIColor(red: 255/255, green: 50/255, blue: 25/255, alpha: 1))
                        }
                    }
                }else{
                    print("Error \(String(describing: error))")
                    DispatchQueue.main.async {
                        let message = "Error!!!"
                        appDelegate.errorView(message: message, color: UIColor(red: 255/255, green: 50/255, blue: 25/255, alpha: 1))
                    }
                }
            }
        })
        
        dataTask?.resume()
    }
    
    //Function to get User Balance and the loan
    func getUserBalanceAndLoan(){
        //create url 
        var urlComponent = URLComponents(string: "http://binish.php.xdomain.jp/hamro_sanstha/userbalance.php")
        urlComponent?.query = "id=\((user?["id"])!)"
        
        guard let url = urlComponent?.url else {
            return
        }
  
        //Creating URLSession and URLSessionDataTask
        let defaultSession : URLSession = URLSession(configuration: .default)
        var dataTask :URLSessionDataTask?
        
        
        dataTask = defaultSession.dataTask(with: url, completionHandler: { (data, response, error) in
            
            DispatchQueue.main.async {
                if error == nil{
                    do{
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                        
                        //Guard Let Method
                        guard let parseJSON = json else {
                            print("error while parsing")
                            return
                        }
                        //Printing the result to the console
                        //print(parseJSON)
                        
                        guard let balance = parseJSON["balance"]  as? String else{
                            print("Balance Error")
                            return
                        }
                        guard let loan = parseJSON["loan"] as? String else{
                            print("Loan Error")
                            return
                        }
                        guard let date = parseJSON["date"] else{
                            print("Date Error")
                            return
                        }
                        //Replacing the values in the Label
                        let formattedBalance = self.numberFormatter.string(from: NSNumber(value:Int(balance)!))!
                        self.balancelabel.text = "¥\(formattedBalance)"
                        let formattedLoan = self.numberFormatter.string(from: NSNumber(value:Int(loan)!))!
                        self.loanLabel.text = "¥\(formattedLoan)"
                        self.lastUpdatedDate.text = "\(date)"
                        
                       
                        
                    }catch{
                        print("Caught an error\n \(error)")
                        DispatchQueue.main.async {
                            let message = "Error!!!"
                            appDelegate.errorView(message: message, color: UIColor(red: 255/255, green: 50/255, blue: 25/255, alpha: 1))
                        }
                    }
                }else{
                    print("Error \(String(describing: error))")
                    DispatchQueue.main.async {
                        let message = "Error!!!"
                        appDelegate.errorView(message: message, color: UIColor(red: 255/255, green: 50/255, blue: 25/255, alpha: 1))
                    }
                }
            }
        })
        
        dataTask?.resume()
    }
    
    //MARK:  Display All Users
    func searchUsers(searchedText :String){
        let word = searchedText
        
        //url componenet
        var urlComponent : URLComponents = URLComponents(string: "http://binish.php.xdomain.jp/hamro_sanstha/users.php")!
        urlComponent.query = "word=\(word)&username=\((user?["username"])!)"
        
        //gettning url from the componenet
        let url = urlComponent.url
        
        //Creating the deafult sessions
        let defaultSession : URLSession = URLSession(configuration: .default)
        var dataTask :URLSessionDataTask = URLSessionDataTask()
        
        
        //Starting the task
        dataTask = defaultSession.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error == nil{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                    
                    guard let allUsers = json["users"] as?  [AnyObject] else{
                        return
                    }
                    
                    DispatchQueue.main.async {
                        //saving all users in the gobal users
                        self.allUsers = allUsers
                        //print(self.allUsers)
                        
                        //Filling the total collection veiw
                        self.calulateTotalCollection()
                        
                        //Filling the expenses
                        self.calculateExpenses()
                        
                        //Fillin the extra
                        self.calculateExtra()
                        
                        //Filling loan Given
                        self.calulateLoanGiven()
                        
                        //Filling current balance
                        self.calculateCurrentBalance()
                    }
                    
                }catch{
                    print(" Caught Error : \(error)")
                }
            }else{
                print("Error : \(String(describing: error))")
            }
        })
        
        dataTask.resume()
        
    }
    
    //Function to calculate the total collection of all member
    func calulateTotalCollection(){
        //Reseting the value to the zero
        totalCollection = 0
        
        allUsers.forEach { (singleUser) in
            guard let balance = singleUser["balance"] as? String else{
                print("No Balance")
                return
            }
            
            let balanceInt : Int = Int(balance)!
            
            totalCollection = totalCollection + balanceInt
            
        }
        
        //Setting the text label
        
        let formattedNumber  = numberFormatter.string(from: NSNumber(value:totalCollection))!
        totalCollectionLbl.text = "¥\(formattedNumber)"
    }
    
    //Function to calclulate expenses
    func calculateExpenses(){
        //Reseting the value to the zero
        expenses = 0
        
        guard let expensesString = allUsers[0]["expenses"] as? String else {
            print("No Expsenses")
            return
        }
        
        expenses = Int(expensesString)!
        
        //Setting the label
        let formattedNumber  = numberFormatter.string(from: NSNumber(value:expenses))!
        expensenLbl.text = "¥\(formattedNumber)"
    }
    
    //Function to calclulate extra
    func calculateExtra(){
        //Reseting the value to the zero
        extra = 0
        guard let extraString = allUsers[0]["extra"] as? String else {
            print("No Extra")
            return
        }
        
        extra = Int(extraString)!
        
        //Setting the label
        let formattedNumber  = numberFormatter.string(from: NSNumber(value:extra))!
        extraLbl.text = "¥\(formattedNumber)"
    }
    
    //Function to calculate the loan given to  all member
    func calulateLoanGiven(){
        //Reseting the value to the zero
        loanGiven = 0
        
        allUsers.forEach { (singleUser) in
            guard let balance = singleUser["loan"] as? String else{
                print("No Loan")
                return
            }
            
            let LoanInt : Int = Int(balance)!
            
            loanGiven = loanGiven + LoanInt
            
        }
        
        //Setting the text label
        let formattedNumber  = numberFormatter.string(from: NSNumber(value:loanGiven))!
        loanGivenLbl.text = "¥\(formattedNumber)"
    }
    
    func calculateCurrentBalance(){
        //Reseting the value to the zero
        currentBalance = 0
        currentBalance = totalCollection + extra - expenses - loanGiven
        
        //Setting the lable to the current balance label
        let formattedNumber  = numberFormatter.string(from: NSNumber(value:currentBalance))!
        currentBalanceLbl.text = "¥\(formattedNumber)"
    }
    
    //Function to read the message for the noticeboard
    func readMessageFromNoticeBoard(){
        //url componenet
        var urlComponent : URLComponents = URLComponents(string: "http://binish.php.xdomain.jp/hamro_sanstha/notice.php")!

        urlComponent.query = "username=\(user!["username"])&message="
        
        //gettning url from the componenet
        let url = urlComponent.url
        
        //Creating the deafult sessions
        let defaultSession : URLSession = URLSession(configuration: .default)
        var dataTask :URLSessionDataTask = URLSessionDataTask()
        
        
        //Starting the task
        dataTask = defaultSession.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error == nil{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                    
                    guard let message = json["message"] as?  String else{
                        print("No Message")
                        return
                    }
                    
                    guard let by = json["by"] as? String else{
                        print("No By")
                        return
                    }
                    
                    DispatchQueue.main.async {
                        //Replacing the value taken from the json
                        self.noticeByLbl.text = "From - \(by)"
                        self.noticeLbl.text = message
                    }
                    
                }catch{
                    print(" Caught Error : \(error)")
                }
            }else{
                print("Error : \(String(describing: error))")
            }
        })
        
        dataTask.resume()
    }
   
}


extension HomeController :  UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    //When Image is Selected From The image Picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        avaImage.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
        
        //Call Uplaod Ava Function
        uploadAva()
    }
}
