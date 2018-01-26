//
//  CoreMLUtil.swift
//  ImageClassifier
//
//  Created by Matthew Harding on 1/26/18.
//  Copyright © 2018 Matthew Harding. All rights reserved.
//

import UIKit
import CoreML
import Vision

class CoreMLUtil {

  let model1: VNCoreMLModel = setupModel(SqueezeNet().model)
  let model2: VNCoreMLModel = setupModel(MobileNet().model)
  let model3: VNCoreMLModel = setupModel(Inceptionv3().model)
  let model4: VNCoreMLModel = setupModel(Resnet50().model)
  let model5: VNCoreMLModel = setupModel(VGG16().model)

  private static func setupModel(_ model: MLModel) -> VNCoreMLModel {
    guard let vnModel = try? VNCoreMLModel(for: model) else {
      fatalError("Can't load SqueezeNet ML model")
    }
    return vnModel
  }

  func detectScene(image: CIImage, callback: @escaping ((String) -> ())) {
    makeRequest(image, createRequest(model2, "MobileNet", callback))
    makeRequest(image, createRequest(model3, "Inceptionv3", callback))
    makeRequest(image, createRequest(model4, "Resnet50", callback))
    makeRequest(image, createRequest(model5, "VGG16", callback))
  }

  private func makeRequest(_ image: CIImage, _ request: VNCoreMLRequest) {
    let handler = VNImageRequestHandler(ciImage: image)
    DispatchQueue.global(qos: .userInteractive).async {
      do {
        try handler.perform([request])
      } catch {
        print(error)
      }
    }
  }

  private func createRequest(_ model: VNCoreMLModel, _ name: String, _ callback: @escaping ((String) -> ())) -> VNCoreMLRequest {
    let request = VNCoreMLRequest(model: model) { request, error in
      guard let results = request.results as? [VNClassificationObservation] else {
          fatalError("Unexpected result type from VNCoreMLRequest")
      }

      let text = self.createResponseText(name, results)
      callback(text)
    }
    request.imageCropAndScaleOption = .centerCrop
    return request
  }

  private func createResponseText(_ name: String, _ results: [VNClassificationObservation]) -> String {
    var text = "\(name) - "
    for i in 0...2 {
      let result = results[i]
      text = text + "\(Int(result.confidence * 100))% \(result.identifier), "
    }
    text += "\n"
    return text
  }
}


