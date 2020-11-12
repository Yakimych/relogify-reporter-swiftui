//
//  ReporterApp.swift
//  Reporter WatchKit Extension
//
//  Created by Kyrylo Yakymenko on 2020-11-03.
//

import SwiftUI

@main
struct ReporterApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
