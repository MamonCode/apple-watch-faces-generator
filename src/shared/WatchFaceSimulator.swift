//
//  WatchFaceSimulator.swift
//  Apple Watch Faces Generator - Visual Simulator
//
//  Created on Dec 27, 2025
//

import SwiftUI
import ClockKit

struct WatchFaceSimulator: View {
    @State private var selectedFace: String = "sample.watchface"
    @State private var isDeploying: Bool = false
    @State private var deploymentStatus: String = ""
    @State private var watchTime: Date = Date()
    @State private var complications: [String] = ["Project Status", "Weather", "Activity"]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Watch Face Simulator")
                .font(.title)
                .fontWeight(.bold)
            
            // Watch Face Display
            ZStack {
                // Watch background
                Circle()
                    .fill(Color.black)
                    .frame(width: 200, height: 200)
                
                // Watch face content
                VStack(spacing: 8) {
                    // Time display
                    Text(timeString)
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text(dateString)
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    // Complications preview
                    HStack(spacing: 12) {
                        ForEach(complications, id: \.self) { complication in
                            VStack {
                                Text(complication)
                                    .font(.caption2)
                                    .foregroundColor(.white)
                                Rectangle()
                                    .fill(Color.blue.opacity(0.3))
                                    .frame(width: 40, height: 15)
                                    .cornerRadius(3)
                            }
                        }
                    }
                }
                
                // Digital crown
                Circle()
                    .stroke(Color.gray, lineWidth: 2)
                    .frame(width: 210, height: 210)
            }
            
            // Controls
            VStack(spacing: 15) {
                // Face selection
                VStack(alignment: .leading) {
                    Text("Select Face:")
                        .font(.headline)
                    
                    Picker("Watch Face", selection: $selectedFace) {
                        Text("Sample Face").tag("sample.watchface")
                        Text("Classic Face").tag("classic.watchface")
                        Text("Modern Face").tag("modern.watchface")
                    }
                    .pickerStyle(.segmented)
                }
                
                // Deployment controls
                VStack(spacing: 10) {
                    Button(action: deployFace) {
                        HStack {
                            if isDeploying {
                                ProgressView()
                                    .scaleEffect(0.8)
                            }
                            Text(isDeploying ? "Deploying..." : "Deploy to Watch")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(isDeploying)
                    
                    if !deploymentStatus.isEmpty {
                        Text(deploymentStatus)
                            .font(.caption)
                            .foregroundColor(deploymentStatus.contains("Error") ? .red : .green)
                    }
                }
                
                // Time controls
                HStack {
                    Button("−1h") { adjustTime(-3600) }
                    Spacer()
                    Text("Time Controls")
                        .font(.caption)
                    Spacer()
                    Button("+1h") { adjustTime(3600) }
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
        .onAppear {
            startTimer()
        }
    }
    
    private var timeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: watchTime)
    }
    
    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: watchTime)
    }
    
    private func deployFace() {
        isDeploying = true
        deploymentStatus = ""
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            FaceDeployerService.shared.deployFace(named: selectedFace)
            deploymentStatus = "Successfully deployed \(selectedFace)"
            isDeploying = false
        }
    }
    
    private func adjustTime(_ seconds: TimeInterval) {
        watchTime = watchTime.addingTimeInterval(seconds)
    }
    
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            watchTime = Date()
        }
    }
}

struct WatchFaceSimulator_Previews: PreviewProvider {
    static var previews: some View {
        WatchFaceSimulator()
    }
}
