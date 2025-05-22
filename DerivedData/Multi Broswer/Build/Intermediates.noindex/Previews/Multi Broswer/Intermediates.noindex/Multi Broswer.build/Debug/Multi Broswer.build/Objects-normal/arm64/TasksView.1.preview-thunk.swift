@_private(sourceFile: "TasksView.swift") import Multi_Broswer
import func SwiftUI.__designTimeBoolean
import func SwiftUI.__designTimeInteger
import protocol SwiftUI.PreviewProvider
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeFloat
import struct SwiftUI.EmptyView
import protocol SwiftUI.View
import SwiftUI

extension TasksView_Previews {
    @_dynamicReplacement(for: previews) private static var __preview__previews: some View {
        #sourceLocation(file: "/Users/cabbageslayer/Documents/Personal/Multi Broswer/Multi Broswer/Views/TasksView.swift", line: 195)
        TasksView()
    
#sourceLocation()
    }
}

extension TasksView {
    @_dynamicReplacement(for: launchBraveForTask(_:)) private func __preview__launchBraveForTask(_ task: TaskItem) {
        #sourceLocation(file: "/Users/cabbageslayer/Documents/Personal/Multi Broswer/Multi Broswer/Views/TasksView.swift", line: 121)
        
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
        let bundleID = Bundle.main.bundleIdentifier ?? __designTimeString("#6223.[2].[7].[3].value.[0]", fallback: "com.example.MyTaskApp") // Provide a fallback bundle ID
        appSpecificSupportURL.appendPathComponent(bundleID)
        appSpecificSupportURL.appendPathComponent(__designTimeString("#6223.[2].[7].[5].modifier[0].arg[0].value", fallback: "BraveTaskProfiles"))
        
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
    
#sourceLocation()
    }
}

extension TasksView {
    @_dynamicReplacement(for: addTask()) private func __preview__addTask() {
        #sourceLocation(file: "/Users/cabbageslayer/Documents/Personal/Multi Broswer/Multi Broswer/Views/TasksView.swift", line: 112)
        let newTask = TaskItem(name: nameInput.trimmingCharacters(in: .whitespacesAndNewlines), proxy: proxyInput.trimmingCharacters(in: .whitespacesAndNewlines))
            
        tasks.append(newTask)
        nameInput = __designTimeString("#6223.[2].[6].[2].[0]", fallback: "")
        proxyInput = __designTimeString("#6223.[2].[6].[3].[0]", fallback: "")
    
#sourceLocation()
    }
}

extension TasksView {
    @_dynamicReplacement(for: body) private var __preview__body: some View {
        #sourceLocation(file: "/Users/cabbageslayer/Documents/Personal/Multi Broswer/Multi Broswer/Views/TasksView.swift", line: 29)
        VStack(alignment: .leading) { // Align content to the leading edge
            
            HStack {
                Text(__designTimeString("#6223.[2].[5].property.[0].[0].arg[1].value.[0].arg[0].value.[0].arg[0].value", fallback: "Tasks"))
                    .font(.title)
                    .padding(.horizontal) // Add horizontal padding for the title
                    .padding(.top)      // Add top padding for the title
                Spacer();
                
                TextField(__designTimeString("#6223.[2].[5].property.[0].[0].arg[1].value.[0].arg[0].value.[2].arg[0].value", fallback: "Name"), text: $nameInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle()) // Adds a standard border
                    .frame(maxWidth: __designTimeInteger("#6223.[2].[5].property.[0].[0].arg[1].value.[0].arg[0].value.[2].modifier[1].arg[0].value", fallback: 100))
                     // Give the text field a minimum width
                    .padding(.top)
                
                TextField(__designTimeString("#6223.[2].[5].property.[0].[0].arg[1].value.[0].arg[0].value.[3].arg[0].value", fallback: "Proxy"), text: $proxyInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle()) // Adds a standard border
                    .frame(maxWidth: __designTimeInteger("#6223.[2].[5].property.[0].[0].arg[1].value.[0].arg[0].value.[3].modifier[1].arg[0].value", fallback: 100))
                     // Give the text field a minimum width
                    .padding(.top)

                
                Button(action: {
                    // Define the action for your button here
                   addTask()
                }) {
                    Image(systemName: __designTimeString("#6223.[2].[5].property.[0].[0].arg[1].value.[0].arg[0].value.[4].arg[1].value.[0].arg[0].value", fallback: "plus"))
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
                            Image(systemName: TaskItem.isPlaying ? __designTimeString("#6223.[2].[5].property.[0].[0].arg[1].value.[1].arg[0].value.[0].arg[1].value.[0].arg[0].value.[2].arg[1].value.[0].arg[0].value.then", fallback: "pause.circle.fill") : __designTimeString("#6223.[2].[5].property.[0].[0].arg[1].value.[1].arg[0].value.[0].arg[1].value.[0].arg[0].value.[2].arg[1].value.[0].arg[0].value.else", fallback: "play.circle.fill"))
                                .foregroundColor(TaskItem.isPlaying ? .orange : .green)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        
                        Button(action: {
                            // Action for play/pause
                            TaskItem.show.toggle()
                        }) {
                            Image(systemName: TaskItem.show ? __designTimeString("#6223.[2].[5].property.[0].[0].arg[1].value.[1].arg[0].value.[0].arg[1].value.[0].arg[0].value.[3].arg[1].value.[0].arg[0].value.then", fallback: "eye.slash.fill") : __designTimeString("#6223.[2].[5].property.[0].[0].arg[1].value.[1].arg[0].value.[0].arg[1].value.[0].arg[0].value.[3].arg[1].value.[0].arg[0].value.else", fallback: "eye.fill"))
                                .foregroundColor(TaskItem.show ? .gray : .blue)
                            
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .padding(.vertical, __designTimeInteger("#6223.[2].[5].property.[0].[0].arg[1].value.[1].arg[0].value.[0].arg[1].value.[0].arg[0].value.[3].modifier[1].arg[1].value", fallback: 4)) // Add a little vertical padding to each row
                    }
                }
                // .listStyle(.plain) // You can experiment with different list styles
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            // .background(Color.orange.opacity(0.1)) // Background is optional
            .navigationTitle(__designTimeString("#6223.[2].[5].property.[0].[0].arg[1].value.[1].modifier[1].arg[0].value", fallback: "Tasks")) // This title is for the main window/navigation area if applicable
        }
    
#sourceLocation()
    }
}

import struct Multi_Broswer.TaskItem
import struct Multi_Broswer.TasksView
import struct Multi_Broswer.TasksView_Previews

