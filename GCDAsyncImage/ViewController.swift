//
//  ViewController.swift
//  GCDAsyncImage
//
//  Created by Chase Wang on 2/23/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  let numberOfCells = 20_000
  
  let imageURLArray = Unsplash.defaultImageURLs
  
  // MARK: - VC Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return numberOfCells
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImageTableViewCell
    
    var url : URL? = nil
    var data = Data()
    
    var image = UIImage()
    
    let workGetImage = DispatchWorkItem {
      url = self.imageURLArray[indexPath.row % self.imageURLArray.count]
      data = try! Data(contentsOf: url!)
      image = UIImage(data: data)!
    }
    
    
    
    let workApplyFilter = DispatchWorkItem {
      let inputImage = CIImage(data: UIImagePNGRepresentation(image)!)!
      let filter = CIFilter(name: "CISepiaTone")!
      filter.setValue(inputImage, forKey: kCIInputImageKey)
      filter.setValue(0.8, forKey: kCIInputIntensityKey)
      let outputCIImage = filter.outputImage
      // This renders the image
      let context = CIContext(options: nil)
      let imageRef = context.createCGImage(outputCIImage!, from: inputImage.extent)!
      
      DispatchQueue.main.async {
        cell.pictureImageView.image = UIImage(cgImage: imageRef)
//          image = imageWithFilter
      }
      
    }
    
//    workApplyFilter.notify(queue: DispatchQueue.main){
////      cell.pictureImageView.image = image
//    }
    
    
    workGetImage.notify(queue: DispatchQueue.main){
      cell.pictureImageView.image = image
      DispatchQueue.global().async(execute : workApplyFilter)
    }
    
    DispatchQueue.global().async(execute : workGetImage)
    
    
    
    //TODO: Get the image Asyc
    
    //If the image is still around then apply the filter
    
    // TODO: add sepia filter to image
    //    DispatchQueue.global().async {
    //
    //      //Do the intensive task - filtering
    //      let inputImage = CIImage(data: UIImagePNGRepresentation(image!)!)
    //      let filter = CIFilter(name: "CISepiaTone")!
    //      filter.setValue(inputImage, forKey: kCIInputImageKey)
    //      filter.setValue(0.8, forKey: kCIInputIntensityKey)
    //      let outputCIImage = filter.outputImage
    //      let imageWithFilter = UIImage(ciImage: outputCIImage!)
    //
    //
    //      DispatchQueue.main.async {
    //        cell.pictureImageView.image = imageWithFilter
    //      }
    //    }
    
    
    
    return cell
  }
}
