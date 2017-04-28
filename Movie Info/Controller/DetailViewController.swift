//
//  DetailViewController.swift
//  Movie
//
//  Created by Aditya Tanna on 4/26/17.
//  Copyright © 2017 Tanna Inc. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var str_movie_id = 0
    
    var dictMovieDetails = [String: Any] ()
    
    @IBOutlet var vwDetails: UIView!
    
    @IBOutlet var imgMovieThumb: UIImageView!
    
    @IBOutlet var lblDescription: UILabel!
    
    @IBOutlet var lblReleaseDate: UILabel!
    
    @IBOutlet var lblGenre: UILabel!
    
    @IBOutlet var lblProduction: UILabel!
    
    @IBOutlet var lblBudget: UILabel!
   
    var detailItem: NSDate? {
        didSet {
        }
    }
    
    //MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vwDetails.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: getAppDelegate().reachability)
        do{
            try getAppDelegate().reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }

        if str_movie_id > 0{
            callWSToGetMoviesDetails()
        }
    }
    
    //MARK: - Configure UI
    func configureUI() {
        
        vwDetails.isHidden = false
        
        if var str_url = dictMovieDetails["poster_path"] as? String{
            
            str_url = "https://image.tmdb.org/t/p/original/" + str_url
            
            let url = URL(string: str_url)
            
            imgMovieThumb.sd_setImage(with: url, placeholderImage: UIImage(named: "default-placeholder"))
        }
        
        if let str_description = dictMovieDetails["overview"] as? String{
            
            var frame = lblDescription.frame
        
            let height = str_description.heightWithConstrainedWidth(width: frame.size.width, font: lblDescription.font)
            
            frame.size.height = height
            
            lblDescription.frame = frame
            
            lblDescription.text = "Description: " + str_description
        }
        
        if let str_release_date = dictMovieDetails["release_date"] as? String{
            lblReleaseDate.text = "Release Date: " + changeDateFormat(strDate: str_release_date)
        }
        
        if let arrGenre = dictMovieDetails["genres"] as? [[String:Any]]{
            
            var arrString = [String] ()
            
            for dict in arrGenre{
                if let str = dict["name"] as? String{
                    arrString.append(str)
                }
            }

            lblGenre.text = "Genre: " + arrString.joined(separator: ", ")
        }
        
        if let arrProductionCompany = dictMovieDetails["production_companies"] as? [[String:Any]]{
            
            var arrString = [String] ()
            
            for dict in arrProductionCompany{
                if let str = dict["name"] as? String{
                    arrString.append(str)
                }
            }
            
            lblProduction.text = "Production Company: " + arrString.joined(separator: ", ")
        }
        
        
        if let str_budget = dictMovieDetails["budget"] as? Double{
            lblBudget.text = "Budget: " + "\(str_budget)"
        }
        
        
    }
    
    //MARK: - Calling Web Services
    func callWSToGetMoviesDetails(){
        
        if Reachability.isConnectedToNetwork(){
            let strURL = "https://api.themoviedb.org/3/movie/\(str_movie_id)?api_key=54085c1785e6ed39c08fbc4a7c4aa5de"
            
            callWebService(strURL, parameters: nil, methodHttp: .get, completion: { (response) in
                
                if let dictResult = response as? [String:Any]{
                
                    self.dictMovieDetails = dictResult
                    
                    DispatchQueue.main.async {
                        self.configureUI()
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
            if self.str_movie_id > 0{
                self.callWSToGetMoviesDetails()
            }
        } else {
            self.showAlertWithErrorMsg(alertMsg: "Looks like you are not connected to Internet")
        }
    }
}
