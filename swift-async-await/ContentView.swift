//
//  ContentView.swift
//  swift-async-await
//
//  Created by Guen on 28/08/2023.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ContentView: View {
    @State var users: [User] = []
    @State var errorMessage: String = ""
    @State var showError: Bool = false
    
    
    var body: some View {
        NavigationView {
            List {
                
                ForEach(users) { user in
                    Text(user.username)
                }
                
            }
            .navigationTitle("async/await")
            .refreshable {
                fetchData()
            }
            .alert(errorMessage, isPresented: $showError) {
                Button("Ok", role: .cancel) {
                    
                }
            }
        }
    }
    
    // Fetching data using old completetion
    
    // Auth
    func authUser(email: String, password: String, completion: @escaping (Result<String, AuthError>) -> ()) -> Void {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
                
            if let _ = error {
                completion(.failure(.failedToLogin))
                return
            }
            
            guard let user = result else {
                completion(.failure(.failedToLogin))
                return
            }
            
            completion(.success(user.user.uid))
            
        }
    }
    
    func fetchUserData(userID: String, completion: @escaping (Result<[User], DatabaseError>) -> ()) -> Void {
        Firestore.firestore().collection("Users").document(userID).getDocument { snap, error in
            if let _ = error {
                completion(.failure(.failed))
                return
            }
            
            guard let userData = try? snap?.data(as: User.self) else {
                completion(.failure(.failed))
                return
            }
            
            completion(.success([userData]))
        }
    }
    
    func fetchData() -> Void {
        authUser(email: "heloo@guen.dev", password: "123456789") { result in
            switch result {
            case .success(let useId):
                fetchUserData(userID: useId) { result in
                        switch result {
                        case .success(let users):
                            self.users = users
                        case .failure(let err):
                            errorMessage = err.rawValue
                            showError.toggle()
                        }
                }
                
            case .failure(let err):
                errorMessage = err.rawValue
                showError.toggle()
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

enum DatabaseError: String, Error {
    case failed = "Failed to fetch data"
}

enum AuthError: String, Error {
    case failedToLogin = "failed to login"
}

struct User: Identifiable, Codable {
    var id = UUID().uuidString
    var username: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
    }
}
