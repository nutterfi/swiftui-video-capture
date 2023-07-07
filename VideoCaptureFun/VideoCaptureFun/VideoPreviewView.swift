//
//  VideoView.swift
//  VideoCaptureFun
//
//  Created by nutterfi on 7/6/23.
//

import AppKit
import AVFoundation
import SwiftUI

/// Holds an AVCaptureVideoPreviewLayer
class VideoPreviewView: NSView {
  
  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    setup()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }
  
  func setup() {
    self.layer = AVCaptureVideoPreviewLayer()
    self.wantsLayer = true
  }
  
  var videoPreviewLayer: AVCaptureVideoPreviewLayer {
    guard let layer = layer as? AVCaptureVideoPreviewLayer else {
      fatalError("Expected `AVCaptureVideoPreviewLayer` type for layer. Check PreviewView.layerClass implementation.")
    }
    return layer
  }
  
  var session: AVCaptureSession? {
    get {
      return videoPreviewLayer.session
    }
    set {
      videoPreviewLayer.session = newValue
    }
  }
  
}


struct VideoPreviewViewSUI: NSViewRepresentable {
  
  var session: AVCaptureSession?
  
  init(session: AVCaptureSession?) {
    self.session = session
  }
  
  func makeNSView(context: Context) -> some NSView {
    let view = VideoPreviewView()
    view.session = session
    return view
  }
  
  func updateNSView(_ nsView: NSViewType, context: Context) {
    //NO-OP
  }
}
