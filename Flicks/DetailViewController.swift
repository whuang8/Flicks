//
//  DetailViewController.swift
//  Flicks
//
//  Created by William Huang on 1/9/17.
//  Copyright © 2017 William Huang. All rights reserved.
//

import UIKit
import MBProgressHUD

class DetailViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var videoView: UIWebView!
    
    var movie: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMediaContent()
        let title = movie?["title"] as! String
        let overview = movie?["overview"] as! String
        self.titleLabel.text = title
        self.overviewLabel.text = overview
        self.overviewLabel.sizeToFit()
        self.titleLabel.sizeToFit()
        self.infoView.frame = CGRect(x: infoView.frame.origin.x, y: infoView.frame.origin.y, width: infoView.frame.width, height: titleLabel.frame.height + overviewLabel.frame.height + videoView.frame.height + 100)
        self.overviewLabel.frame.origin.y = titleLabel.frame.origin.y + titleLabel.frame.height + 20.0
        videoView.frame.origin.y = overviewLabel.frame.origin.y + overviewLabel.frame.height + 30.0
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: posterImageView.frame.height + infoView.frame.size.height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadYoutube(key: String) {
        guard
            let videoURL = URL(string: "https://www.youtube.com/embed/\(key)")
            else { return }
        videoView.loadRequest( URLRequest(url: videoURL) )
    }
    
    func loadMediaContent() {
        MBProgressHUD.showAdded(to: self.posterImageView, animated: true)
        let movieId = movie?["id"] as! Int
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        if let posterPath = movie?["poster_path"] as? String {
            let imageUrl = NSURL(string: baseUrl + posterPath)
            self.posterImageView.setImageWith(imageUrl as! URL)
        }
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        if let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)/videos?api_key=\(apiKey)"){
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
            let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
            let task: URLSessionDataTask = session.dataTask(with: request as URLRequest,completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                        //print("RESPONSE: \(responseDictionary)")
                        let results = responseDictionary["results"] as! [NSDictionary]
                        let video = results[0]
                        let videoKey = video["key"] as! String
                        self.loadYoutube(key: videoKey)
                    }
                }
            })
            MBProgressHUD.hide(for: self.posterImageView, animated: true)
            task.resume()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
