import SwiftUI

struct WandwriteWelcomeView: View {
    @State private var isSignIn = false // State to manage Sign In or Sign Up
    @State private var isNavigating = false // State to trigger navigation

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea() // Magical dark background
                
                VStack {
                    Spacer()
                    
                    // App Icon
                    Image("hogwarts_crest") // Replace with your image asset
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                    
                    // Welcome Text
                    Text("Wandwrite")
                        .font(.custom("HarryPFont", size: 36)) // Use Harry Potter font
                        .foregroundColor(.yellow)
                    
                    Text("Let's get started!")
                        .font(.custom("HarryPFont", size: 28))
                        .foregroundColor(.white)
                        .padding(.top, 8)
                    
                    Spacer()
                    
                    // Sign Up Button
                    Button(action: {
                        isSignIn = false
                        isNavigating = true
                    }) {
                        Text("Sign Up")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.yellow)
                            .cornerRadius(8)
                            .padding(.horizontal)
                    }
                    .padding(.bottom, 16)
                    
                    // Already have an account section
                    HStack {
                        Text("Already have an account?")
                            .foregroundColor(.white)
                        
                        Button(action: {
                            isSignIn = true
                            isNavigating = true
                        }) {
                            Text("Log In")
                                .fontWeight(.bold)
                                .foregroundColor(.yellow)
                        }
                    }
                    .padding(.bottom, 32)
                    
                    // Hidden NavigationLink to redirect
                    NavigationLink(
                        destination: HarryPotterAuthView(isSignIn: $isSignIn),
                        isActive: $isNavigating,
                        label: { EmptyView() }
                    )
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct WandwriteWelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WandwriteWelcomeView()
    }
}

