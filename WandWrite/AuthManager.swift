import Foundation
import FirebaseAuth

class AuthManager: ObservableObject {
    @Published var isAuthenticated = false // Authentication state

    init() {
        checkAuthStatusOnLaunch()
    }

    func checkAuthStatusOnLaunch() {
        // Check if the user is already logged in (e.g., via Firebase Auth)
        if let user = Auth.auth().currentUser {
            isAuthenticated = true
            print("User \(user.email ?? "Unknown") is authenticated.")
        } else {
            isAuthenticated = false
        }
    }

    func logIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] _, error in
            if let error = error {
                print("Login failed: \(error.localizedDescription)")
                self?.isAuthenticated = false
            } else {
                print("Login successful")
                self?.isAuthenticated = true
            }
        }
    }

    func logOut() {
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
            print("Logged out successfully.")
        } catch {
            print("Logout failed: \(error.localizedDescription)")
        }
    }
}
