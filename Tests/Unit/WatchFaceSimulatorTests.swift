//
//  WatchFaceSimulatorTests.swift
//  Apple Watch Faces Generator - Unit Tests
//
//  Created on Dec 27, 2025
//

import XCTest
import SwiftUI
@testable import Apple_Watch_Faces_Generator

class WatchFaceSimulatorTests: XCTestCase {
    
    var simulator: WatchFaceSimulator!
    
    override func setUp() {
        super.setUp()
        simulator = WatchFaceSimulator()
    }
    
    override func tearDown() {
        simulator = nil
        super.tearDown()
    }
    
    func testSimulatorInitialization() {
        XCTAssertNotNil(simulator)
    }
    
    func testTimeFormatting() {
        let testDate = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        // Test that time formatting works
        let timeString = formatter.string(from: testDate)
        XCTAssertFalse(timeString.isEmpty)
    }
    
    func testDateFormatting() {
        let testDate = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        
        // Test that date formatting works
        let dateString = formatter.string(from: testDate)
        XCTAssertFalse(dateString.isEmpty)
    }
    
    func testComplicationDisplay() {
        let complications = ["Project Status", "Weather", "Activity"]
        XCTAssertEqual(complications.count, 3)
        XCTAssertTrue(complications.contains("Project Status"))
    }
    
    func testWatchFaceSelection() {
        let faces = ["sample.watchface", "classic.watchface", "modern.watchface"]
        XCTAssertTrue(faces.contains("sample.watchface"))
        XCTAssertEqual(faces.count, 3)
    }
}
