import SwiftUI

struct ContentView: View {
    // Optional: You can use @State to manage selection if you need more complex logic,
    // but for simple navigation, NavigationLink is often enough.
    // @State private var selection: String? // Example: Use item IDs or names

    var body: some View {
        NavigationView {
            // Sidebar
            List {
                
                NavigationLink(destination: TasksView()) {
                    Label("Tasks", systemImage: "house.fill")
                }
                NavigationLink(destination: ProxyView()) {
                    Label("Proxy", systemImage: ".fill")
                }

                NavigationLink(destination: SettingsView()) {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                
                
                // Add more menu items here
            }
            .listStyle(SidebarListStyle()) // This style is standard for macOS sidebars
            .frame(minWidth: 180, idealWidth: 200, maxWidth: 250) // Adjust sidebar width as needed
            
            
            //Default View
            TasksView()
        }
        
        .frame(minWidth: 700, minHeight: 400)
    }

    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
