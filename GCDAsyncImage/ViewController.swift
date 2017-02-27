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
    
    let url : URL = self.imageURLArray[indexPath.row % self.imageURLArray.count]
    var data = Data()
    var image = UIImage()
    
    cell.correctURL = url
    cell.workGetImage = DispatchWorkItem {
      data = try! Data(contentsOf: url)
      image = UIImage(data: data)!
    }
    
    cell.workApplyFilter = DispatchWorkItem {
      guard let data = UIImagePNGRepresentation(cell.pictureImageView.image!) else{ return }
      guard let inputImage = CIImage(data: data) else{ return }
      
        let filter = CIFilter(name: "CISepiaTone")!
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(0.8, forKey: kCIInputIntensityKey)
        let outputCIImage = filter.outputImage
        // This renders the image
        let context = CIContext(options: nil)
        let imageRef = context.createCGImage(outputCIImage!, from: (inputImage.extent))!
        
        DispatchQueue.main.async {
          if cell.correctURL != url{
            return
          }
          cell.pictureImageView.image = UIImage(cgImage: imageRef)
        }
  
    }
    
    cell.workGetImage?.notify(queue: DispatchQueue.main){
      if cell.correctURL != url{
        return
      }
      cell.pictureImageView.image = image
      DispatchQueue.global().async(execute : cell.workApplyFilter!)
    }
    
    DispatchQueue.global().async(execute : cell.workGetImage!)
    
    return cell
  }
}
