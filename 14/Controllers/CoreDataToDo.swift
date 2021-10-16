
import Foundation
import UIKit

class CoreDataToDo: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let coreData = SaveDataCoreData()
    
    @IBAction func addButtonCore() {
        addNewTask()
    }
    
    @IBAction func refreshTableView() {
        coreData.deleteTaskFromCache(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        coreData.readTaskFromCache()
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
                self.coreData.saveTask(withTitle: newTask)
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
        if coreData.tasks.count != 0 {
            return coreData.tasks.count
        }
        return coreData.tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coreCell", for: indexPath)
        let task = coreData.tasks[indexPath.row]
        cell.textLabel?.text = task.title
        return cell
    }
}
