//
//  SidebarView.swift
//  TaskManager
//
//  Created by Karin Prater on 21.08.2023.
//

import SwiftUI
import CoreData

struct SidebarView: View {
    
    @Environment(\.managedObjectContext) var context
    @FetchRequest(fetchRequest: CDTaskGroup.fetch(), animation: .bouncy)
    var taskGroups: FetchedResults<CDTaskGroup>

    @Binding var selection: TaskSection?
    
    var body: some View {
        List(selection: $selection) {
            Section("Favorites") {
                ForEach(TaskSection.allCases) { selection in
                    Label(selection.displayName,
                          systemImage: selection.iconName)
                    .tag(selection)
                }
            }
            
            Section("Your Groups") {
                ForEach(taskGroups) { group in
                    TaskGroupRow(taskGroup: group)
                    .tag(TaskSection.list(group))
                    .contextMenu {
                        Button("Delete", role: .destructive) {
                            CDTaskGroup.delete(taskGroup: group)
                        }
                    }
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            Button(action: {
                let newGroup = CDTaskGroup(title: "New", context: context)
              
            }, label: {
                Label("Add Group", systemImage: "plus.circle")
            })
            .buttonStyle(.borderless)
            .foregroundColor(.accentColor)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.thickMaterial)
            .keyboardShortcut(/*@START_MENU_TOKEN@*/KeyEquivalent("a")/*@END_MENU_TOKEN@*/, modifiers: /*@START_MENU_TOKEN@*/.command/*@END_MENU_TOKEN@*/)
        }
        
    }
}

#Preview {
    SidebarView(selection: .constant(.all))
        .listStyle(.sidebar)
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
