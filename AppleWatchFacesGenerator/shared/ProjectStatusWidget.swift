//
//  ProjectStatusWidget.swift
//  Apple Watch Faces Generator - Widget Extension
//
//  Created on Dec 27, 2025
//

import SwiftUI
import WidgetKit

struct ProjectStatusWidget: Widget {
    let kind: String = "ProjectStatusWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ProjectStatusProvider()) { entry in
            ProjectStatusEntryView(entry: entry)
        }
        .configurationDisplayName("Project Status")
        .description("Displays current project status and progress")
        .supportedFamilies([.accessoryRectangular])
    }
}

struct ProjectStatusEntry: TimelineEntry {
    let date: Date
    let status: String
    let progress: Double
}

struct ProjectStatusEntryView: View {
    let entry: ProjectStatusEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Project Status")
                .font(.caption2)
                .fontWeight(.bold)
            
            Text(entry.status)
                .font(.caption)
                .lineLimit(1)
            
            ProgressView(value: entry.progress)
                .progressViewStyle(.linear)
                .scaleEffect(y: 0.5)
        }
        .padding(.horizontal, 4)
    }
}

struct ProjectStatusProvider: TimelineProvider {
    func placeholder(in context: Context) -> ProjectStatusEntry {
        ProjectStatusEntry(date: Date(), status: "Building...", progress: 0.75)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (ProjectStatusEntry) -> ()) {
        let entry = ProjectStatusEntry(date: Date(), status: "In Progress", progress: 0.5)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [ProjectStatusEntry] = []
        let currentDate = Date()
        
        // Create entries for the next 5 hours
        for hourOffset in 0..<5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let progress = Double(hourOffset) / 4.0
            let status = getStatusForProgress(progress)
            
            entries.append(ProjectStatusEntry(date: entryDate, status: status, progress: progress))
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    private func getStatusForProgress(_ progress: Double) -> String {
        switch progress {
        case 0.0:
            return "Starting..."
        case 0.25:
            return "Setup Complete"
        case 0.5:
            return "Building Faces"
        case 0.75:
            return "Testing..."
        case 1.0:
            return "Complete!"
        default:
            return "In Progress"
        }
    }
}

@main
struct ProjectStatusWidgetBundle: WidgetBundle {
    var body: some Widget {
        ProjectStatusWidget()
    }
}
