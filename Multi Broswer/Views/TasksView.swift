// TasksView.swift
import SwiftUI

struct TasksView: View {
    
    @StateObject private var viewModel = TasksViewModel() // Use @StateObject to create and manage the ViewModel instance
    
    var body: some View {
        VStack(alignment: .leading) { // Align content to the leading edge
            
            HStack {
                Text("Tasks")
                    .font(.title)
                    .padding(.horizontal)
                    .padding(.top)
                Spacer();
                
                TextField("Name", text: $viewModel.nameInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: 100)
                    .padding(.top)
                
                TextField("Proxy", text: $viewModel.proxyInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: 100)
                    .padding(.top)
                
                Button(action: {
                    viewModel.addTask()
                }) {
                    Image(systemName: "plus")
                        .font(.title)
                }
                .padding(.horizontal)
                .padding(.top)
            }
            
            List {
                ForEach($viewModel.tasks) { $taskItem in // Use $ to get a binding to each task
                    HStack {
                        Text(taskItem.name)
                        Spacer() // Pushes the buttons to the right
                        
                        Button(action: {
                            viewModel.togglePlayPause(for: $taskItem)
                        }) {
                            Image(systemName: taskItem.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                .foregroundColor(taskItem.isPlaying ? .orange : .green)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        
                        Button(action: {
                           viewModel.toggleShow(for: $taskItem)
                        }) {
                            Image(systemName: taskItem.show ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(taskItem.show ? .gray : .blue)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    .padding(.vertical, 4)
                }
                .onDelete(perform: viewModel.removeTask) // Example: Add swipe to delete
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Tasks")
        }
    }
}

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView()
    }
}
