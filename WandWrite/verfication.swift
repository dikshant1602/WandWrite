import SwiftUI

// Mock Data
struct StudentRequest: Identifiable {
    var id = UUID()
    var studentName: String
    var requestDescription: String
    var status: RequestStatus
    
    enum RequestStatus {
        case pending
        case approved
        case denied
    }
}

class RequestViewModel: ObservableObject {
    @Published var requests = [StudentRequest]()
    
    // Simulate fetching data
    func fetchData() {
        // Simulating a delay as if data was being fetched from a server
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Mock data
            self.requests = [
                StudentRequest(studentName: "John Doe", requestDescription: "Request to join the class", status: .pending),
                StudentRequest(studentName: "Jane Smith", requestDescription: "Request to change section", status: .pending),
                StudentRequest(studentName: "Sam Brown", requestDescription: "Request for a late submission", status: .pending)
            ]
        }
    }
    
    // Approve the request
    func approveRequest(for request: inout StudentRequest) {
        if request.status == .pending {
            request.status = .approved
        }
    }
    
    // Deny the request
    func denyRequest(for request: inout StudentRequest) {
        if request.status == .pending {
            request.status = .denied
        }
    }
}

struct RequestRow: View {
    @Binding var request: StudentRequest
    var approveAction: () -> Void
    var denyAction: () -> Void
    
    var body: some View {
        HStack {
            // Student name and description
            VStack(alignment: .leading) {
                Text(request.studentName)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(request.requestDescription)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()

            // Buttons (Approve and Deny)
            VStack {
                Button(action: approveAction) {
                    Text("Approve")
                        .foregroundColor(.white)
                        .padding(6)
                        .frame(minWidth: 80)
                        .background(request.status == .pending ? Color.green : Color.gray)
                        .cornerRadius(8)
                        .disabled(request.status != .pending)
                }

                Button(action: denyAction) {
                    Text("Deny")
                        .foregroundColor(.white)
                        .padding(6)
                        .frame(minWidth: 80)
                        .background(request.status == .pending ? Color.red : Color.gray)
                        .cornerRadius(8)
                        .disabled(request.status != .pending)
                }
            }
            .padding(.leading, 8)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 5)
        .padding(.horizontal)
        
        // Display the current status after action
        if request.status != .pending {
            Text("Status: \(request.status == .approved ? "Request Approved" : "Request Denied")")
                .fontWeight(.bold)
                .foregroundColor(request.status == .approved ? .green : .red)
                .padding(5)
                .background(request.status == .approved ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                .cornerRadius(10)
                .padding(.top, 10)
        }
    }
}

struct Verification: View {
    @StateObject private var viewModel = RequestViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Student Requests")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 30)
                    .padding(.bottom, 20)
                    .foregroundColor(.primary)

                // List of student requests
                List {
                    ForEach($viewModel.requests) { $request in
                        RequestRow(
                            request: $request,
                            approveAction: {
                                // Approve Action
                                viewModel.approveRequest(for: &request)
                            },
                            denyAction: {
                                // Deny Action
                                viewModel.denyRequest(for: &request)
                            }
                        )
                    }
                }
                .listStyle(PlainListStyle())
                
                Spacer() // Ensures the Upload button stays at the bottom
                
                // Upload Button
                Button(action: {
                    // Action for uploading documents
                    print("Upload button tapped!")
                }) {
                    Text("Upload Document")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                }
            }
            .onAppear {
                viewModel.fetchData() // Simulate fetching data when the view appears
            }
            .navigationBarTitle("Requests", displayMode: .inline)
            .background(Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all))
        }
    }
}

struct Verification_Previews: PreviewProvider {
    static var previews: some View {
        Verification()
            .preferredColorScheme(.light)
    }
}
