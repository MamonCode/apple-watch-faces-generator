//
//  HistoryView.swift
//  Apple Watch Faces Generator - Deployment History
//
//  Created on Dec 27, 2025
//

import SwiftUI

struct HistoryView: View {
    @StateObject private var history = FaceDeployerService.shared.getDeploymentHistory()
    
    var body: some View {
        DeploymentHistoryView(history: history)
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
