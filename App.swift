import SwiftUI

@main
struct GameHubApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var stage: Int = 1 // 1: Welcome, 2: Start, 3: Main Menu
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if stage == 1 {
                WelcomeView { stage = 2 }
            } else if stage == 2 {
                StartPromptView { stage = 3 }
            } else {
                MainHubView()
            }
        }
    }
}

// MARK: - Welcome Page
struct WelcomeView: View {
    var next: () -> Void
    var body: some View {
        VStack {
            Text("WELCOME").font(.system(size: 50, weight: .black)).foregroundColor(.white).tracking(10)
            ProgressView().tint(.blue).scaleEffect(1.5)
        }
        .onAppear { DispatchQueue.main.asyncAfter(deadline: .now() + 2) { next() } }
    }
}

// MARK: - Click to Start (PS5 Style)
struct StartPromptView: View {
    var next: () -> Void
    @State private var pulse = false
    
    var body: some View {
        ZStack {
            Image(systemName: "circle.grid.3x3.fill").resizable().opacity(0.05).ignoresSafeArea()
            VStack {
                Spacer()
                Text("CLICK TO START")
                    .font(.headline).foregroundColor(.white)
                    .opacity(pulse ? 0.3 : 1.0)
                    .onAppear { withAnimation(.easeInOut(duration: 1).repeatForever()) { pulse = true } }
                Spacer()
            }
        }
        .contentShape(Rectangle())
        .onTapGesture { next() }
    }
}

// MARK: - Main Hub (Play, Library, Cloud, Settings)
struct MainHubView: View {
    var body: some View {
        NavigationView {
            HStack(spacing: 20) {
                MenuCard(title: "PLAY GAMES", icon: "play.fill", color: .blue, destination: PlayGamesView())
                MenuCard(title: "LIBRARY", icon: "folder.fill", color: .purple, destination: LibraryView())
                MenuCard(title: "CLOUD", icon: "cloud.fill", color: .cyan, destination: CloudView())
                MenuCard(title: "SETTINGS", icon: "gearshape.fill", color: .orange, destination: SettingsView())
            }
            .padding()
            .background(Color.black)
        }
        .navigationViewStyle(.stack)
    }
}

struct MenuCard<Target: View>: View {
    var title: String; var icon: String; var color: Color; var destination: Target
    var body: some View {
        NavigationLink(destination: destination) {
            VStack {
                Image(systemName: icon).font(.largeTitle).foregroundColor(.white)
                Text(title).font(.caption).bold().foregroundColor(.white)
            }
            .frame(width: 160, height: 200)
            .background(color.opacity(0.2))
            .cornerRadius(20)
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(color, lineWidth: 2))
        }
    }
}

// MARK: - Sub Views
struct PlayGamesView: View {
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(0..<5) { _ in
                    RoundedRectangle(cornerRadius: 15).fill(Color.gray.opacity(0.3))
                        .frame(width: 250, height: 140)
                        .overlay(Text("EXE GAME RUNNING").foregroundColor(.green))
                }
            }
        }.padding().navigationTitle("Installed Games")
    }
}

struct LibraryView: View {
    var body: some View {
        VStack {
            Button("INSERT .EXE GAME") { /* File Picker logic */ }
                .padding().background(Color.blue).cornerRadius(10)
            Text("Drag and Drop ISO/EXE files here").padding()
        }.navigationTitle("Library")
    }
}

struct CloudView: View {
    var body: some View {
        List {
            Link("Xbox Cloud Gaming", destination: URL(string: "https://www.xbox.com/play")!)
            Link("NVIDIA GeForce Now", destination: URL(string: "https://play.geforcenow.com")!)
        }.navigationTitle("Cloud Services")
    }
}

struct SettingsView: View {
    var body: some View {
        Form {
            Section("PC Environment") {
                Toggle("DirectX 11 Support", isOn: .constant(true))
                Toggle("C++ Redistributable (x64)", isOn: .constant(true))
                Toggle("Vulkan Shaders", isOn: .constant(true))
            }
            Section("Performance") {
                Text("Optimization: iPhone 15 Pro Max")
                Text("Render Scale: 100%")
            }
        }.navigationTitle("Settings")
    }
}
