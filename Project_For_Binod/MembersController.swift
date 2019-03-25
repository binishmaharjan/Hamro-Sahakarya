//
//  MembersController.swift
//  Project_For_Binod
//
//  Created by guest on 2018/02/03.
//  Copyright © 2018年 JEC. All rights reserved.
//

import UIKit

class MembersController: UIViewController{

    //MARK: IBOutlet and Variables
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    var allUsers = [AnyObject]()
    var isSearching : Bool = false
    var searchedUser = [AnyObject]()
    
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
        searchBar.barTintColor = UIColor(hexString: "8F6593")
        searchBar.tintColor = UIColor(hexString: "3B252C")
        
        //Searching for user
        searchUsers(searchedText: "")
        
        //Set Title for Navigation Bar
        navigationItem.title = "MEMBERS"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
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
}

extension MembersController :  UITableViewDelegate,UITableViewDataSource{
    
    //Table View and data source
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "cell") as! MembersCell
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
                cell.usernameLabel.text = ((tempUser["username"] as? String)?.uppercased())! + "(GUEST MEMBER)"
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
            print(searchedUser[indexPath.row]["username"])
        }else{
            print(allUsers[indexPath.row]["username"])
        }
    }
}

extension MembersController : UISearchBarDelegate{
    
    //Search Bar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0 {
            
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
