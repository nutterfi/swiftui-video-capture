//
//  ContentView.swift
//  VideoCaptureFun
//
//  Created by nutterfi on 7/6/23.
//

import SwiftUI

struct ContentView: View {
  @StateObject var viewModel = AVCaptureSessionManager()
  
  var body: some View {
    VStack {
      HStack {
        // Show the original video frame if desired
//        if let session = viewModel.session {
//          VideoPreviewViewSUI(session: session)
//            .frame(maxWidth: .infinity)
//            .frame(height: 300)
//        } else {
//          Text("Looking for camera")
//        }
        
        if let output = viewModel.outputImage4 {
          let nsImage = NSImage(cgImage: output, size: NSSize(width: output.width, height: output.height))
          Image(nsImage: nsImage)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
            .frame(height: 300)
          
        } else {
          Color.yellow
        }
        
        if let output = viewModel.outputImage1 {
          let nsImage = NSImage(cgImage: output, size: NSSize(width: output.width, height: output.height))
          Image(nsImage: nsImage)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
            .frame(height: 300)
          
        } else {
          Color.yellow
        }
      }
      HStack {
        if let output = viewModel.outputImage2 {
          let nsImage = NSImage(cgImage: output, size: NSSize(width: output.width, height: output.height))
          Image(nsImage: nsImage)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
            .frame(height: 300)
          
        } else {
          Color.yellow
        }
        if let output = viewModel.outputImage3 {
          let nsImage = NSImage(cgImage: output, size: NSSize(width: output.width, height: output.height))
          Image(nsImage: nsImage)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
            .frame(height: 300)
          
        } else {
          Color.yellow
        }
      }
    }
    
    .padding()
    .task {
      await viewModel.setup()
    }
  }
}

#Preview {
  ContentView()
}
