//
//  swift_async_awaitApp.swift
//  swift-async-await
//
//  Created by Guen on 28/08/2023.
//

import SwiftUI
import Firebase

@main
struct swift_async_awaitApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
