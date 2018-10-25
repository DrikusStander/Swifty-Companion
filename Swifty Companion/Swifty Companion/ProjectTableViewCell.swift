//
//  ProjectTableViewCell.swift
//  Swifty Companion
//
//  Created by Hendrik STANDER on 2018/10/25.
//  Copyright © 2018 Hendrik STANDER. All rights reserved.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {

    @IBOutlet weak var projectName: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var grade: UILabel!
  
    var project: (String, String, Int)?{
        didSet{
            if let p = project{
                projectName.text = p.0
                status.text = p.1
                grade.text = String(p.2)
            }
        }
    }

}
