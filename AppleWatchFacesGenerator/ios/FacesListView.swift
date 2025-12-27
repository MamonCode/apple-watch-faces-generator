//
//  FacesListView.swift
//  Apple Watch Faces Generator - Faces List
//
//  Created on Dec 27, 2025
//

import SwiftUI

struct FacesListView: View {
    @StateObject private var faceManager = FaceManager()
    @State private var selectedFace: WatchFace?
    
    var body: some View {
        NavigationView {
            VStack {
                if faceManager.isLoading {
                    ProgressView("Loading watch faces...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(faceManager.availableFaces) { face in
                            FaceRowView(face: face) {
                                selectedFace = face
                                faceManager.deployFace(face)
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Available Faces")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Refresh") {
                        faceManager.loadAvailableFaces()
                    }
                }
            }
            .onAppear {
                faceManager.loadAvailableFaces()
            }
        }
    }
}

struct FaceRowView: View {
    let face: WatchFace
    let onDeploy: () -> Void
    
    var body: some View {
        HStack(spacing: 15) {
            // Face preview
            RoundedRectangle(cornerRadius: 12)
                .fill(face.previewColor)
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: "applewatch")
                        .font(.title2)
                        .foregroundColor(.white)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(face.name)
                    .font(.headline)
                
                Text(face.fileName)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.caption)
                    Text("Ready to deploy")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
            
            Spacer()
            
            Button(action: onDeploy) {
                Text("Deploy")
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(15)
            }
        }
        .padding(.vertical, 4)
    }
}

struct FacesListView_Previews: PreviewProvider {
    static var previews: some View {
        FacesListView()
    }
}
