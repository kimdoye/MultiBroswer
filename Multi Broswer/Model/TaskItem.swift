// TaskItem.swift
import Foundation

struct TaskItem: Identifiable, Codable {
    let id: UUID // Unique identifier for each task
    var name: String
    var proxy: String
    var show: Bool = false // To track play/pause state
    var isPlaying: Bool = false
    // You might add a property to store the Process instance if you need to manage/terminate it later
    // var process: Process? // Optional: Store the process
}
