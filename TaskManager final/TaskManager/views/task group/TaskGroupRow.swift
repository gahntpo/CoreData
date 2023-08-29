//
//  TaskGroupRow.swift
//  TaskManager
//
//  Created by Karin Prater on 22.08.2023.
//

import SwiftUI

struct TaskGroupRow: View {
    
    @ObservedObject var taskGroup: CDTaskGroup
    
    var body: some View {
        HStack {
            Image(systemName: "folder")
            TextField("New Group", text: $taskGroup.title)
        }
    }
}

#Preview {
    TaskGroupRow(taskGroup: CDTaskGroup.example)
}
