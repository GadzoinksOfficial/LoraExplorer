//
//  LoraExplorerApp.swift
//  LoraExplorer
//
//  Created by Neal Katz on 10/2/24.
//

import SwiftUI
import SwiftData
import os.log

extension os.Logger {
    static let loggingSubsystem: String = "com.gadzoinks.loraExplorer"
    static let main = Logger(subsystem: Self.loggingSubsystem, category: "MAIN")
}
extension Notification.Name {
    static let presentAbout = Notification.Name("presentAbout")
}

// These are used when the app is submited to Apple App Store
// You should remove them if forking the code for other use
let GadzoinksTermsUrl =  "https://gadzoinks.com/terms-of-service/"
let GadzoinksPrivacyUrl =  "https://www.gadzoinks.com/privacy-policy"
let pathsToScan = SafeArray()
let timerPollStack  = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

@main
struct LoraExplorerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
       WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
        .commands {
            CommandGroup(replacing: .newItem) { }
            CommandGroup(replacing: .appInfo)  {
                Button(action: {
                    NotificationCenter.default.post(name: .presentAbout, object: nil)
                    //appData.presentAbout = true
                    //appDelegate.showAboutPanel()
                }) {
                    Text("About LoraExplorer")
                }
            }
        }
    }
}
