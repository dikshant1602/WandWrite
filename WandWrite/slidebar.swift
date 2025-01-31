import SwiftUI

struct SideBarPage: View {
    @Binding var isSidebarVisible: Bool
    @EnvironmentObject var authManager: AuthManager // Make sure the AuthManager is set up in the environment
    var sideBarWidth = UIScreen.main.bounds.size.width * 0.7
    var bgColor: Color = Color(red: 52 / 255, green: 70 / 255, blue: 182 / 255)
    
    var body: some View {
        ZStack {
            // Background overlay when sidebar is visible
            GeometryReader { _ in
                EmptyView()
            }
            .background(Color.black.opacity(0.6))
            .opacity(isSidebarVisible ? 1 : 0)
            .animation(.easeInOut.delay(0.2), value: isSidebarVisible)
            .onTapGesture {
                isSidebarVisible.toggle()
            }
            
            // Sidebar content
            content
                .zIndex(1) // Ensure sidebar is above the overlay
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    var content: some View {
        HStack(alignment: .top) {
            Spacer() // Push sidebar to the right
            
            ZStack(alignment: .top) {
                bgColor
                MenuChevron
                
                VStack(alignment: .leading, spacing: 20) {
                    userProfile
                    Divider()
                    MenuLinks(items: userActions)
                    Divider()
                    MenuLinks(items: profileActions, logoutAction: handleLogout)
                }
                .padding(.top, 80)
                .padding(.horizontal, 40)
            }
            .frame(width: sideBarWidth)
            .offset(x: isSidebarVisible ? 0 : sideBarWidth) // Sidebar slides in from the right
            .animation(.default, value: isSidebarVisible)
        }
    }
    
    var MenuChevron: some View {
        ZStack {
            Image(systemName: "chevron.left") // Correct chevron for right-side
                .foregroundColor(.white)
                .rotationEffect(isSidebarVisible ? Angle(degrees: 180) : Angle(degrees: 0))
                .offset(x: isSidebarVisible ? 4 : -8)
        }
        .offset(x: -sideBarWidth / 2, y: 80) // Position chevron correctly
        .animation(.default, value: isSidebarVisible)
    }
    
    var userProfile: some View {
        VStack(alignment: .leading) {
            HStack {
                Image("frerein")
                    .resizable()
                    .frame(width: 50, height: 50, alignment: .center)
                    .clipShape(Circle())
                    .overlay {
                        Circle().stroke(Color.white, lineWidth: 2)
                    }
                    .shadow(radius: 4)
                    .padding(.trailing, 18)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Person")
                        .foregroundColor(.white)
                        .bold()
                        .font(.title3)
                    Text(verbatim: "Apple.dev@gmail.com")
                        .foregroundColor(.white)
                        .font(.caption)
                }
            }
            .padding(.bottom, 20)
        }
    }
    
    // Handle the logout action
    private func handleLogout() {
        authManager.logOut() // This will call the logOut method from AuthManager
        isSidebarVisible = false // Hide the sidebar
    }
}

// Mock Data
var userActions: [MenuItem] = [
    MenuItem(id: 4001, icon: "person.circle.fill", text: "My Account"),
    MenuItem(id: 4002, icon: "rectangle.and.pencil.and.ellipsis", text: "New Subject"),
    MenuItem(id: 4003, icon: "newspaper.circle.fill", text: "Recent Uploads"),
]

var profileActions: [MenuItem] = [
    MenuItem(id: 4004, icon: "wrench.and.screwdriver.fill", text: "Settings"),
    MenuItem(id: 4006, icon: "iphone.and.arrow.forward", text: "Logout"),
]

// MenuItem Struct
struct MenuItem: Identifiable {
    var id: Int
    var icon: String
    var text: String
}

// Menu Links
struct MenuLinks: View {
    var items: [MenuItem]
    var logoutAction: (() -> Void)? // Optional logout action
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            ForEach(items) { item in
                if item.id == 4006 { // Check if the item is the "Logout" option
                    Button(action: {
                        logoutAction?()
                    }) {
                        HStack {
                            Image(systemName: item.icon)
                                .foregroundColor(.white)
                            Text(item.text)
                                .foregroundColor(.white)
                        }
                    }
                } else {
                    NavigationLink(destination: destinationView(for: item)) {
                        HStack {
                            Image(systemName: item.icon)
                                .foregroundColor(.white)
                            Text(item.text)
                                .foregroundColor(.white)
                        }
                    }
                }
            }
        }
        .padding(.vertical, 14)
        .padding(.leading, 8)
    }
    
    @ViewBuilder
    private func destinationView(for item: MenuItem) -> some View {
        switch item.id {
        case 4001: Text("My Account")
        case 4002: Text("New Subject")
        case 4003: Text("Recent Uploads")
        case 4004: Text("Settings")
        case 4006: Text("Logout") // You can add more logout-specific logic here
        default: Text("Page not found")
        }
    }
}

// Preview
struct SideBarPage_Previews: PreviewProvider {
    @State static var isSidebarVisible = true
    
    static var previews: some View {
        SideBarPage(isSidebarVisible: $isSidebarVisible)
            .environmentObject(AuthManager()) // Provide a mock AuthManager for testing
    }
}
