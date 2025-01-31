import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct HomePage: View {
    
    @State private var isSideBarOpened = false
    @State private var searchText = "" // State variable for search input
    
    @State private var isStudent: Bool? = false // State to hold the 'isStudent' field value
    @State private var isAuthenticated = false // Track user authentication state
    @State private var redirectToDemoPage = false // Flag to trigger redirection to DemoPage
    
    // List of subjects
    let subjects = ["C", "C++", "Java", "Python", "Swift", "Kotlin", "JavaScript", "HTML", "CSS", "Ruby"]
    
    func fetchUserData() {
        guard let user = Auth.auth().currentUser else {
            isAuthenticated = false
            print("No authenticated user.")
            return
        }

        // Disable Firestore cache temporarily
        let db = Firestore.firestore()
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true // This is what disables the Firestore cache

        db.settings = settings  // Apply the settings to Firestore

        let userRef = db.collection("users").document(user.uid) // Assuming the users are stored under 'users' collection

        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let isStudentValue = document.data()?["isStudent"] as? Bool {
                    print("isStudent value fetched (Bool): \(isStudentValue)")
                    self.isStudent = !isStudentValue
                    self.isAuthenticated = true
                    if isStudentValue {
                        print("isStudent is true, redirecting to Demo Page.")
                        self.redirectToDemoPage = true
                        print("\(redirectToDemoPage)")
                    } else {
                        print("isStudent is false, showing the sidebar.")
                        self.redirectToDemoPage = false
                    }
                } else {
                    self.isStudent = true
                    self.isAuthenticated = true
                    print("No 'isStudent' field, defaulting to false.")
                    self.redirectToDemoPage = false
                }
            } else {
                print("Error fetching document: \(error?.localizedDescription ?? "Unknown error")")
                self.isAuthenticated = false
            }
        }
    }



    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    // Search Bar
                    HStack {
                        TextField("Search...", text: $searchText)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .padding(.horizontal)
                            .shadow(radius: 2)
                        
                        Button(action: {
                            // Action for search button (if needed)
                        }) {
                            Image(systemName: "magnifyingglass")
                                .padding(10)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .shadow(radius: 2)
                        }
                        .padding(.trailing)
                    }
                    .padding(.top)
                    
                    // Subject List
                    List {
                        ForEach(subjects.filter { searchText.isEmpty || $0.localizedCaseInsensitiveContains(searchText) }, id: \.self) { subject in
                            Text(subject)
                                .font(.headline)
                                .padding(.vertical, 8)
                                .listRowBackground(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                    }
                    .listStyle(.inset)
                }
                .navigationBarItems(
                    leading: Group {
                        if isStudent == true {
                            Button(action: {
                                isSideBarOpened.toggle()
                            }) {
                                Label("Toggle SideBar", systemImage: "line.3.horizontal.circle.fill")
                                    .labelStyle(.iconOnly)
                                    .foregroundColor(.blue)
                            }
                        } else {
                            NavigationLink(destination: Verification()) {
                                Label("Navigate to Demo Page", systemImage: "line.3.horizontal.circle.fill")
                                    .labelStyle(.iconOnly)
                                    .foregroundColor(.blue)
                            }
                        }
                    },
                    
                    trailing: EmptyView() // You can put trailing logic here if needed
                )

            }
            .onAppear {
                fetchUserData() // Fetch user data on page load
            }
            
            // Sidebar overlay with background dimming and tap gesture
            if isSideBarOpened {
                Color.black.opacity(0.4) // Dimming background
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            isSideBarOpened.toggle() // Close sidebar when tapping outside
                        }
                    }
                    .transition(.opacity)
            }
            
            // Sidebar with animation
            if isSideBarOpened {
                SideBarPage(isSidebarVisible: $isSideBarOpened)
                    .animation(.easeInOut, value: isSideBarOpened)
                    .transition(.move(edge: .trailing)) // Exit transition for sliding out
            }
        }
        .animation(.easeInOut, value: isSideBarOpened) // Animation for state changes
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
