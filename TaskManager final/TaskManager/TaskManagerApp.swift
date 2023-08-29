//
//  TaskManagerApp.swift
//  TaskManager
//
//  Created by Karin Prater on 21.08.2023.
//

import SwiftUI

@main
struct TaskManagerApp: App {
    
    let persistentController = PersistenceController.shared
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistentController.container.viewContext)
                .onChange(of: scenePhase) { oldValue, newValue in
                    if newValue == .background {
                        persistentController.save()
                    }
                }
        }
        .commands {
            CommandMenu("Task") {
                Button("Add new Task") {
                    
                }
                .keyboardShortcut(KeyEquivalent("r"), modifiers: /*@START_MENU_TOKEN@*/.command/*@END_MENU_TOKEN@*/)
            }
            
            CommandGroup(after: .newItem) {
                Button("Add new Group") {
                    
                }
                
                Button("Save") {
                    PersistenceController.shared.save()
                }
                .keyboardShortcut("s", modifiers: .command)
            }
        }
        
        #if os(macOS)
        WindowGroup("Special window") {
            Text("special window")
                .frame(minWidth: 200, idealWidth: 300, minHeight: 200)
        }
        .defaultPosition(.leading)
        
        Settings {
            Text("Setting")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        
        MenuBarExtra("Menu") {
            Button("Do something amazing") {
                
            }
        }
        #endif
    }
}
