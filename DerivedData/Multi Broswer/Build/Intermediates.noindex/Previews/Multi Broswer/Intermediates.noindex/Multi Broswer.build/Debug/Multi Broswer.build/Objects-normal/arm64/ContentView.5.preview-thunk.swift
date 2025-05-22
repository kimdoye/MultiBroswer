@_private(sourceFile: "ContentView.swift") import Multi_Broswer
import func SwiftUI.__designTimeSelection
import func SwiftUI.__designTimeBoolean
import func SwiftUI.__designTimeInteger
import protocol SwiftUI.PreviewProvider
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeFloat
import struct SwiftUI.EmptyView
import protocol SwiftUI.View
import SwiftUI

extension MainView {
    @_dynamicReplacement(for: body) private var __preview__body: some View {
        #sourceLocation(file: "/Users/cabbageslayer/Documents/Personal/Multi Broswer/Multi Broswer/ContentView.swift", line: 28)
        __designTimeSelection(Text(__designTimeString("#1983.[3].[0].property.[0].[0].arg[0].value", fallback: "List")), "#1983.[3].[0].property.[0].[0]")
    
#sourceLocation()
    }
}

extension ListView {
    @_dynamicReplacement(for: body) private var __preview__body: some View {
        #sourceLocation(file: "/Users/cabbageslayer/Documents/Personal/Multi Broswer/Multi Broswer/ContentView.swift", line: 23)
        __designTimeSelection(Text(__designTimeString("#1983.[2].[0].property.[0].[0].arg[0].value", fallback: "List")), "#1983.[2].[0].property.[0].[0]")
    
#sourceLocation()
    }
}

extension ContentView {
    @_dynamicReplacement(for: body) private var __preview__body: some View {
        #sourceLocation(file: "/Users/cabbageslayer/Documents/Personal/Multi Broswer/Multi Broswer/ContentView.swift", line: 12)
        __designTimeSelection(NavigationView {
            __designTimeSelection(ListView(), "#1983.[1].[0].property.[0].[0].arg[0].value.[0]")
            
            __designTimeSelection(MainView(), "#1983.[1].[0].property.[0].[0].arg[0].value.[1]")
        }
        .frame(minWidth: __designTimeInteger("#1983.[1].[0].property.[0].[0].modifier[0].arg[0].value", fallback: 600), minHeight:__designTimeInteger("#1983.[1].[0].property.[0].[0].modifier[0].arg[1].value", fallback: 500)), "#1983.[1].[0].property.[0].[0]")
    
#sourceLocation()
    }
}

import struct Multi_Broswer.ContentView
import struct Multi_Broswer.ListView
import struct Multi_Broswer.MainView
#Preview {
    ContentView()
}



