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
      
      let baseUrl = "https://image.tmdb.org/t/p/original"
      
      if let posterPath = movie["poster_path"] as? String {
        let posterUrl = NSURL(string: baseUrl + posterPath)
        posterImageView.setImageWithURL(posterUrl!)
      }
      navigationController?.navigationItem.title = title
      
      scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)

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
