//
//  ViewController.swift
//  ImageClassifier
//
//  Created by Matthew Harding on 1/26/18.
//  Copyright © 2018 Matthew Harding. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var scene: UIImageView!
  @IBOutlet weak var answerLabel: UILabel!

  let imageUtil = ImageUtil()
  let mlUtil = CoreMLUtil()

  override func viewDidLoad() {
    super.viewDidLoad()

    let image = imageUtil.selectLocalImage()
    scene.image = image

    guard let ciImage = CIImage(image: image) else {
      fatalError("Couldn't convert UIImage")
    }
    detectScene(image: ciImage)
  }


  @IBAction func newAnimal() {
    pickImage(.animals)
  }

  @IBAction func newFood() {
    pickImage(.food)
  }

  @IBAction func newAll() {
    pickImage(.all)
  }


  func pickImage(_ category: ImageCategory) {
    let image = imageUtil.selectNewImage(category)

    DispatchQueue.main.async {
      self.scene.image = image
    }

    guard let ciImage = CIImage(image: image) else {
      fatalError("Couldn't convert UIImage")
    }
    detectScene(image: ciImage)
  }


  func detectScene(image: CIImage) {
    answerLabel.text = ""
    mlUtil.detectScene(image: image, callback: callbackWithTextResponse)
  }

  func callbackWithTextResponse(text: String) {
    DispatchQueue.main.async {
      let currentText = self.answerLabel.text ?? ""
      self.answerLabel.text = currentText + text
    }
  }

}


