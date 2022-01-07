//
//  taskCell.swift
//  webservicesDemo
//
//  Created by elfakharany on 2/6/19.
//  Copyright © 2019 Mohamed Elfakharany. All rights reserved.
//

import UIKit

class taskCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }
    func configureCell (task :Task ) {
    textLabel?.text=task.task
    backgroundColor = task.completed ? .yellow : .clear
    }
}
