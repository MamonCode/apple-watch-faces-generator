//
//  WatchFaceView.swift
//  Apple Watch Faces Generator - WatchOS App
//
//  Created on Dec 27, 2025
//

import SwiftUI

struct WatchFaceView: View {
    @StateObject private var faceDeployer = FaceDeployerService.shared
    
    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                Text("Watch Faces")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text("Manage your custom faces")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                VStack(spacing: 10) {
                    Button("Deploy Sample") {
                        faceDeployer.deployFace(named: "sample.watchface")
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Browse Faces") {
                        // TODO: Navigate to faces list
                    }
                    .buttonStyle(.bordered)
                }
                
                Spacer()
            }
            .navigationTitle("Faces")
        }
    }
}

struct WatchFaceView_Previews: PreviewProvider {
    static var previews: some View {
        WatchFaceView()
    }
}
