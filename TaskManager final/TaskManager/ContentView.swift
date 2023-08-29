//
//  ContentView.swift
//  TaskManager
//
//  Created by Karin Prater on 21.08.2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selection: TaskSection? = TaskSection.initialValue
    @State private var searchTerm: String = ""
    
    var body: some View {
        NavigationSplitView {
            SidebarView(selection: $selection)
                .navigationTitle("Your Tasks")
        } detail: {
            TaskListView(title: "All",
                         selection: selection,
                         searchTerm: searchTerm)
        }
        .searchable(text: $searchTerm)
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
