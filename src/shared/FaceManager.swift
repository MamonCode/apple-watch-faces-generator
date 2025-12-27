//
//  FaceManager.swift
//  Apple Watch Faces Generator - Face Management
//
//  Created on Dec 27, 2025
//

import Foundation
import SwiftUI

class FaceManager: ObservableObject {
    @Published var availableFaces: [WatchFace] = []
    @Published var deployedFaces: [WatchFace] = []
    @Published var isLoading: Bool = false
    
    private let faceDeployer = FaceDeployerService.shared
    
    init() {
        loadAvailableFaces()
    }
    
    func loadAvailableFaces() {
        isLoading = true
        
        DispatchQueue.global(qos: .background).async {
            let faces = self.scanForWatchFaces()
            
            DispatchQueue.main.async {
                self.availableFaces = faces
                self.isLoading = false
            }
        }
    }
    
    func deployFace(_ face: WatchFace) {
        faceDeployer.deployFace(named: face.fileName)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.deployedFaces.append(face)
        }
    }
    
    private func scanForWatchFaces() -> [WatchFace] {
        let resourcePath = Bundle.main.resourcePath ?? ""
        let fileManager = FileManager.default
        
        guard let enumerator = fileManager.enumerator(atPath: resourcePath) else {
            return []
        }
        
        var faces: [WatchFace] = []
        
        for case let file as String in enumerator {
            if file.hasSuffix(".watchface") {
                let face = WatchFace(
                    name: file.replacingOccurrences(of: ".watchface", with: ""),
                    fileName: file,
                    previewColor: .random()
                )
                faces.append(face)
            }
        }
        
        return faces.sorted { $0.name < $1.name }
    }
}

struct WatchFace: Identifiable, Codable {
    let id = UUID()
    let name: String
    let fileName: String
    let previewColor: Color
    
    enum CodingKeys: String, CodingKey {
        case name, fileName, previewColor
    }
    
    init(name: String, fileName: String, previewColor: Color) {
        self.name = name
        self.fileName = fileName
        self.previewColor = previewColor
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        fileName = try container.decode(String.self, forKey: .fileName)
        
        let colorData = try container.decode(Data.self, forKey: .previewColor)
        if let uiColor = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData) {
            previewColor = Color(uiColor)
        } else {
            previewColor = .blue
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(fileName, forKey: .fileName)
        
        let uiColor = UIColor(previewColor)
        let colorData = try NSKeyedArchiver.archivedData(withRootObject: uiColor, requiringSecureCoding: false)
        try container.encode(colorData, forKey: .previewColor)
    }
}

extension Color {
    static func random() -> Color {
        let colors: [Color] = [.red, .blue, .green, .orange, .purple, .pink, .yellow, .teal]
        return colors.randomElement() ?? .blue
    }
}
