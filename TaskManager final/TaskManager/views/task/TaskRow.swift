//
//  TaskRow.swift
//  TaskManager
//
//  Created by Karin Prater on 22.08.2023.
//

import SwiftUI

struct TaskRow: View {
    
    @ObservedObject var task: CDTask
    @Binding var selectedTask: CDTask?
    @Binding var inspectorIsShown: Bool
    
    let showMoreButton: Bool
    
    init(task: CDTask,
         selectedTask: Binding<CDTask?>,
         inspectorIsShown: Binding<Bool>,
         showMoreButton: Bool = true) {
        self.task = task
        self._selectedTask = selectedTask
        self._inspectorIsShown = inspectorIsShown
        self.showMoreButton = showMoreButton
    }
    
    var body: some View {
        HStack {
            Image(systemName: task.isCompleted ? "largecircle.fill.circle" : "circle")
                .onTapGesture {
                    task.isCompleted.toggle()
                }
            
            TextField("New Task", text: $task.title)
                .textFieldStyle(.plain)
            
            if showMoreButton {
                Button(action: {
                    inspectorIsShown = true
                    selectedTask = task
                }, label: {
                    Text("More")
                })
            }
        }
    }
}


#Preview {
    TaskRow(task: CDTask.example,
            selectedTask: .constant(nil),
            inspectorIsShown: .constant(false))
        .padding()
}
