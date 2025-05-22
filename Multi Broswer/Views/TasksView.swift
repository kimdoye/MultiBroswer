// TasksView.swift
import SwiftUI

struct TaskItem: Identifiable {
    let id = UUID() // Unique identifier for each task
    var name: String
    var proxy: String
    var show: Bool = false // To track play/pause state
    var isPlaying: Bool = false
}

struct TasksView: View {
    
    @State private var tasks: [TaskItem] = [
        TaskItem(name: "Task 1", proxy: ""),
        TaskItem(name: "Task 2", proxy: ""),
        TaskItem(name: "Task 3", proxy: ""),
    ]
    
    @State private var nameInput = ""
    @State private var proxyInput = ""
    
    private let braveBrowserPath = "/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"
    // Base URL to open in Brave
    private let defaultURLToOpen = "https://google.com"
    

    var body: some View {
        VStack(alignment: .leading) { // Align content to the leading edge
            
            HStack {
                Text("Tasks")
                    .font(.title)
                    .padding(.horizontal) // Add horizontal padding for the title
                    .padding(.top)      // Add top padding for the title
                Spacer();
                
                TextField("Name", text: $nameInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle()) // Adds a standard border
                    .frame(maxWidth: 100)
                     // Give the text field a minimum width
                    .padding(.top)
                
                TextField("Proxy", text: $proxyInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle()) // Adds a standard border
                    .frame(maxWidth: 100)
                     // Give the text field a minimum width
                    .padding(.top)

                
                Button(action: {
                    // Define the action for your button here
                   addTask()
                }) {
                    Image(systemName: "plus")
                        .font(.title) // Optional: Adjust the size of the plus icon
                }
                .padding(.horizontal) // Add horizontal padding for the button
                .padding(.top)      // Add top padding for the button (to match the title

            }

            
            
            
            // List of tasks
            List {
                // Loop through the tasks array
                // To modify items in the list (like toggling isPlaying),
                // we need to iterate over the indices if tasks is a @State array of structs.
                ForEach($tasks) { $TaskItem in // Use $ to get a binding to each task
                    HStack {
                        Text(TaskItem.name)
                        Spacer() // Pushes the buttons to the right
                        
                        Button(action: {
                            // Action to toggle the isPlaying state
                            
                            TaskItem.isPlaying.toggle()
                            if(TaskItem.isPlaying == true)
                            {
                                launchBraveForTask(TaskItem)

                            }
                        }) {
                            // Display an icon based on the 'isPlaying' state
                            Image(systemName: TaskItem.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                .foregroundColor(TaskItem.isPlaying ? .orange : .green)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        
                        Button(action: {
                            // Action for play/pause
                            TaskItem.show.toggle()
                        }) {
                            Image(systemName: TaskItem.show ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(TaskItem.show ? .gray : .blue)
                            
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .padding(.vertical, 4) // Add a little vertical padding to each row
                    }
                }
                // .listStyle(.plain) // You can experiment with different list styles
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            // .background(Color.orange.opacity(0.1)) // Background is optional
            .navigationTitle("Tasks") // This title is for the main window/navigation area if applicable
        }
    }
    private func addTask() {
        let newTask = TaskItem(name: nameInput.trimmingCharacters(in: .whitespacesAndNewlines), proxy: proxyInput.trimmingCharacters(in: .whitespacesAndNewlines))
            
        tasks.append(newTask)
        nameInput = ""
        proxyInput = ""
    }
    
    // Function to launch Brave Browser for a specific task (macOS specific)
    private func launchBraveForTask(_ task: TaskItem) {
        
        var arguments: [String] = [defaultURLToOpen]

        let fileManager = FileManager.default
        guard var appSpecificSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            print("Error: Could not find Application Support directory for task '\(task.name)'.")
            // Find index to update isPlaying state
            if let taskIndex = tasks.firstIndex(where: { $0.id == task.id }) {
                DispatchQueue.main.async {
                    tasks[taskIndex].isPlaying = false
                }
            }
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
            // Find index to update isPlaying state
            if let taskIndex = tasks.firstIndex(where: { $0.id == task.id }) {
                DispatchQueue.main.async {
                    tasks[taskIndex].isPlaying = false
                }
            }
            return
        }
                
        
        let process = Process()
        process.executableURL = URL(fileURLWithPath: braveBrowserPath)
        
        //proxy
        let trimmedProxy = task.proxy.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedProxy.isEmpty {
            arguments.append("--proxy-server=\(trimmedProxy)")
            print("Using proxy: \(trimmedProxy) for task '\(task.name)'")
        }
        
        // Arguments will just be the URL to open.
        // No custom profile or proxy settings will be applied.
        // This will use Brave's default profile.
        arguments.append(defaultURLToOpen)
        
        process.arguments = arguments
        
        print("Attempting to launch Brave for task '\(task.name)' with URL: \(defaultURLToOpen)")

        do {
            try process.run()
            print("Brave launched successfully for task '\(task.name)'.")
        } catch {
            print("Error launching Brave for task '\(task.name)': \(error.localizedDescription)")
            // Revert isPlaying state if launch fails
            if let index = tasks.firstIndex(where: { $0.id == task.id }) {
                tasks[index].isPlaying = false
            }
        }
    }
    

}
 


struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView()
    }
}
