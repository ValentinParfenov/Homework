
import Foundation
import RealmSwift

class TasksList: Object {
    @objc dynamic var task = ""
    @objc dynamic var completed = false
}

class ToDoViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let realm = try! Realm()
    var data = [TasksList]()
    var items: Results<TasksList>!

    override func viewDidLoad() {
        super.viewDidLoad()
        items = realm.objects(TasksList.self)
    }
    
    @IBAction func addButton (){
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
            guard let text = alertTextField.text , !text.isEmpty else { return }

            let task = TasksList()
            task.task = text

            try! self.realm.write {
                self.realm.add(task)
                print(task)
            }
            self.tableView.insertRows(at: [IndexPath.init(row: self.items.count-1, section: 0)], with: .middle)
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
        if items.count != 0 {
            return items.count
        }
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.task
        return cell
    }
    

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")

            try! self.realm.write {
                self.realm.delete(self.items[indexPath.row])
                tableView.reloadData()
            }
        }
    }
}



