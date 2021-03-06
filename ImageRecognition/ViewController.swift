//
//  ViewController.swift
//  ImageRecognition
//
//  Created by javon maxwell on 2022-03-24.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController {
    @IBOutlet weak var labelDescription: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //stores image file
        let imagePath = Bundle.main.path(forResource: "car1", ofType: "jpeg")
        let imageURL = NSURL.fileURL(withPath: imagePath!)
        
        //setup core ml model for image recognition
        let modelFile = MobileNetV2()
        let model = try! VNCoreMLModel(for: modelFile.model)
     
        //get result from calling core-ml with image
        let handler = VNImageRequestHandler(url: imageURL)
        let request = VNCoreMLRequest(model: model, completionHandler: findResults)
        try! handler.perform([request])
    }
    
    //find result in core ml
    func findResults(request: VNRequest, error: Error?) {
       guard let results = request.results as?
       [VNClassificationObservation] else {
       fatalError("Unable to get results")
       }
       var bestGuess = ""
       var bestConfidence: VNConfidence = 0
       for classification in results {
          if (classification.confidence > bestConfidence) {
             bestConfidence = classification.confidence
             bestGuess = classification.identifier
          }
       }
       labelDescription.text = "Image is: \(bestGuess) with confidence \(bestConfidence) out of 1"
    }


}

