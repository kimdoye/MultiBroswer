// TasksViewModel.swift
import SwiftUI
import Foundation // Required for Process, FileManager, Bundle

class TasksViewModel: ObservableObject {
    @Published var tasks: [TaskItem] = [
        TaskItem(name: "Task 1", proxy: ""),
        TaskItem(name: "Task 2", proxy: ""),
        TaskItem(name: "Task 3", proxy: ""),
    ]
    
    @Published var nameInput = ""
    @Published var proxyInput = ""
    
    private let braveBrowserPath = "/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"
    private let defaultURLToOpen = "https://google.com"

    func addTask() {
        let trimmedName = nameInput.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedProxy = proxyInput.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty else {
            // Optionally, provide feedback to the user that name is required
            print("Task name cannot be empty.")
            return
        }
        
        let newTask = TaskItem(name: trimmedName, proxy: trimmedProxy)
        tasks.append(newTask)
        nameInput = ""
        proxyInput = ""
    }
    
    func togglePlayPause(for task: Binding<TaskItem>) {
        task.wrappedValue.isPlaying.toggle()
        
        if task.wrappedValue.isPlaying {
            launchBraveForTask(task.wrappedValue)
        } else {
            // Optional: Add logic to terminate the Brave process if it was started by this task
            // This would require storing the Process object in TaskItem and then calling process.terminate()
            print("Stopped task: \(task.wrappedValue.name)")
            // If you had stored the process: task.wrappedValue.process?.terminate()
        }
    }

    func toggleShow(for task: Binding<TaskItem>) {
        task.wrappedValue.show.toggle()
    }

    // Function to launch Brave Browser for a specific task (macOS specific)
    func launchBraveForTask(_ task: TaskItem) {
        var arguments: [String] = [] // Initialize empty, defaultURLToOpen will be added later

        let fileManager = FileManager.default
        guard var appSpecificSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            print("Error: Could not find Application Support directory for task '\(task.name)'.")
            updateTaskPlayingState(taskID: task.id, isPlaying: false)
            return
        }
        
        let bundleID = Bundle.main.bundleIdentifier ?? "com.example.MyTaskApp" // Provide a fallback bundle ID
        appSpecificSupportURL.appendPathComponent(bundleID)
        appSpecificSupportURL.appendPathComponent("BraveTaskProfiles")
        
        let profilePath = appSpecificSupportURL.appendingPathComponent("TaskProfile-\(task.id.uuidString)")

        do {
            try fileManager.createDirectory(at: profilePath, withIntermediateDirectories: true, attributes: nil)
            arguments.append("--user-data-dir=\(profilePath.path)")
            print("Using profile directory: \(profilePath.path) for task '\(task.name)'")
        } catch {
            print("Error creating profile directory for task '\(task.name)': \(error.localizedDescription)")
            updateTaskPlayingState(taskID: task.id, isPlaying: false)
            return
        }
            
        let trimmedProxy = task.proxy.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedProxy.isEmpty {
            arguments.append("--proxy-server=\(trimmedProxy)")
            print("Using proxy: \(trimmedProxy) for task '\(task.name)'")
        }
        
        arguments.append(defaultURLToOpen) // Add the URL to open
        
        let process = Process()
        process.executableURL = URL(fileURLWithPath: braveBrowserPath)
        process.arguments = arguments
        
        // Optional: Store the process in the task item if you need to manage it later
        // if let taskIndex = tasks.firstIndex(where: { $0.id == task.id }) {
        //     tasks[taskIndex].process = process
        // }
        
        print("Attempting to launch Brave for task '\(task.name)' with URL: \(defaultURLToOpen) and arguments: \(arguments)")

        do {
            try process.run()
            print("Brave launched successfully for task '\(task.name)'.")
            // Set up a termination handler to reset isPlaying state when the browser is closed by the user
            process.terminationHandler = { [weak self] _ in
                print("Brave process terminated for task '\(task.name)'.")
                DispatchQueue.main.async {
                    self?.updateTaskPlayingState(taskID: task.id, isPlaying: false)
                }
            }
        } catch {
            print("Error launching Brave for task '\(task.name)': \(error.localizedDescription)")
            updateTaskPlayingState(taskID: task.id, isPlaying: false)
        }
    }

    private func updateTaskPlayingState(taskID: UUID, isPlaying: Bool) {
        if let index = tasks.firstIndex(where: { $0.id == taskID }) {
            DispatchQueue.main.async { // Ensure UI updates are on the main thread
                self.tasks[index].isPlaying = isPlaying
            }
        }
    }
    
    // You might want a method to remove tasks as well
    func removeTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
}
