
import Foundation
import UIKit
import CoreData

class CoreDataToDo: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    @IBAction func addButtonCore() {
        addNewTask()
    }
    
    @IBAction func refreshTableView() {
        deleteTask()
    }
    
    var tasks = [Tasks]()
    
    func saveTask (withTitle title: String) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Tasks", in: context) else { return }
        
        let taskObject = Tasks(entity: entity, insertInto: context)
        taskObject.title = title
        
        do {
            try context.save()
            tasks.append(taskObject)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func deleteTask() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Tasks> = Tasks.fetchRequest()
        if let tasks = try? context.fetch(fetchRequest) {
            for task in tasks {
                context.delete(task)
                tableView.reloadData()
            }
        }
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Tasks> = Tasks.fetchRequest()
        
        do {
            tasks = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
            }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func addNewTask() {

        let alert = UIAlertController(title: "Добавить задачу", message: "Пожалуйста заполните поле", preferredStyle: .alert)
        var alertTextField: UITextField!
            alert.addTextField { textField in
                alertTextField = textField
                textField.placeholder = "Новая задача"
        }

        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { action in
            guard let text = alertTextField.text , !text.isEmpty else { return }

            let tf = alert.textFields?.first
            if let newTask  = tf?.text {
                self.saveTask(withTitle: newTask)
                self.tableView.reloadData()
            }
        }

        let cancelAction = UIAlertAction(title: "Отмена", style: .destructive, handler: nil)

        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }
}


extension CoreDataToDo: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tasks.count != 0 {
            return tasks.count
        }
        return tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coreCell", for: indexPath)
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.title
        return cell
    }
}
