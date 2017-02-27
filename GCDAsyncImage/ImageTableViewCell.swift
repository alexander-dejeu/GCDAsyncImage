//
//  ImageTableViewCell.swift
//  GCDAsyncImage
//
//  Created by Chase Wang on 2/23/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
  
  @IBOutlet weak var pictureImageView: UIImageView!
  var workGetImage : DispatchWorkItem?
  var workApplyFilter : DispatchWorkItem?
  
  var correctURL : URL?
  
  
  override func prepareForReuse() {
    super.prepareForReuse()
    workGetImage?.cancel()
    workApplyFilter?.cancel()
    
    correctURL = nil
    
    pictureImageView.image = nil 
  }
}
