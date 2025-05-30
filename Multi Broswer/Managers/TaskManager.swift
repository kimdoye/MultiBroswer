// TasksViewModel.swift
import SwiftUI
import Foundation // Required for Process, FileManager, Bundle

class TasksViewModel: ObservableObject {
    @Published var tasks: [TaskItem] = [] {
        didSet { // This will call saveTasks whenever the tasks array changes
            saveTasks()
        }
    }

    @Published var nameInput = ""
    @Published var proxyInput = ""

    private let braveBrowserPath = "/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"
    private let defaultURLToOpen = "https://google.com"

    // Updated to use Application Support Directory
    private var tasksFileURL: URL {
        let fileManager = FileManager.default
        guard let appSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            // Fallback or fatal error if Application Support is not accessible
            // For simplicity, we'll use a fatal error here, but in a real app, handle this more gracefully.
            fatalError("Unable to access Application Support directory.")
        }

        let bundleIdentifier = Bundle.main.bundleIdentifier ?? "com.example.MyTaskApp" // Provide a fallback
        let appSpecificDirectoryURL = appSupportURL.appendingPathComponent(bundleIdentifier)

        // Create the app-specific directory if it doesn't exist
        if !fileManager.fileExists(atPath: appSpecificDirectoryURL.path) {
            do {
                try fileManager.createDirectory(at: appSpecificDirectoryURL, withIntermediateDirectories: true, attributes: nil)
                print("Application Support subdirectory created at: \(appSpecificDirectoryURL.path)")
            } catch {
                // Handle error creating directory - for now, we'll print and continue,
                // which might lead to save/load failures if the directory isn't writable.
                print("Error creating Application Support subdirectory: \(error.localizedDescription)")
                // Potentially return a URL that will fail, or handle more robustly
            }
        }
        return appSpecificDirectoryURL.appendingPathComponent("tasks.json")
    }

    init() {
        loadTasks() // Load tasks when the ViewModel is created
    }

    func loadTasks() {
        let fileURL = tasksFileURL // Access the computed property
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            print("Tasks file does not exist at \(fileURL.path). Starting with an empty list or default tasks.")
            // self.tasks = [] // Or load default tasks
            return
        }

        do {
            let data = try Data(contentsOf: fileURL)
            let decodedTasks = try JSONDecoder().decode([TaskItem].self, from: data)
            self.tasks = decodedTasks
            print("Tasks loaded successfully from: \(fileURL.path)")
        } catch {
            print("Error loading tasks from \(fileURL.path): \(error.localizedDescription). Using default tasks or empty list.")
            // If loading fails, you might want to start with default tasks or an empty list
            // self.tasks = []
        }
    }

    func saveTasks() {
        let fileURL = tasksFileURL // Access the computed property
        do {
            let data = try JSONEncoder().encode(tasks)
            // Using .atomicWrite is good for preventing data corruption if the write is interrupted.
            // .completeFileProtection is for encrypting the file when the device is locked (iOS/macOS).
            try data.write(to: fileURL, options: [.atomicWrite, .completeFileProtection])
            print("Tasks saved successfully to: \(fileURL.path)")
        } catch {
            print("Error saving tasks to \(fileURL.path): \(error.localizedDescription)")
        }
    }

    func addTask() {
        let trimmedName = nameInput.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedProxy = proxyInput.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedName.isEmpty else {
            print("Task name cannot be empty.")
            return
        }

        let newTask = TaskItem(id: UUID(), name: trimmedName, proxy: trimmedProxy)
        tasks.append(newTask) // This will trigger didSet and call saveTasks()
        nameInput = ""
        proxyInput = ""
    }

    func togglePlayPause(for taskBinding: Binding<TaskItem>) {
        // Access the task directly from the tasks array using its ID for safety,
        // as the binding might become stale if the array is modified elsewhere.
        guard let taskIndex = tasks.firstIndex(where: { $0.id == taskBinding.wrappedValue.id }) else {
            print("Task not found for toggling play/pause.")
            return
        }
        
        tasks[taskIndex].isPlaying.toggle() // This triggers didSet on tasks

        if tasks[taskIndex].isPlaying {
            launchBraveForTask(tasks[taskIndex])
        } else {
            print("Stopped task: \(tasks[taskIndex].name)")
            // If you implement process termination, do it here.
            // tasks[taskIndex].process?.terminate()
        }
    }

    func toggleShow(for taskBinding: Binding<TaskItem>) {
        guard let taskIndex = tasks.firstIndex(where: { $0.id == taskBinding.wrappedValue.id }) else {
            print("Task not found for toggling show.")
            return
        }
        tasks[taskIndex].show.toggle() // This triggers didSet on tasks
    }

    func launchBraveForTask(_ task: TaskItem) {
        // Ensure we're working with the latest task data from the array
        guard let currentTask = tasks.first(where: { $0.id == task.id }) else {
            print("Task \(task.name) no longer exists.")
            return
        }

        var arguments: [String] = []
        let fileManager = FileManager.default

        guard let appSupportURLBase = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            print("Error: Could not find Application Support directory for task '\(currentTask.name)'.")
            updateTaskPlayingState(taskID: currentTask.id, isPlaying: false)
            return
        }

        let bundleID = Bundle.main.bundleIdentifier ?? "com.example.MyTaskApp"
        let appSpecificSupportURL = appSupportURLBase.appendingPathComponent(bundleID).appendingPathComponent("BraveTaskProfiles")
        let profilePath = appSpecificSupportURL.appendingPathComponent("TaskProfile-\(currentTask.id.uuidString)")

        do {
            try fileManager.createDirectory(at: profilePath, withIntermediateDirectories: true, attributes: nil)
            arguments.append("--user-data-dir=\(profilePath.path)")
            print("Using profile directory: \(profilePath.path) for task '\(currentTask.name)'")
        } catch {
            print("Error creating profile directory for task '\(currentTask.name)': \(error.localizedDescription)")
            updateTaskPlayingState(taskID: currentTask.id, isPlaying: false)
            return
        }

        let trimmedProxy = currentTask.proxy.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedProxy.isEmpty {
            arguments.append("--proxy-server=\(trimmedProxy)")
            print("Using proxy: \(trimmedProxy) for task '\(currentTask.name)'")
        }

        arguments.append(defaultURLToOpen)

        let process = Process()
        process.executableURL = URL(fileURLWithPath: braveBrowserPath)
        process.arguments = arguments

        print("Attempting to launch Brave for task '\(currentTask.name)' with URL: \(defaultURLToOpen) and arguments: \(arguments)")

        do {
            try process.run()
            print("Brave launched successfully for task '\(currentTask.name)'.")
            process.terminationHandler = { [weak self] _ in
                print("Brave process terminated for task '\(currentTask.name)'.")
                DispatchQueue.main.async {
                    self?.updateTaskPlayingState(taskID: currentTask.id, isPlaying: false)
                }
            }
        } catch {
            print("Error launching Brave for task '\(currentTask.name)': \(error.localizedDescription)")
            updateTaskPlayingState(taskID: currentTask.id, isPlaying: false)
        }
    }

    private func updateTaskPlayingState(taskID: UUID, isPlaying: Bool) {
        if let index = tasks.firstIndex(where: { $0.id == taskID }) {
            // Check if the state actually needs changing to avoid redundant saves via didSet
            if tasks[index].isPlaying != isPlaying {
                tasks[index].isPlaying = isPlaying // This will trigger didSet and saveTasks()
            }
        }
    }

    func removeTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets) // This will trigger didSet and saveTasks()
    }
}
