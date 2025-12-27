//
//  ContentView.swift
//  Apple Watch Faces Generator - iOS App
//
//  Created on Dec 27, 2025
//

import SwiftUI

struct ContentView: View {
    @StateObject private var faceDeployer = FaceDeployerService.shared
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Apple Watch Faces Generator")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                Text("Deploy custom watch faces to your Apple Watch")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                VStack(spacing: 15) {
                    Button("Deploy Sample Face") {
                        faceDeployer.deployFace(named: "sample.watchface")
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    
                    NavigationLink(destination: SimulatorView()) {
                        Text("Open Simulator")
                    }
                    .buttonStyle(.bordered)
                    
                    NavigationLink(destination: FacesListView()) {
                        Text("View Available Faces")
                    }
                    .buttonStyle(.bordered)
                }
                
                Spacer()
                
                Text("Note: Make sure your Apple Watch is paired and connected")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .navigationTitle("Watch Faces")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
