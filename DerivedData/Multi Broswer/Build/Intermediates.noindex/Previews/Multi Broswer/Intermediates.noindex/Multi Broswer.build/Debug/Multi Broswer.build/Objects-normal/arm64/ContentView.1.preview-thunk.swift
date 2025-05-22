@_private(sourceFile: "ContentView.swift") import Multi_Broswer
import func SwiftUI.__designTimeBoolean
import func SwiftUI.__designTimeInteger
import protocol SwiftUI.PreviewProvider
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeFloat
import struct SwiftUI.EmptyView
import protocol SwiftUI.View
import SwiftUI

extension ContentView_Previews {
    @_dynamicReplacement(for: previews) private static var __preview__previews: some View {
        #sourceLocation(file: "/Users/cabbageslayer/Documents/Personal/Multi Broswer/Multi Broswer/Views/ContentView.swift", line: 42)
        ContentView()
    
#sourceLocation()
    }
}

extension ContentView {
    @_dynamicReplacement(for: body) private var __preview__body: some View {
        #sourceLocation(file: "/Users/cabbageslayer/Documents/Personal/Multi Broswer/Multi Broswer/Views/ContentView.swift", line: 9)
        NavigationView {
            // Sidebar
            List {
                
                NavigationLink(destination: TasksView()) {
                    Label(__designTimeString("#11720.[1].[0].property.[0].[0].arg[0].value.[0].arg[0].value.[0].arg[1].value.[0].arg[0].value", fallback: "Tasks"), systemImage: __designTimeString("#11720.[1].[0].property.[0].[0].arg[0].value.[0].arg[0].value.[0].arg[1].value.[0].arg[1].value", fallback: "house.fill"))
                }
                NavigationLink(destination: ProxyView()) {
                    Label(__designTimeString("#11720.[1].[0].property.[0].[0].arg[0].value.[0].arg[0].value.[1].arg[1].value.[0].arg[0].value", fallback: "Proxy"), systemImage: __designTimeString("#11720.[1].[0].property.[0].[0].arg[0].value.[0].arg[0].value.[1].arg[1].value.[0].arg[1].value", fallback: ".fill"))
                }

                NavigationLink(destination: SettingsView()) {
                    Label(__designTimeString("#11720.[1].[0].property.[0].[0].arg[0].value.[0].arg[0].value.[2].arg[1].value.[0].arg[0].value", fallback: "Settings"), systemImage: __designTimeString("#11720.[1].[0].property.[0].[0].arg[0].value.[0].arg[0].value.[2].arg[1].value.[0].arg[1].value", fallback: "gearshape.fill"))
                }
                
                
                // Add more menu items here
            }
            .listStyle(SidebarListStyle()) // This style is standard for macOS sidebars
            .frame(minWidth: __designTimeInteger("#11720.[1].[0].property.[0].[0].arg[0].value.[0].modifier[1].arg[0].value", fallback: 180), idealWidth: __designTimeInteger("#11720.[1].[0].property.[0].[0].arg[0].value.[0].modifier[1].arg[1].value", fallback: 200), maxWidth: __designTimeInteger("#11720.[1].[0].property.[0].[0].arg[0].value.[0].modifier[1].arg[2].value", fallback: 250)) // Adjust sidebar width as needed
            
            
            //Default View
            TasksView()
        }
        
        .frame(minWidth: __designTimeInteger("#11720.[1].[0].property.[0].[0].modifier[0].arg[0].value", fallback: 700), minHeight: __designTimeInteger("#11720.[1].[0].property.[0].[0].modifier[0].arg[1].value", fallback: 400))
    
#sourceLocation()
    }
}

import struct Multi_Broswer.ContentView
import struct Multi_Broswer.ContentView_Previews

