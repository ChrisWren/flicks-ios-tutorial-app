//
//  DetailViewController.swift
//  Flicks
//
//  Created by Chris Wren on 5/16/16.
//  Copyright © 2016 Chris Wren. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {

  
  @IBOutlet weak var posterImageCloseButton: UIButton!
  @IBOutlet weak var overviewLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var posterImageView: UIImageView!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var infoView: UIView!
  
  var movie: NSDictionary!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        let title = movie["title"] as? String
        let overview = movie["overview"] as? String
        titleLabel.text = title
        overviewLabel.text = overview
      
      overviewLabel.sizeToFit()
      scrollView.delegate = self
      scrollView.sizeToFit()
      
      if let posterPath = movie["poster_path"] as? String {
        MoviesViewController.fetchImage(posterImageView, posterPath: posterPath, fullSize: true)

      }
      self.title = title

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  
  @IBAction func tappedPosterImage(sender: UITapGestureRecognizer) {
    infoView.hidden = true
    posterImageCloseButton.hidden = false
  }
  
  override func viewDidAppear(animated: Bool) {
    infoView.sizeToFit()
    scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.bounds.size.height + (navigationController?.navigationBar.frame.height)! + (tabBarController?.tabBar.frame.height)!)
  }
  
  func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
    return posterImageView
  }
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
