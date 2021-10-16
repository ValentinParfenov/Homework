
import Foundation
import UIKit

class ToDoViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let realmManager = RealmManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        realmManager.items = realmManager.realm.objects(TasksList.self)
    }
    
    @IBAction func addButton () {
        addNewTask()
    }

    func addNewTask() {

        let alert = UIAlertController(title: "Добавить задачу", message: "Пожалуйста заполните поле", preferredStyle: .alert)
        var alertTextField: UITextField!
            alert.addTextField { textField in
                alertTextField = textField
                textField.placeholder = "Новая задача"
        }

        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { action in
            guard let taskTitle = alertTextField.text, !taskTitle.isEmpty else { return }
            self.realmManager.addTask(taskTitle)
            self.tableView.insertRows(at: [IndexPath.init(row: self.realmManager.items.count-1, section: 0)], with: .middle)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .destructive, handler: nil)

        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }
}

extension ToDoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if realmManager.items.count != 0 {
            return realmManager.items.count
        }
        return realmManager.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = realmManager.items[indexPath.row]
        cell.textLabel?.text = item.task
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            realmManager.deleteTask(tableView, forRowAt: indexPath)
        }
    }
}
