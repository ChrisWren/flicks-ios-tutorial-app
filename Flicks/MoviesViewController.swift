//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Chris Wren on 5/16/16.
//  Copyright © 2016 Chris Wren. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, UIGestureRecognizerDelegate {

  @IBOutlet weak var movieTable: UITableView!
  @IBOutlet weak var networkErrorView: NetworkErrorView!
  @IBOutlet weak var movieCollectionView: UICollectionView!
  
  var movies: [NSDictionary]?
  var filteredMovies: [NSDictionary]?
  var endpoint: String!
  var refreshControl: UIRefreshControl?
  @IBOutlet weak var movieSearchBar: UISearchBar!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    movieTable.dataSource = self
    movieTable.delegate = self
    
    movieCollectionView.dataSource = self
    movieCollectionView.delegate = self
    movieSearchBar.delegate = self
    
    requestMovies()
    AFNetworkReachabilityManager.sharedManager().setReachabilityStatusChangeBlock({ (status :AFNetworkReachabilityStatus) in
      if status == AFNetworkReachabilityStatus.NotReachable {
        self.networkErrorView.hidden = false
      } else {
        self.networkErrorView.hidden = true
      }
    })
    refreshControl = UIRefreshControl()
    refreshControl!.addTarget(self, action: #selector(MoviesViewController.refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
    movieTable.insertSubview(refreshControl!, atIndex: 0)
    AFNetworkReachabilityManager.sharedManager().startMonitoring()
    self.navigationController?.navigationBar.translucent = false
  }
  
  func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
  
  override func viewWillAppear(animated: Bool) {
    
    let listOrGridToggle = NSUserDefaults().stringForKey(FlicksConstants.USER_DEFAULTS.LIST_OR_GRID_TOGGLE.KEY)

    if listOrGridToggle == FlicksConstants.USER_DEFAULTS.LIST_OR_GRID_TOGGLE.GRID_VALUE {
      movieTable.hidden = true
      movieCollectionView.hidden = false
    } else {
      movieCollectionView.hidden = true
      movieTable.hidden = false
    }
  }
  
  override func viewWillDisappear(animated: Bool) {
    movieSearchBar.resignFirstResponder()
  }
  
  func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    updateResults(searchText)
  }
  
  func updateResults(searchText: String) {
    if (searchText.isEmpty) {
      filteredMovies = movies
    } else {
      filteredMovies = movies?.filter({(movie) in
        let title = movie["title"] as! String
        return title.rangeOfString(searchText) != nil
      })
    }
    movieTable.reloadData()
    movieCollectionView.reloadData()
  }

  func refreshControlAction(refreshControl: UIRefreshControl) {
    requestMovies()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filteredMovies?.count ?? 0
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
    let movie = filteredMovies![indexPath.row]
    let title = movie["title"] as! String
    let overview = movie["overview"] as! String
    
    cell.titleLabel.text! = title
    cell.overviewLabel.text = overview
    
    if let posterPath = movie["poster_path"] as? String {
      fetchImage(cell.posterImage, posterPath: posterPath)
    }
    
    return cell
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return filteredMovies?.count ?? 0
  }
  
  func fetchImage(imageView: UIImageView, posterPath: String) {
    let largeImageBaseUrl = "https://image.tmdb.org/t/p/w342"
    let smallImageBaseUrl = "https://image.tmdb.org/t/p/w45"
    
      let smallImageRequest = NSURLRequest(URL: NSURL(string: smallImageBaseUrl + posterPath)!)
      let largeImageRequest = NSURLRequest(URL: NSURL(string: largeImageBaseUrl + posterPath)!)
      
      imageView.setImageWithURLRequest(
        smallImageRequest,
        placeholderImage: nil,
        success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
          
          // smallImageResponse will be nil if the smallImage is already available
          // in cache (might want to do something smarter in that case).
          
          if smallImageResponse == nil {
            imageView.alpha = 0.0
            imageView.image = smallImage;
          }
          
          let duration = smallImageResponse != nil ? 0.3 : 0
          
          
          UIView.animateWithDuration(duration, animations: { () -> Void in
            
           imageView.alpha = 1.0
            
            }, completion: { (sucess) -> Void in
              
              // The AFNetworking ImageView Category only allows one request to be sent at a time
              // per ImageView. This code must be in the completion block.
              imageView.setImageWithURLRequest(
                largeImageRequest,
                placeholderImage: smallImage,
                success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                  
                  imageView.image = largeImage;
                  
                },
                failure: { (request, response, error) -> Void in
                  // do something for the failure condition of the large image request
                  // possibly setting the ImageView's image to a default image
              })
          })
        },
        failure: { (request, response, error) -> Void in
          // do something for the failure condition
          // possibly try to get the large image
      })

  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieCollectionViewCell", forIndexPath: indexPath) as! MovieCollectionViewCell
    
    cell.posterImage.image = UIImage(named: "movie-placeholder")
    let movie = filteredMovies![indexPath.row]
    let title = movie["title"] as! String
    
    cell.titleLabel.text! = title
    
    if let posterPath = movie["poster_path"] as? String {
      fetchImage(cell.posterImage, posterPath: posterPath)
    }
    
    return cell
  }
  
  @IBAction func tapGestureRecognized(sender: UITapGestureRecognizer) {
      movieSearchBar.resignFirstResponder()
  }
  
  @IBAction func panOnView(sender: AnyObject) {
    movieSearchBar.resignFirstResponder()
  }

  func requestMovies()
  {
    let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
    let request = NSURLRequest(
      URL: url!,
      cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
      timeoutInterval: 10)
    
    let session = NSURLSession(
      configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
      delegate: nil,
      delegateQueue: NSOperationQueue.mainQueue()
    )
    
    // When no refresh control is shown, use the default progress spinner
    if !(self.refreshControl?.refreshing ?? false) {
      MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    }
    
    let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
                                                                 completionHandler: { (dataOrNil, response, error) in
                                                                  // Hide HUD once the network request comes back (must be done on main UI thread)
                                                                  MBProgressHUD.hideHUDForView(self.view, animated: true)
                                                                  if let data = dataOrNil {
                                                                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                                                                      data, options:[]) as? NSDictionary {
                                                                      self.movies = responseDictionary["results"] as? [NSDictionary]
                                                                      self.updateResults(self.movieSearchBar.text ?? "")
                                                                      
                                                                      if (self.refreshControl != nil) {
                                                                        self.refreshControl!.endRefreshing()
                                                                      }
                                                                      
                                                                      self.movieTable.reloadData()
                                                                      self.movieCollectionView.reloadData()
                                                                      print("response: \(responseDictionary)")
                                                                      
                                                                    }
                                                                  } else {
                                                                    self.networkErrorView.hidden = false
                                                                  }
    })
    task.resume()
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "MoviesToSettings" {
      return
    } else if segue.identifier == "MovieCollectionToDetails" {
      let cell = sender as! UICollectionViewCell
      let indexPath = movieCollectionView.indexPathForCell(cell)
      let movie = filteredMovies![indexPath!.row]
      
      let detailViewController = segue.destinationViewController as! DetailViewController
      detailViewController.movie = movie
    } else if segue.identifier == "MovieTableCellToDetails" {
      let cell = sender as! UITableViewCell
      let indexPath = movieTable.indexPathForCell(cell)
      let movie = filteredMovies![indexPath!.row]
      
      let detailViewController = segue.destinationViewController as! DetailViewController
      detailViewController.movie = movie
    }

    
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
  }

  
  
}

