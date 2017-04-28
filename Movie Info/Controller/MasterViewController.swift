//
//  MasterViewController.swift
//  Movie
//
//  Created by Aditya Tanna on 4/26/17.
//  Copyright © 2017 Tanna Inc. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil

    var arrMovies = [Any]()

    var selectedIndex = 0
    
    //MARK: - ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Top Rated"
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        let backgroundImage = UIImage(named: "bg.jpg")
        
        let imgView = UIImageView(image: backgroundImage)
        
        imgView.contentMode = .scaleAspectFill
        
        self.tableView.backgroundView = imgView
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
     
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: getAppDelegate().reachability)
        do{
            try getAppDelegate().reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
        callWSToGetMovies()
    }

    // MARK: - Table View
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMovies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row % 2 == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellBlank", for: indexPath)
            
            return cell
        }else{
           
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellMovieList", for: indexPath) as? TBMovieCell
            
            if var imgurl = (arrMovies[indexPath.row] as? [String:Any])?["poster_path"] as? String{
                imgurl = "https://image.tmdb.org/t/p/original/" + imgurl
                
                cell?.imgMovieThumb.sd_setImage(with: URL(string: imgurl), placeholderImage: UIImage(named: "default-placeholder"))
                
                cell?.imgMovieThumb.contentMode = .scaleAspectFit
            }
            
            let strTitle =  (arrMovies[indexPath.row] as? [String:Any])?["title"] as? String
            
            let strDescription =  (arrMovies[indexPath.row] as? [String:Any])?["overview"] as? String
            
            let strLanguage =  (arrMovies[indexPath.row] as? [String:Any])?["original_language"] as? String
            
            if let strReleaseDate =  (arrMovies[indexPath.row] as? [String:Any])?["release_date"] as? String {
                cell?.lblMovieReleaseDate.text = "Release Date: " + changeDateFormat(strDate: strReleaseDate)
            }
            
            cell?.lblMovieTitle.text = strTitle
            
            cell?.lblMovieDescription.text = strDescription
            
            cell?.lblMovieCategory.text = strLanguage
            
            cell?.btnDetails.addTarget(self, action: #selector(btnMovieDetailsTapped(_:)), for: .touchUpInside)
            
            return cell!
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 2 == 0{
            return 20
        }else{
            return 140
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            arrMovies.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    //MARK: - Button Action Events
    func btnMovieDetailsTapped(_ sender: UIButton) {
        
        let buttonPoint = sender.convert(CGPoint.zero, to: self.tableView)
        
        if let iPath = self.tableView.indexPathForRow(at: buttonPoint) {
            
            selectedIndex = iPath.row
            
            performSegue(withIdentifier: "segueMovieDetails", sender: self)
            
        }
    }
    
    //MARK: - Calling WebServices
    func callWSToGetMovies(){
        
        if Reachability.isConnectedToNetwork(){
            let strURL = "https://api.themoviedb.org/3/movie/top_rated?api_key=54085c1785e6ed39c08fbc4a7c4aa5de"
            
            callWebService(strURL, parameters: ["":"" as AnyObject], methodHttp: .get, completion: { (response) in
                
                if let arrResult = (response as? [String:Any])?["results"] as? [Any]{
                    self.arrMovies = arrResult
                   
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }

                }
            }, failure: { (error) in
                
            })
        }else{
            showAlertWithErrorMsgAndPopUponOK(alertMsg: "Looks like you're not connected to Internet!")
        }
    }
    
    //MARK: - Notification Handler Methods
    func reachabilityChanged(note: NSNotification) {
    
        let reachability = note.object as! Reachability
        
        if reachability.isReachable {
            if reachability.isReachableViaWiFi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
            self.callWSToGetMovies()
        }else {
            self.showAlertWithErrorMsg(alertMsg: "Looks like you are not connected to Internet")
        }
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueMovieDetails" {
            
            if selectedIndex % 2 != 0{
                
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
            
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                
                if let dict = self.arrMovies [selectedIndex] as? [String: Any]{
                    if let Id = dict["id"] as? Int{
                        controller.str_movie_id = Id
                    }
                    if let str_title =  dict["title"] as? String{
                        controller.title = str_title
                    }
                }
            }
        }
    }
}
