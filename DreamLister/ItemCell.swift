//
//  itemCell.swift
//  DreamLister
//
//  Created by Pieter Kuijsten on 30/12/2016.
//  Copyright © 2016 Pieter Kuijsten. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var itemType: UILabel!
   
    func configureCell(item: Item) {
        title.text = item.title?.localizedUppercase
        price.text = "€" + (NSString(format: "%.2f", item.price) as String)
        details.text = item.details
        thumb.image = item.toImage?.image as? UIImage
        itemType.text = item.toItemType?.type
    }
}
