import SwiftUI

struct ProxyView: View {
    var body: some View {
        VStack {
            Image(systemName: "person.crop.circle.fill")
                .font(.largeTitle)
                .padding(.bottom)
            Text("User Profile")
                .font(.title)
            Text("View and edit your profile information.")
                .padding()
            // Add profile details here
            Text("Username: YourName")
            Text("Email: your.email@example.com")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.green.opacity(0.1))
        .navigationTitle("Profile")
    }
}

struct ProxyView_Previews: PreviewProvider {
    static var previews: some View {
        ProxyView()
    }
}
