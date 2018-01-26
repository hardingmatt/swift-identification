//
//  ImageUtil.swift
//  ImageClassifier
//
//  Created by Matthew Harding on 1/26/18.
//  Copyright © 2018 Matthew Harding. All rights reserved.
//

import UIKit

class ImageUtil {

  private let images = ["1.jpeg", "2.jpeg", "3.jpeg", "4.jpeg", "5.jpeg", "6.jpeg", "7.jpeg", "8.jpeg", "9.jpeg", "10.jpeg", "11.jpeg", "12.jpeg", "13.jpeg", "14.jpeg", "15.jpeg"]
  private var currentImage = 0

  func selectLocalImage() -> UIImage {
    guard let image = UIImage(named: images[currentImage]) else {
      fatalError("no starting image")
    }
    incrementCurrentImage()
    return image
  }

  private func incrementCurrentImage() {
    currentImage = (currentImage + 1) % images.count
  }

  func selectNewImage(_ category: ImageCategory = .all) -> UIImage {
    let url = category.url()

    if let data = try? Data(contentsOf: url) {
      return UIImage(data: data)!
    } else {
      return selectLocalImage()
    }
  }
}

enum ImageCategory {
  case animals, food, all

  func url() -> URL {
    switch self {
    case .animals:
      return URL(string: "https://lorempixel.com/320/320/animals/")!
    case .food:
      return URL(string: "https://lorempixel.com/320/320/food/")!
    case .all:
      return URL(string: "https://lorempixel.com/320/320/")!
    }
  }
}
