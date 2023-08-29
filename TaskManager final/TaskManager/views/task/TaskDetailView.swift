//
//  TaskDetailView.swift
//  TaskManager
//
//  Created by Karin Prater on 22.08.2023.
//

import SwiftUI

struct TaskDetailView: View {
    
    @Environment(\.managedObjectContext) var context
    @ObservedObject var task: CDTask
    
    var body: some View {
        List {
            Text(task.title)
                .font(.title3)
                .bold()
            
            Toggle(task.isCompleted ? "Completed" : "Open",
                   isOn: $task.isCompleted)
            
            DatePicker("Due Date", selection: $task.dueDate)
            
            Divider()
            
            Section("Sub Tasks") {
                ForEach(task.subTasks.sorted()) { subtask in
                   TaskRow(task: subtask,
                           selectedTask: .constant(nil),
                           inspectorIsShown: .constant(false),
                           showMoreButton: false)
                   .listRowInsets(.init(top: 5, leading: 20, bottom: 5, trailing: 10))
                }
                
                Button(action: {
                    let subTask = CDTask(title: "", dueDate: Date(), context: context)
                    subTask.parentTask = task
                    
                }, label: {
                    Label("New Sub Task", systemImage: "plus.circle")
                })
                .buttonStyle(.borderless)
                .foregroundColor(.highlight)
                .listRowInsets(.init(top: 15, leading: 20, bottom: 5, trailing: 10))
            }
        }
        .listStyle(.sidebar)
    }
}

#Preview {
    TaskDetailView(task: CDTask.example)
}
