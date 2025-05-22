import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            Image(systemName: "gearshape.fill")
                .font(.largeTitle)
                .padding(.bottom)
            Text("Settings")
                .font(.title)
            Text("Configure your application settings here.")
                .padding()
            // Add your settings controls here
            Toggle("Enable Feature X", isOn: .constant(true))
                .padding()
            Stepper("Value: \(Int.random(in: 1...10))", value: .constant(5), in: 1...10)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.blue.opacity(0.1))
        .navigationTitle("Settings")
    }
}
