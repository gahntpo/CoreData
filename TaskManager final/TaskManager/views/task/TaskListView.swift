//
//  TaskListView.swift
//  TaskManager
//
//  Created by Karin Prater on 21.08.2023.
//

import SwiftUI
import CoreData

struct TaskListView: View {
    
    let title: String
   
    @FetchRequest(fetchRequest: CDTask.fetch(), animation: .bouncy) var tasks
    
    @State private var selectedTask: CDTask? = nil
    
    @State private var inspectorIsShown: Bool = false
    @Environment(\.managedObjectContext) var context
    
    let group: CDTaskGroup?
    
    init(title: String, selection: TaskSection?, searchTerm: String) {
        self.title = title
        
        var request = CDTask.fetch()
        if searchTerm.isEmpty {
            switch selection {
                case .all:
                    request.predicate = nil
                case .done:
                    request.predicate = NSPredicate(format: "isCompleted == true")
                case .upcoming:
                    request.predicate = NSPredicate(format: "isCompleted == false")
                case .list(let group):
                    request.predicate = NSPredicate(format: "group == %@", group as CVarArg)
                case nil:
                    request.predicate = NSPredicate.none
            }
        } else {
            request.predicate = NSPredicate(format: "%K CONTAINS[cd] %@", "title_", 
                                            searchTerm as CVarArg)
        }
        
        switch selection {
            case .all, .done, .upcoming:
                group = nil
            case .list(let group):
                self.group = group
            case nil:
                group = nil
        }
        
        self._tasks = FetchRequest(fetchRequest: request, animation: .bouncy)
    }
    
    var body: some View {
        List(tasks) { task in
           TaskRow(task: task,
                   selectedTask: $selectedTask,
                   inspectorIsShown: $inspectorIsShown)
           .foregroundColor(selectedTask == task ? .accent : .gray)
        }
        .navigationTitle(title)
        .toolbar {
            ToolbarItemGroup {
                Button {
                    let task = CDTask(title: "New", dueDate: Date(), context: context)
                    task.group = group
                    PersistenceController.shared.save()
                } label: {
                    Label("Add New Task", systemImage: "plus")
                }
                
                Button {
                    inspectorIsShown.toggle()
                } label: {
                    Label("Show inspector", 
                          systemImage: "sidebar.right")
                }
            }
        }
        .inspector(isPresented: $inspectorIsShown) {
            
            if let selectedTask {
                TaskDetailView(task: selectedTask)
            } else {
                ContentUnavailableView("Please select a task", 
                                       systemImage: "circle.inset.filled")
            }
            
        }

    }
}

#Preview {
    TaskListView(title: "All", 
                 selection: .all, searchTerm: "")
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
