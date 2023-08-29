//
//  CDTask+helper.swift
//  TaskManager
//
//  Created by Karin Prater on 22.08.2023.
//

import Foundation
import CoreData

extension CDTask {
    
    var uuid: UUID {
        #if DEBUG
        uuid_!
        #else
        uuid_ ?? UUID()
        #endif
    }
    
    var title: String {
        get { title_ ?? ""  }
        set { title_ = newValue }
    }
    
    var dueDate: Date {
        get { dueDate_ ?? Date() }
        set { dueDate_ = newValue }
    }
    
    var subTasks: Set<CDTask> {
        get { (subTasks_ as? Set<CDTask>) ?? [] }
        set { subTasks_ = newValue as NSSet }
    }
    
    convenience init(title: String,
                     dueDate: Date,
                     context: NSManagedObjectContext) {
        self.init(context: context)
        self.title = title
        self.dueDate = dueDate
    }
    
    public override func awakeFromInsert() {
        self.uuid_ = UUID()
    }
    
    static func delete(task: CDTask) {
        guard let context = task.managedObjectContext else { return }
        context.delete(task)
    }
    
    static func fetch(_ predicate: NSPredicate = .all) -> NSFetchRequest<CDTask> {
        let request = CDTask.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CDTask.dueDate_, ascending: true),
                                   NSSortDescriptor(keyPath: \CDTask.title_, ascending: true)]
        request.predicate = predicate
        
        return request
    }
    
    //MARK: - Preview helpers
    
    static var example: CDTask {
        let context = PersistenceController.preview.container.viewContext
        let task = CDTask(title: "Buy Cat Food", dueDate: Date(), context: context)
        let sub1 = CDTask(title: "Subtask 1", dueDate: Date(), context: context)
        let sub2 = CDTask(title: "Subtask 2", dueDate: Date(), context: context)
        let sub3 = CDTask(title: "Subtask 3", dueDate: Date(), context: context)
        task.subTasks.formUnion([sub1, sub2, sub3])
        return task
    }
    
}

extension CDTask: Comparable {
    public static func < (lhs: CDTask, rhs: CDTask) -> Bool {
        lhs.title < rhs.title
    }
    
    
}
