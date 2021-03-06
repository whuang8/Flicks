//
//  MoviesViewController.swift
//  Flicks
//
//  Created by William Huang on 12/29/16.
//  Copyright © 2016 William Huang. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate{

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet var searchButton: UIBarButtonItem!
    private var movies: [NSDictionary]?
    private var filteredMovies: [NSDictionary]?
    private let refreshControl = UIRefreshControl()
    private let searchBar = UISearchBar()
    var endpoint: String?
    var pageTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Create search bar
        searchBar.sizeToFit()
        searchBar.delegate = self
        self.navigationItem.rightBarButtonItem = searchButton
        self.navigationItem.title = pageTitle ?? "Flicks"
        self.errorView.isHidden = true
        self.view.bringSubview(toFront: errorView)
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.insertSubview(refreshControl, at: 0)
        self.collectionView.alwaysBounceVertical = true
        
        getMovies(refresh: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        getMovies(refresh: true)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        self.collectionView.cellForItem(at: indexPath)?.alpha = 0.8
    }
    
    public func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        self.collectionView.cellForItem(at: indexPath)?.alpha = 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let movies = self.filteredMovies {
            return movies.count
        } else {
            return 0
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = filteredMovies![indexPath.row]
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        if let posterPath = movie["poster_path"] as? String {
            let imageUrl = URL(string: baseUrl + posterPath)
            let smallImageRequest = NSURLRequest(url: imageUrl!)
            let largeImageRequest = NSURLRequest(url: imageUrl!)
        
            cell.poster.setImageWith(
                smallImageRequest as URLRequest,
                placeholderImage: nil,
                success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                    
                    // imageResponse will be nil if the image is cached
                    if smallImageResponse != nil {
                        
                        UIView.animate(withDuration: 0.3, animations: { () -> Void in
                            
                            cell.poster.alpha = 1.0
                            
                        }, completion: { (sucess) -> Void in
                            
                            // The AFNetworking ImageView Category only allows one request to be sent at a time
                            // per ImageView. This code must be in the completion block.
                            cell.poster.setImageWith(
                                largeImageRequest as URLRequest,
                                placeholderImage: smallImage,
                                success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                    
                                    cell.poster.image = largeImage;
                                    
                            },
                                failure: { (request, response, error) -> Void in
                                    // do something for the failure condition of the large image request
                                    // possibly setting the ImageView's image to a default image
                            })
                        })
                    } else {
                        print("Image was cached so just update the image")
                        cell.poster.image = smallImage
                    }
            },
                failure: { (imageRequest, imageResponse, error) -> Void in
                print("Something wrong occured")
            })
        }
        return cell
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        self.navigationItem.rightBarButtonItem = nil
        self.searchBar.becomeFirstResponder()
        self.navigationItem.titleView = self.searchBar
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredMovies = searchText.isEmpty ? movies : movies?.filter({(movie: NSDictionary) -> Bool in
            let title = movie["title"] as! String
            return title.range(of: searchText, options: .caseInsensitive) != nil
        })
        self.collectionView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.navigationItem.titleView = nil
        self.navigationItem.title = pageTitle ?? "Flicks"
        self.navigationItem.rightBarButtonItem = self.searchButton
    }

    @IBAction func errorOnTap(_ sender: Any) {
        getMovies(refresh: false)
        self.errorView.isHidden = true
    }
    
    func getMovies(refresh: Bool) -> Void {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        var url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        if let endpnt = self.endpoint {
            url = URL(string: "https://api.themoviedb.org/3/movie/\(endpnt)?api_key=\(apiKey)")
        }
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        if refresh == false {
            // Display HUD right before the request is made
            MBProgressHUD.showAdded(to: self.collectionView, animated: true)
        }
        
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest,completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if self.errorView.isHidden == false {
                    self.errorView.isHidden = true
                }
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                    print("response: \(responseDictionary)")
                    self.movies = responseDictionary["results"] as? [NSDictionary]
                    self.filteredMovies = self.movies
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            } else {
                self.errorView.isHidden = false
                // Better way would be to just clear the cache?
                self.filteredMovies?.removeAll()
                self.collectionView.reloadData()
            }
            if refresh {
                self.refreshControl.endRefreshing()
            } else {
                // Hide HUD once the network request comes back
                MBProgressHUD.hide(for: self.collectionView, animated: true)
            }
        })
        task.resume()
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UICollectionViewCell
        let indexPath = self.collectionView.indexPath(for: cell)
        let movie = self.filteredMovies?[(indexPath?.row)!]
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.movie = movie
        self.searchBar.resignFirstResponder()
    }
}
