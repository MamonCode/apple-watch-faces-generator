//
//  DeploymentHistory.swift
//  Apple Watch Faces Generator - Deployment Tracking
//
//  Created on Dec 27, 2025
//

import Foundation
import SwiftUI

class DeploymentHistory: ObservableObject {
    @Published var deployments: [DeploymentRecord] = []
    
    private let userDefaults = UserDefaults.standard
    private let deploymentsKey = "deployment_history"
    
    init() {
        loadDeployments()
    }
    
    func addDeployment(faceName: String, success: Bool, error: String? = nil) {
        let record = DeploymentRecord(
            faceName: faceName,
            timestamp: Date(),
            success: success,
            error: error
        )
        
        deployments.append(record)
        saveDeployments()
    }
    
    func clearHistory() {
        deployments.removeAll()
        saveDeployments()
    }
    
    private func loadDeployments() {
        if let data = userDefaults.data(forKey: deploymentsKey),
           let decoded = try? JSONDecoder().decode([DeploymentRecord].self, from: data) {
            deployments = decoded
        }
    }
    
    private func saveDeployments() {
        if let encoded = try? JSONEncoder().encode(deployments) {
            userDefaults.set(encoded, forKey: deploymentsKey)
        }
    }
}

struct DeploymentRecord: Identifiable, Codable {
    let id = UUID()
    let faceName: String
    let timestamp: Date
    let success: Bool
    let error: String?
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }
    
    var statusIcon: String {
        return success ? "checkmark.circle.fill" : "xmark.circle.fill"
    }
    
    var statusColor: Color {
        return success ? .green : .red
    }
}

struct DeploymentHistoryView: View {
    @ObservedObject var history: DeploymentHistory
    
    var body: some View {
        NavigationView {
            List {
                if history.deployments.isEmpty {
                    Text("No deployment history yet")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    ForEach(history.deployments.reversed()) { deployment in
                        DeploymentRowView(deployment: deployment)
                    }
                }
            }
            .navigationTitle("Deployment History")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Clear") {
                        history.clearHistory()
                    }
                    .disabled(history.deployments.isEmpty)
                }
            }
        }
    }
}

struct DeploymentRowView: View {
    let deployment: DeploymentRecord
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: deployment.statusIcon)
                .foregroundColor(deployment.statusColor)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(deployment.faceName)
                    .font(.headline)
                
                Text(deployment.formattedDate)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if let error = deployment.error {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 2)
    }
}
