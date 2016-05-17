//
//  DetailViewController.swift
//  Flicks
//
//  Created by Chris Wren on 5/16/16.
//  Copyright © 2016 Chris Wren. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

  
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
      
      let baseUrl = "https://image.tmdb.org/t/p/original"
      
      if let posterPath = movie["poster_path"] as? String {
        let posterUrl = NSURL(string: baseUrl + posterPath)
        posterImageView.setImageWithURL(posterUrl!)
      }
        print(movie)
      
      scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
