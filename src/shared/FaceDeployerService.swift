//
//  FaceDeployerService.swift
//  Apple Watch Faces Generator
//
//  Created on Dec 27, 2025
//

import Foundation
import ClockKit

/// Core service for deploying Apple Watch faces
class FaceDeployerService {
    
    // MARK: - Properties
    
    /// Shared instance for singleton pattern
    static let shared = FaceDeployerService()
    
    /// Watch face library instance
    private let watchFaceLibrary = CLKWatchFaceLibrary.shared()
    
    /// Deployment history tracking
    private let deploymentHistory = DeploymentHistory()
    
    // MARK: - Initialization
    
    private init() {}
    
    // MARK: - Public Methods
    
    /// Deploys a watch face with the given name
    /// - Parameter named: The filename of the watch face to deploy
    func deployFace(named: String) {
        guard let faceURL = locateWatchFaceFile(fileName: named) else {
            let error = "Watch face file '\(named)' not found in bundle"
            deploymentHistory.addDeployment(faceName: named, success: false, error: error)
            print("Error: \(error)")
            return
        }
        
        do {
            try watchFaceLibrary.addWatchFace(at: faceURL)
            deploymentHistory.addDeployment(faceName: named, success: true)
            print("Successfully deployed watch face: \(named)")
        } catch let error as NSError {
            let errorMessage = handleClockKitError(error)
            deploymentHistory.addDeployment(faceName: named, success: false, error: errorMessage)
        }
    }
    
    // MARK: - Private Methods
    
    /// Locates the watch face file in the main bundle
    /// - Parameter fileName: The name of the watch face file
    /// - Returns: URL to the watch face file if found
    private func locateWatchFaceFile(fileName: String) -> URL? {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: nil) else {
            return nil
        }
        return url
    }
    
    /// Handles ClockKit errors during deployment
    /// - Parameter error: The error to handle
    /// - Returns: Error message string for logging
    private func handleClockKitError(_ error: Error) -> String {
        let nsError = error as NSError
        
        let errorMessage: String
        switch nsError.code {
        case CLKWatchFaceLibrary.Error.code(.unsupported):
            errorMessage = "Watch face format is not supported"
        case CLKWatchFaceLibrary.Error.code(.invalid):
            errorMessage = "Watch face file is invalid or corrupted"
        case CLKWatchFaceLibrary.Error.code(.alreadyAdded):
            errorMessage = "This watch face is already added"
        case CLKWatchFaceLibrary.Error.code(.notEnoughSpace):
            errorMessage = "Not enough space on Apple Watch"
        case CLKWatchFaceLibrary.Error.code(.watchNotPaired):
            errorMessage = "Apple Watch is not paired"
        default:
            errorMessage = "ClockKit error: \(error.localizedDescription)"
        }
        
        print(errorMessage)
        return errorMessage
    }
    
    /// Get deployment history
    /// - Returns: Deployment history instance
    func getDeploymentHistory() -> DeploymentHistory {
        return deploymentHistory
    }
}
