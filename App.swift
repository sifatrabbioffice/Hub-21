import SwiftUI

@main
struct GameHubApp: App {
    var body: some Scene {
        WindowGroup {
            MainContainer()
        }
    }
}

struct MainContainer: View {
    @State private var stage = "welcome" // welcome, main, engine
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if stage == "welcome" {
                WelcomeScreen { stage = "main" }
            } else if stage == "main" {
                DashboardView()
            }
        }
    }
}

// --- ১. ওয়েলকাম পেজ ---
struct WelcomeScreen: View {
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            ZStack {
                LinearGradient(colors: [Color(white: 0.1), .blue.opacity(0.3)], startPoint: .top, endPoint: .bottom)
                VStack {
                    Spacer()
                    Text("GAMEHUB ULTRA")
                        .font(.system(size: 60, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .italic()
                    Text("Tap Anywhere to Start")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .opacity(0.8)
                    Spacer()
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// --- ২. ড্যাশবোর্ড (PS5 স্টাইল) ---
struct DashboardView: View {
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Text("SYSTEM STATUS: ONLINE").font(.caption).foregroundColor(.green)
                    Spacer()
                    Text("15 PRO MAX - JIT ENABLED").font(.caption).foregroundColor(.gray)
                }.padding(.horizontal)

                Text("Explorer").font(.title).bold().foregroundColor(.white).padding(.leading)
                
                LazyVGrid(columns: columns, spacing: 20) {
                    MenuCard(title: "PLAY GAMES", icon: "play.circle.fill", color: .blue)
                    MenuCard(title: "LIBRARY", icon: "folder.fill", color: .purple)
                    MenuCard(title: "CLOUD GAMING", icon: "cloud.fill", color: .cyan)
                    MenuCard(title: "SETTINGS", icon: "gearshape.fill", color: .gray)
                }
                .padding()
            }
        }
    }
}

struct MenuCard: View {
    var title: String
    var icon: String
    var color: Color
    
    var body: some View {
        VStack {
            Image(systemName: icon).font(.largeTitle).foregroundColor(.white)
            Text(title).font(.headline).foregroundColor(.white)
        }
        .frame(maxWidth: .infinity).frame(height: 120)
        .background(color.opacity(0.2))
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(color, lineWidth: 2))
    }
}
