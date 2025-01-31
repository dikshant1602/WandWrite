//
//  HarryPotterAuthView.swift
//  WandWrite
//
//  Created by FCP35 on 24/01/25.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct HarryPotterAuthView: View {
    @State private var isAuthenticated = false
    @State private var email = ""
    @State private var password = ""
    @State private var fullName = ""
    @State private var errorMessage = ""
    @State private var isLoading = false
    @Binding var isSignIn: Bool // Passed as parameter to decide if it's a Sign Up or Log In
    @State private var fcmToken: String? = nil

    var body: some View {
        Group {
            if isAuthenticated {
                HomePage() // Replace with your main app content view
            } else {
                authenticationView
            }
        }
        .onAppear {
            checkAuthenticationState()
            fetchFCMToken()
        }
    }

    var authenticationView: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Wand Write")
                    .font(.custom("HarryPFont", size: 36))
                    .foregroundColor(.yellow)
                    .padding(.top, 16)
                
                Image("hogwarts_crest")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                
                Text(isSignIn ? "Welcome Back, Wizard!" : "Join the Wizarding World!")
                    .font(.custom("HarryPFont", size: 28))
                    .foregroundColor(.yellow)
                    .padding(.top, 16)
                
                if !isSignIn {
                    TextField("Full name (e.g., Hermione Granger)", text: $fullName)
                        .textFieldStyle(HPTextFieldStyle())
                        .padding(.horizontal)
                }
                
                TextField("Owl Post Address (Email)", text: $email)
                    .textFieldStyle(HPTextFieldStyle())
                    .padding(.horizontal)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                SecureField("Password (Keep it safe from Death Eaters)", text: $password)
                    .textFieldStyle(HPTextFieldStyle())
                    .padding(.horizontal)
                
                if errorMessage != "" {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.top, 8)
                }
                
                Button(action: {
                    isLoading = true
                    if isSignIn {
                        logInUser()
                    } else {
                        signUpUser()
                    }
                }) {
                    if isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.yellow)
                            .cornerRadius(8)
                            .padding(.horizontal)
                    } else {
                        Text(isSignIn ? "Enter the Wizarding World" : "Enroll at Hogwarts")
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.yellow)
                            .cornerRadius(8)
                            .padding(.horizontal)
                    }
                }
                .padding(.top, 16)
                
                Spacer()
                
                HStack {
                    Text(isSignIn ? "Not a wizard yet?" : "Already have a magical account?")
                        .foregroundColor(.white)
                    Button(action: {
                        withAnimation {
                            isSignIn.toggle()
                        }
                    }) {
                        Text(isSignIn ? "Sign Up" : "Log In")
                            .fontWeight(.bold)
                            .foregroundColor(.yellow)
                    }
                }
                .padding(.bottom, 16)
            }
        }
    }

    struct HPTextFieldStyle: TextFieldStyle {
        func _body(configuration: TextField<Self._Label>) -> some View {
            configuration
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.yellow, lineWidth: 1.5)
                )
                .foregroundColor(.white)
                .font(.custom("HarryPFont", size: 16))
        }
    }

    private func checkAuthenticationState() {
        if Auth.auth().currentUser != nil {
            isAuthenticated = true
        }
    }

    private func signUpUser() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            isLoading = false
            if let error = error {
                errorMessage = error.localizedDescription
            } else if let user = result?.user {
                isAuthenticated = true
                saveUserToFirestore(userID: user.uid)
            }
        }
    }

    private func logInUser() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            isLoading = false
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                isAuthenticated = true
            }
        }
    }

    private func saveUserToFirestore(userID: String) {
        let db = Firestore.firestore()
        let userDoc: [String: Any] = [
            "name": fullName,
            "isStudent": true,
            "isCR": false,
            "subList": [],
            "isApproved": false,
            "isUploading": false,
            "fcmTokens": fcmToken != nil ? [fcmToken!] : []
        ]
        
        db.collection("users").document(userID).setData(userDoc) { error in
            if let error = error {
                errorMessage = "Failed to create user document: \(error.localizedDescription)"
            }
        }
    }

    private func fetchFCMToken() {
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM token: \(error.localizedDescription)")
            } else if let token = token {
                fcmToken = token
            }
        }
    }
}
