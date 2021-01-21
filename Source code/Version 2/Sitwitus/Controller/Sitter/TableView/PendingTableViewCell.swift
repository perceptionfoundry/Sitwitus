//
//  PendingTableViewCell.swift
//  Sitwitus
//
//  Created by Syed ShahRukh Haider on 06/02/2020.
//  Copyright © 2020 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import HCSStarRatingView

class PendingTableViewCell: UITableViewCell {

     @IBOutlet weak var personName: UILabel!
     @IBOutlet weak var personImage: UIImageView!
     @IBOutlet weak var personAddress: UILabel!
     @IBOutlet weak var ratingStar: HCSStarRatingView!
     @IBOutlet weak var messageButton: UIButton!
     @IBOutlet weak var pendingButton: UIButton!
     @IBOutlet weak var pendingHours: UILabel!


}
