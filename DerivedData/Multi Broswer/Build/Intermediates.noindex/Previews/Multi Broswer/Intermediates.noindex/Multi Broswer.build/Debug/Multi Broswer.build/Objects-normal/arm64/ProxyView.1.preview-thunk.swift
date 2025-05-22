@_private(sourceFile: "ProxyView.swift") import Multi_Broswer
import func SwiftUI.__designTimeBoolean
import func SwiftUI.__designTimeInteger
import protocol SwiftUI.PreviewProvider
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeFloat
import struct SwiftUI.EmptyView
import protocol SwiftUI.View
import SwiftUI

extension ProxyView_Previews {
    @_dynamicReplacement(for: previews) private static var __preview__previews: some View {
        #sourceLocation(file: "/Users/cabbageslayer/Documents/Personal/Multi Broswer/Multi Broswer/Views/ProxyView.swift", line: 25)
        ProxyView()
    
#sourceLocation()
    }
}

extension ProxyView {
    @_dynamicReplacement(for: body) private var __preview__body: some View {
        #sourceLocation(file: "/Users/cabbageslayer/Documents/Personal/Multi Broswer/Multi Broswer/Views/ProxyView.swift", line: 5)
        VStack {
            Image(systemName: __designTimeString("#18963.[1].[0].property.[0].[0].arg[0].value.[0].arg[0].value", fallback: "person.crop.circle.fill"))
                .font(.largeTitle)
                .padding(.bottom)
            Text(__designTimeString("#18963.[1].[0].property.[0].[0].arg[0].value.[1].arg[0].value", fallback: "User Profile"))
                .font(.title)
            Text(__designTimeString("#18963.[1].[0].property.[0].[0].arg[0].value.[2].arg[0].value", fallback: "View and edit your profile information."))
                .padding()
            // Add profile details here
            Text(__designTimeString("#18963.[1].[0].property.[0].[0].arg[0].value.[3].arg[0].value", fallback: "Username: YourName"))
            Text(__designTimeString("#18963.[1].[0].property.[0].[0].arg[0].value.[4].arg[0].value", fallback: "Email: your.email@example.com"))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.green.opacity(__designTimeFloat("#18963.[1].[0].property.[0].[0].modifier[1].arg[0].value.modifier[0].arg[0].value", fallback: 0.1)))
        .navigationTitle(__designTimeString("#18963.[1].[0].property.[0].[0].modifier[2].arg[0].value", fallback: "Profile"))
    
#sourceLocation()
    }
}

import struct Multi_Broswer.ProxyView
import struct Multi_Broswer.ProxyView_Previews

