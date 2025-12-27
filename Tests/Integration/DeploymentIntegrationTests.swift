//
//  DeploymentIntegrationTests.swift
//  Apple Watch Faces Generator - Integration Tests
//
//  Created on Dec 27, 2025
//

import XCTest
import ClockKit
@testable import Apple_Watch_Faces_Generator

class DeploymentIntegrationTests: XCTestCase {
    
    var faceDeployer: FaceDeployerService!
    var faceManager: FaceManager!
    
    override func setUp() {
        super.setUp()
        faceDeployer = FaceDeployerService.shared
        faceManager = FaceManager()
    }
    
    override func tearDown() {
        faceDeployer = nil
        faceManager = nil
        super.tearDown()
    }
    
    func testFaceManagerIntegration() {
        let expectation = XCTestExpectation(description: "Face manager loads faces")
        
        faceManager.loadAvailableFaces()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
        
        // Test that face manager has loaded (even if empty)
        XCTAssertNotNil(faceManager.availableFaces)
    }
    
    func testDeploymentHistoryIntegration() {
        let history = faceDeployer.getDeploymentHistory()
        
        // Test deployment history is accessible
        XCTAssertNotNil(history)
        XCTAssertEqual(history.deployments.count, 0)
        
        // Test adding deployment record
        history.addDeployment(faceName: "test.watchface", success: true)
        XCTAssertEqual(history.deployments.count, 1)
        
        // Test clearing history
        history.clearHistory()
        XCTAssertEqual(history.deployments.count, 0)
    }
    
    func testFaceDeployerWithHistory() {
        let history = faceDeployer.getDeploymentHistory()
        
        // Deploy non-existent face to test error handling
        faceDeployer.deployFace(named: "nonexistent.watchface")
        
        // Give time for async operation
        let expectation = XCTestExpectation(description: "Deployment completes")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
        
        // Verify error was recorded in history
        XCTAssertTrue(history.deployments.contains { $0.faceName == "nonexistent.watchface" && !$0.success })
    }
    
    func testWatchFaceModel() {
        let face = WatchFace(name: "Test Face", fileName: "test.watchface", previewColor: .blue)
        
        XCTAssertEqual(face.name, "Test Face")
        XCTAssertEqual(face.fileName, "test.watchface")
        XCTAssertNotNil(face.id)
    }
}
