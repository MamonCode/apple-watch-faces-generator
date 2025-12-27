//
//  SimulatorView.swift
//  Apple Watch Faces Generator - iOS Simulator
//
//  Created on Dec 27, 2025
//

import SwiftUI

struct SimulatorView: View {
    @State private var showSimulator = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Development Simulator")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Test watch faces without physical Apple Watch")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                VStack(spacing: 20) {
                    // Simulator preview card
                    VStack(spacing: 15) {
                        Image(systemName: "applewatch")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                        
                        Text("Watch Face Simulator")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Preview and test watch faces in real-time")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(15)
                    
                    // Features list
                    VStack(alignment: .leading, spacing: 10) {
                        FeatureRow(icon: "clock", title: "Real-time preview", description: "See watch faces with current time")
                        FeatureRow(icon: "gear", title: "Complications testing", description: "Test widget complications")
                        FeatureRow(icon: "arrow.up.circle", title: "Deployment simulation", description: "Mock deployment process")
                        FeatureRow(icon: "list.bullet", title: "Multiple faces", description: "Switch between different faces")
                    }
                    
                    Button(action: { showSimulator = true }) {
                        Text("Launch Simulator")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Simulator")
            .sheet(isPresented: $showSimulator) {
                WatchFaceSimulator()
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

struct SimulatorView_Previews: PreviewProvider {
    static var previews: some View {
        SimulatorView()
    }
}
