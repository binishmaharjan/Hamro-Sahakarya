//
//  MemberListForAdmin.swift
//  Project_For_Binod
//
//  Created by guest on 2018/02/07.
//  Copyright © 2018年 JEC. All rights reserved.
//

import UIKit

class MemberListForAdmin: UIViewController{

    //MARK: IBOutlet and Variables
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    var allUsers = [AnyObject]()
    var isSearching : Bool = false
    var searchedUser = [AnyObject]()
    
    var actionToBePerformed : Int?
    var selectedUser : String?
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting delegate and datasource for the table
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.clear
        
        
        //Setting the delegate for the searchbar
        searchBar.delegate = self
        
        //Customizing the searchBar
        searchBar.barTintColor = UIColor(hex: "8F6593")
        searchBar.tintColor = UIColor(hex: "3B252C")
        
        //Searching for user
        searchUsers(searchedText: "")
        
        if actionToBePerformed == 4 || actionToBePerformed == 7 || actionToBePerformed == 8{
            tableView.allowsSelection = false
        }
        
      
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Action
    @IBAction func doneButtonPressed(_ sender: Any) {
        //Option 2 : Change Admin Status
        if actionToBePerformed == 2 {
            changeAdminStatus()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.navigationController?.popViewController(animated: true)
            })
            
        }
        //Option 1 : Delete a User
        else if actionToBePerformed == 1{
            deleteAUser()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.navigationController?.popViewController(animated: true)
            })
        }
        //Option 3 : Add a Amount to one user
        else if actionToBePerformed == 3{
            //1. Create the alert controller.
            let alert = UIAlertController(title: "Add Amount", message: "Enter a Amount", preferredStyle: .alert)
            
            //2. Add the text field. You can configure it however you need.
            alert.addTextField { (textField) in
                textField.text = "10000"
            }
            
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
                guard let amount = Int((textField?.text)!) else{
                    print("No amount")
                    return
                }
                self.addAmountToOneUser(amount: amount)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.navigationController?.popViewController(animated: true)
                })
            }))
            
            //Cancel Button
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            
            // 4. Present the alert.
            self.present(alert, animated: true, completion: nil)
        }
        //Option 4 : Add Amount to all users
        else if actionToBePerformed == 4 {
            //1. Create the alert controller.
            let alert = UIAlertController(title: "Add Amount", message: "Enter a Amount", preferredStyle: .alert)
            
            //2. Add the text field. You can configure it however you need.
            alert.addTextField { (textField) in
                textField.text = "10000"
            }
            
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
                guard let amount = Int((textField?.text)!) else{
                    print("No amount")
                    return
                }
                self.addAmountToAllUser(amount: amount)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.navigationController?.popViewController(animated: true)
                })
            }))
            
            //Cancel Button
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            
            // 4. Present the alert.
            self.present(alert, animated: true, completion: nil)
        }
        //Option 5 : Loan a member
        else if actionToBePerformed == 5{
            //1. Create the alert controller.
            let alert = UIAlertController(title: "Give a Loan", message: "Enter a Amount", preferredStyle: .alert)
            
            //2. Add the text field. You can configure it however you need.
            alert.addTextField { (textField) in
                textField.text = "10000"
            }
            
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
                guard let amount = Int((textField?.text)!) else{
                    print("No amount")
                    return
                }
                
                self.addLoanUser(amount: amount, status: 1)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.navigationController?.popViewController(animated: true)
                })
            }))
            
            //Cancel Button
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            
            // 4. Present the alert.
            self.present(alert, animated: true, completion: nil)
        }
            //Option 6 : Loan Returned by Member
        else if actionToBePerformed == 6{
            //1. Create the alert controller.
            let alert = UIAlertController(title: "Give a Loan", message: "Enter a Amount", preferredStyle: .alert)
            
            //2. Add the text field. You can configure it however you need.
            alert.addTextField { (textField) in
                textField.text = "10000"
            }
            
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
                guard let amount = Int((textField?.text)!) else{
                    print("No amount")
                    return
                }
                
                self.addLoanUser(amount: amount, status: 2)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.navigationController?.popViewController(animated: true)
                })
            }))
            
            //Cancel Button
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            
            // 4. Present the alert.
            self.present(alert, animated: true, completion: nil)
        }
        //Option 7 : Add Expenses
        else if actionToBePerformed == 7{
            //1. Create the alert controller.
            let alert = UIAlertController(title: "Expenses", message: "Enter a Amount and Reason", preferredStyle: .alert)
            
            //2. Add the text field. You can configure it however you need.
            alert.addTextField { (textField) in
                textField.text = "1000"
            }
            alert.addTextField { (textField) in
                textField.text = "Reason"
            }
            
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
                let textField2 = alert?.textFields![1] // Force unwrapping because we know it exists.
                
                //Taking the amount from the first text and converting it into the int
                guard let amount = Int((textField?.text)!) else{
                    print("No amount")
                    return
                }
                
                //Taking the reason from the second text field
                guard let reason = (textField2?.text) else{
                    print("No amount")
                    return
                }
                
                //Calling the fuction
                self.addExpenses(amount: amount, reason: reason)
                
                //Closin the current view after 0.5 sec
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.navigationController?.popViewController(animated: true)
                })
            }))
            
            //Cancel Button
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            
            // 4. Present the alert.
            self.present(alert, animated: true, completion: nil)
        }
        //Option 8 : Add Extra
        else if actionToBePerformed == 8{
            //1. Create the alert controller.
            let alert = UIAlertController(title: "Extra", message: "Enter a Amount and Reason", preferredStyle: .alert)
            
            //2. Add the text field. You can configure it however you need.
            alert.addTextField { (textField) in
                textField.text = "1000"
            }
            alert.addTextField { (textField) in
                textField.text = "Reason"
            }
            
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
                let textField2 = alert?.textFields![1] // Force unwrapping because we know it exists.
                
                //Taking the amount from the first text and converting it into the int
                guard let amount = Int((textField?.text)!) else{
                    print("No amount")
                    return
                }
                
                //Taking the reason from the second text field
                guard let reason = (textField2?.text) else{
                    print("No amount")
                    return
                }
                
                //Calling the fuction
                self.addExtra(amount: amount, reason: reason)
                
                //Closin the current view after 0.5 sec
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.navigationController?.popViewController(animated: true)
                })
            }))
            
            //Cancel Button
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            
            // 4. Present the alert.
            self.present(alert, animated: true, completion: nil)
        }

    }
    
    //Search Users or Display All Users
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
                        if self.isSearching{
                            self.searchedUser = allUsers
                            //Printing the result(Debug Purpose)
                            //print(self.searchedUser)
                        }else{
                            self.allUsers = allUsers
                            //Printing the result(Debug Purpose)
                            //print(self.allUsers)
                        }
                        self.tableView.reloadData()
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
    
    
    //Change the admin status(action to be performed : 2)
    func changeAdminStatus(){
        //url componenet
        guard let selUser = selectedUser else {
            print("No User Selected")
            return
        }
        
        var urlComponent : URLComponents = URLComponents(string: "http://binish.php.xdomain.jp/hamro_sanstha/upgradeadminstatus.php")!
        urlComponent.query = "username=\(selUser)&r_username=\((user?["username"])!)"
        
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
                    
                    guard let message = json["message"] else{
                        print("No Message")
                        return
                    }
                    
                    guard let status = json["status"] as? String else{
                        print("No Status")
                        return
                    }
                    
                    if status == "200"{
                        DispatchQueue.main.async {
                            appDelegate.errorView(message: message as! String,color:UIColor(red: 50/255, green: 255/255, blue: 25/255, alpha: 1))
                        }
                    }else{
                        DispatchQueue.main.async {
                            appDelegate.errorView(message: message as! String,color:UIColor(red: 255/255, green: 50/255, blue: 25/255, alpha: 1))
                        }
                    }
                    
                    
                }catch{
                    print(" Caught Error : \(error)")
                    DispatchQueue.main.async {
                        appDelegate.errorView(message: "Error",color:UIColor(red: 255/255, green: 50/255, blue: 25/255, alpha: 1))
                    }
                }
            }else{
                print("Error : \(String(describing: error))")
                DispatchQueue.main.async {
                    appDelegate.errorView(message: "Error",color:UIColor(red: 255/255, green: 50/255, blue: 25/255, alpha: 1))
                }
            }
        })
        
        dataTask.resume()

    }
    
    //Function to delete the user
    func deleteAUser(){
        //url componenet
        guard let selUser = selectedUser else {
            print("No User Selected")
            return
        }
        
        var urlComponent : URLComponents = URLComponents(string: "http://binish.php.xdomain.jp/hamro_sanstha/deleteuser.php")!
        urlComponent.query = "username=\(selUser)&r_username=\((user?["username"])!)"
        
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
                    
                    guard let message = json["message"] else{
                        print("No Message")
                        return
                    }
                    
                    guard let status = json["status"] as? String else{
                        print("No Status")
                        return
                    }
                    
                    if status == "200"{
                        DispatchQueue.main.async {
                            appDelegate.errorView(message: message as! String,color:UIColor(red: 50/255, green: 255/255, blue: 25/255, alpha: 1))
                        }
                    }else{
                        DispatchQueue.main.async {
                            appDelegate.errorView(message: message as! String,color:UIColor(red: 255/255, green: 50/255, blue: 25/255, alpha: 1))
                        }
                    }
                    
                    
                }catch{
                    print(" Caught Error : \(error)")
                    DispatchQueue.main.async {
                        appDelegate.errorView(message: "Error",color:UIColor(red: 255/255, green: 50/255, blue: 25/255, alpha: 1))
                    }
                }
            }else{
                print("Error : \(String(describing: error))")
                DispatchQueue.main.async {
                    appDelegate.errorView(message: "Error",color:UIColor(red: 255/255, green: 50/255, blue: 25/255, alpha: 1))
                }
            }
        })
        
        dataTask.resume()
    }
    
    //Function add a amount to one user
    func addAmountToOneUser(amount : Int){
        //url componenet
        guard let selUser = selectedUser else {
            print("No User Selected")
            return
        }
        
        var urlComponent : URLComponents = URLComponents(string: "http://binish.php.xdomain.jp/hamro_sanstha/addamount.php")!
        urlComponent.query = "username=\(selUser)&r_username=\((user?["username"])!)&amount=\(amount)"
        
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
                    
                    guard let message = json["message"] else{
                        print("No Message")
                        return
                    }
                    
                    guard let status = json["status"] as? String else{
                        print("No Status")
                        return
                    }
                    
                    if status == "200"{
                        DispatchQueue.main.async {
                            appDelegate.errorView(message: message as! String,color:UIColor(red: 50/255, green: 255/255, blue: 25/255, alpha: 1))
                        }
                    }else{
                        DispatchQueue.main.async {
                            appDelegate.errorView(message: message as! String,color:UIColor(red: 255/255, green: 50/255, blue: 25/255, alpha: 1))
                        }
                    }
                    
                    
                }catch{
                    print(" Caught Error : \(error)")
                    DispatchQueue.main.async {
                        appDelegate.errorView(message: "Error",color:UIColor(red: 255/255, green: 50/255, blue: 25/255, alpha: 1))
                    }
                }
            }else{
                print("Error : \(String(describing: error))")
                DispatchQueue.main.async {
                    appDelegate.errorView(message: "Error",color:UIColor(red: 255/255, green: 50/255, blue: 25/255, alpha: 1))
                }
            }
        })
        
        dataTask.resume()

    }
    
    //Function add a amount to All user
    func addAmountToAllUser(amount : Int){
        //url componenet
        
        
        var urlComponent : URLComponents = URLComponents(string: "http://binish.php.xdomain.jp/hamro_sanstha/addamount.php")!
        urlComponent.query = "username=&r_username=\((user?["username"])!)&amount=\(amount)"
        
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
                    
                    guard let message = json["message"] else{
                        print("No Message")
                        return
                    }
                    
                    guard let status = json["status"] as? String else{
                        print("No Status")
                        return
                    }
                    
                    if status == "200"{
                        DispatchQueue.main.async {
                            appDelegate.errorView(message: message as! String,color:UIColor(red: 50/255, green: 255/255, blue: 25/255, alpha: 1))
                        }
                    }else{
                        DispatchQueue.main.async {
                            appDelegate.errorView(message: message as! String,color:UIColor(red: 255/255, green: 50/255, blue: 25/255, alpha: 1))
                        }
                    }
                    
                    
                }catch{
                    print(" Caught Error : \(error)")
                    DispatchQueue.main.async {
                        appDelegate.errorView(message: "Error",color:UIColor(red: 255/255, green: 50/255, blue: 25/255, alpha: 1))
                    }
                }
            }else{
                print("Error : \(String(describing: error))")
                DispatchQueue.main.async {
                    appDelegate.errorView(message: "Error",color:UIColor(red: 255/255, green: 50/255, blue: 25/255, alpha: 1))
                }
            }
        })
        
        dataTask.resume()
    }

    //Function add a amount to All user
    func addLoanUser(amount : Int , status : Int){
        //url componenet
        guard let selUser = selectedUser else {
            print("No User Selected")
            return
        }
        var urlComponent : URLComponents = URLComponents(string: "http://binish.php.xdomain.jp/hamro_sanstha/loan.php")!
        urlComponent.query = "username=\(selUser)&r_username=\((user?["username"])!)&amount=\(amount)&status=\(status)"
        
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
                    
                    guard let message = json["message"] else{
                        print("No Message")
                        return
                    }
                    
                    guard let status = json["status"] as? String else{
                        print("No Status")
                        return
                    }
                    
                    if status == "200"{
                        DispatchQueue.main.async {
                            appDelegate.errorView(message: message as! String,color:UIColor(red: 50/255, green: 255/255, blue: 25/255, alpha: 1))
                        }
                    }else{
                        DispatchQueue.main.async {
                            appDelegate.errorView(message: message as! String,color:UIColor(red: 255/255, green: 50/255, blue: 25/255, alpha: 1))
                        }
                    }
                    
                    
                }catch{
                    print(" Caught Error : \(error)")
                    DispatchQueue.main.async {
                        appDelegate.errorView(message: "Error",color:UIColor(red: 255/255, green: 50/255, blue: 25/255, alpha: 1))
                    }
                }
            }else{
                print("Error : \(String(describing: error))")
                DispatchQueue.main.async {
                    appDelegate.errorView(message: "Error",color:UIColor(red: 255/255, green: 50/255, blue: 25/255, alpha: 1))
                }
            }
        })
        
        dataTask.resume()
    }

    //Function to add expenses to the group
    func addExpenses(amount :Int,reason : String){
        var urlComponent : URLComponents = URLComponents(string: "http://binish.php.xdomain.jp/hamro_sanstha/expenses.php")!
        urlComponent.query = "username=\((user?["username"])!)&amount=\(amount)&reason=\(reason)"
        
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
                    
                    guard let message = json["message"] else{
                        print("No Message")
                        return
                    }
                    
                    guard let status = json["status"] as? String else{
                        print("No Status")
                        return
                    }
                    
                    if status == "200"{
                        DispatchQueue.main.async {
                            appDelegate.errorView(message: message as! String,color:UIColor(red: 50/255, green: 255/255, blue: 25/255, alpha: 1))
                        }
                    }else{
                        DispatchQueue.main.async {
                            appDelegate.errorView(message: message as! String,color:UIColor(red: 255/255, green: 50/255, blue: 25/255, alpha: 1))
                        }
                    }
                    
                    
                }catch{
                    print(" Caught Error : \(error)")
                    DispatchQueue.main.async {
                        appDelegate.errorView(message: "Error",color:UIColor(red: 255/255, green: 50/255, blue: 25/255, alpha: 1))
                    }
                }
            }else{
                print("Error : \(String(describing: error))")
                DispatchQueue.main.async {
                    appDelegate.errorView(message: "Error",color:UIColor(red: 255/255, green: 50/255, blue: 25/255, alpha: 1))
                }
            }
        })
        
        dataTask.resume()
    }
    
    //Function to add expenses to the group
    func addExtra(amount :Int,reason : String){
        var urlComponent : URLComponents = URLComponents(string: "http://binish.php.xdomain.jp/hamro_sanstha/extra.php")!
        urlComponent.query = "username=\((user?["username"])!)&amount=\(amount)&reason=\(reason)"
        
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
                    
                    guard let message = json["message"] else{
                        print("No Message")
                        return
                    }
                    
                    guard let status = json["status"] as? String else{
                        print("No Status")
                        return
                    }
                    
                    if status == "200"{
                        DispatchQueue.main.async {
                            appDelegate.errorView(message: message as! String,color:UIColor(red: 50/255, green: 255/255, blue: 25/255, alpha: 1))
                        }
                    }else{
                        DispatchQueue.main.async {
                            appDelegate.errorView(message: message as! String,color:UIColor(red: 255/255, green: 50/255, blue: 25/255, alpha: 1))
                        }
                    }
                    
                    
                }catch{
                    print(" Caught Error : \(error)")
                    DispatchQueue.main.async {
                        appDelegate.errorView(message: "Error",color:UIColor(red: 255/255, green: 50/255, blue: 25/255, alpha: 1))
                    }
                }
            }else{
                print("Error : \(String(describing: error))")
                DispatchQueue.main.async {
                    appDelegate.errorView(message: "Error",color:UIColor(red: 255/255, green: 50/255, blue: 25/255, alpha: 1))
                }
            }
        })
        
        dataTask.resume()
    }
}

extension MemberListForAdmin : UITableViewDelegate, UITableViewDataSource{
    
    //Table View and data source
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "cell") as! MembersCell
        
        //Changing the selection color
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.cyan
        cell.selectedBackgroundView = backgroundView
        
        DispatchQueue.main.async {
            //Taking a single user out of array
            let tempUser : AnyObject
            if self.isSearching {
                tempUser = self.searchedUser[indexPath.row]
            }else{
                tempUser  = self.allUsers[indexPath.row]
            }
            //Checking For admin Status
            guard let admin = tempUser["admin"] as? String else{
                return
            }
            //Changing the back ground Color if status is admin
            if admin == "2"{
                cell.backgroundColor = UIColor(red: 143/255, green: 101/255, blue: 147/255, alpha: 0.3)
            }else{
                cell.backgroundColor  = UIColor.clear
            }
            
            //Replacing the values of label
            if admin == "2"{
                cell.usernameLabel.text = ((tempUser["username"] as? String)?.uppercased())! + "(ADMIN)"
            }else{
                cell.usernameLabel.text = (tempUser["username"] as? String)?.uppercased()
            }
            cell.fullnameLabel.text = tempUser["fullname"] as? String
            cell.emailLabel.text  = tempUser["email"] as? String
            
            //Downloading all replacing the image
            if let imageUrl = tempUser["ava"] as? String{
                if imageUrl.isEmpty{
                    cell.avaImage.image = UIImage(named: "hamro_sahakarya")
                }else{
                    let url = URL(string: imageUrl)
                    if let imageData  = NSData(contentsOf: url!){
                        cell.avaImage.image = UIImage(data: imageData as Data)
                    }
                    
                }
            }
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return searchedUser.count
        }else{
            return allUsers.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearching {
            selectedUser = searchedUser[indexPath.row]["username"] as? String
            print(selectedUser!)
        }else{
            selectedUser = allUsers[indexPath.row]["username"] as? String
            print(selectedUser!)
        }
    }
}

extension MemberListForAdmin : UISearchBarDelegate{
    //Search Bar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count > 0 {
            isSearching = true
            searchUsers(searchedText: searchText)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }else{
            isSearching = false
            searchUsers(searchedText: "")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(false)
        searchBar.showsCancelButton = false
        searchBar.text = ""
        isSearching = false
        searchUsers(searchedText: "")
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
}
