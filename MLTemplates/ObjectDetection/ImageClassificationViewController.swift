//
//  ImageClassificationViewController.swift
//  MachineLearning
//
//  Created by anilk on 01/02/2020.
//  Copyright © 2020 anilk. All rights reserved.
//

import UIKit
import AVKit
import Vision

public class ImageClassificationViewController: UIViewController {

    override public func viewDidLoad() {
        super.viewDidLoad()

        let session = AVCaptureSession()
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: device) else { return }
        session.addInput(input)
        session.startRunning()
        
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoCapture"))
        session.addOutput(output)
        
     }
}

extension ImageClassificationViewController: AVCaptureVideoDataOutputSampleBufferDelegate{
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            print("pixelBuffer not found")
            return }
        
        guard let model = try? VNCoreMLModel(for: Resnet50().model) else { return }
        
        let request = VNCoreMLRequest(model: model) { (finishedRequest, err) in
            
            guard let results = finishedRequest.results as? [VNClassificationObservation] else  { return }
            
            guard let firstObservation =  results.first else { return }
            
            DispatchQueue.main.async {
                let title = "\(firstObservation.identifier),\(firstObservation.confidence)"
                self.title = title
                print(title)
            }
        }
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
        
    }
}
