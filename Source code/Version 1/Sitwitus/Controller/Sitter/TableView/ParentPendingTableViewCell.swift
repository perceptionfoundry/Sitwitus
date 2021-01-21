//
//  ParentPendingTableViewCell.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 12/02/2020.
//  Copyright © 2020 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import HCSStarRatingView

class ParentPendingTableViewCell: UITableViewCell {

     @IBOutlet weak var sitterName: UILabel!
     @IBOutlet weak var sitterImage: UIImageView!
     @IBOutlet weak var sitterAddress: UILabel!
     @IBOutlet weak var sitterRate: UILabel!
     @IBOutlet weak var ratingStar: HCSStarRatingView!
     @IBOutlet weak var messageButton: UIButton!
     @IBOutlet weak var acceptButton: UIButton!
     @IBOutlet weak var pendingButton: UIButton!
     @IBOutlet weak var pendingHours: UILabel!



}
