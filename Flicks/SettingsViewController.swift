//
//  SettingsViewController.swift
//  Flicks
//
//  Created by Chris Wren on 5/17/16.
//  Copyright © 2016 Chris Wren. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

  @IBOutlet weak var listVsGridSegmentControl: UISegmentedControl!
    override func viewDidLoad() {
      super.viewDidLoad()
      
      let listOrGridToggle = NSUserDefaults().stringForKey(FlicksConstants.USER_DEFAULTS.LIST_OR_GRID_TOGGLE.KEY)
      
      if listOrGridToggle == FlicksConstants.USER_DEFAULTS.LIST_OR_GRID_TOGGLE.GRID_VALUE {
        listVsGridSegmentControl.selectedSegmentIndex = 1
      } else {
        listVsGridSegmentControl.selectedSegmentIndex = 0
      }
      

        // Do any additional setup after loading the view.
    }

  @IBAction func listOrGridValueToggled(sender: AnyObject) {
    if (listVsGridSegmentControl.selectedSegmentIndex == 0) {
      NSUserDefaults().setObject(FlicksConstants.USER_DEFAULTS.LIST_OR_GRID_TOGGLE.LIST_VALUE, forKey: FlicksConstants.USER_DEFAULTS.LIST_OR_GRID_TOGGLE.KEY)
    } else {
      NSUserDefaults().setObject(FlicksConstants.USER_DEFAULTS.LIST_OR_GRID_TOGGLE.GRID_VALUE, forKey: FlicksConstants.USER_DEFAULTS.LIST_OR_GRID_TOGGLE.KEY)
    }
    
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
