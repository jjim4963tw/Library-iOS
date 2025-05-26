//
//  Library_iOSApp.swift
//  Library-iOS
//
//  Created by 黃佳俊 on 2022/3/30.
//

import SwiftUI

@main
struct Library_iOS: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            NavigationView {
                IndexView()
            }
        }
    }
}
