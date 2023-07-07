//
//  AVCaptureSessionManager.swift
//  VideoCaptureFun
//
//  Created by nutterfi on 7/7/23.
//

import Foundation
import AVKit
import CoreImage.CIFilterBuiltins

class AVCaptureSessionManager: NSObject, ObservableObject {
  
  @Published private(set) var session: AVCaptureSession?
  @Published private(set) var outputImage1: CGImage?
  @Published private(set) var outputImage2: CGImage?
  @Published private(set) var outputImage3: CGImage?
  @Published private(set) var outputImage4: CGImage?

  var context = CIContext()
  
  var isAuthorized: Bool {
    get async {
      let status = AVCaptureDevice.authorizationStatus(for: .video)
      
      // Determine if the user previously authorized camera access.
      var isAuthorized = status == .authorized
      
      // If the system hasn't determined the user's authorization status,
      // explicitly prompt them for approval.
      if status == .notDetermined {
        isAuthorized = await AVCaptureDevice.requestAccess(for: .video)
      }
      
      return isAuthorized
    }
  }
  
  func setup() async {
    await setUpCaptureSession()
    // TODO: setup CIFilters if we want to allow input parameter adjustments
  }
  
  func setUpCaptureSession() async {
    guard await isAuthorized else { return }
    // Set up the capture session.
    let captureSession = AVCaptureSession()
    
    captureSession.beginConfiguration()
    guard let videoDevice = AVCaptureDevice.default(
      .externalUnknown,
      for: .video,
      position: .unspecified) else {
      return
    }
    
    guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
      captureSession.canAddInput(videoDeviceInput)
    else {
      return
    }
    
    captureSession.addInput(videoDeviceInput)
    
    let output = AVCaptureVideoDataOutput()
    guard captureSession.canAddOutput(output) else {
      return
    }
    captureSession.sessionPreset = .medium
    captureSession.addOutput(output)
    
    output.setSampleBufferDelegate(self, queue: DispatchQueue.main )
    
    captureSession.commitConfiguration()
    
    Task { @MainActor in
      self.session = captureSession
      session?.startRunning()
    }
  }
}

extension AVCaptureSessionManager: AVCaptureVideoDataOutputSampleBufferDelegate {
  
  func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    
    guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
        return
    }
    
    let inputImage = CIImage(cvPixelBuffer: imageBuffer)
    
    // For now we are hardcoding a handful of built-in filters, but eventually will want to dynamically build a filter from an input
    
    let filter = CIFilter.photoEffectNoir()
    filter.inputImage = inputImage
    if let maybeOutput = filter.outputImage {
      outputImage1 = context.createCGImage(maybeOutput, from: maybeOutput.extent)
    }
    
    let filter2 = CIFilter.pixellate()
    filter2.inputImage = inputImage
    if let maybeOutput = filter2.outputImage {
      outputImage2 = context.createCGImage(maybeOutput, from: maybeOutput.extent)
    }
    
    let filter3 = CIFilter.comicEffect()
    filter3.inputImage = inputImage
    if let maybeOutput = filter3.outputImage {
      outputImage3 = context.createCGImage(maybeOutput, from: maybeOutput.extent)
    }
    
    
    let filter4 = CIFilter.colorInvert()
    filter4.inputImage = inputImage
    if let maybeOutput = filter4.outputImage {
      outputImage4 = context.createCGImage(maybeOutput, from: maybeOutput.extent)
    }
    
  }
  
  func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    print("I DROPPED DATA")
  }
}
