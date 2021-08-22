//
//  ListVC.swift
//  Chapter07-CoreData
//
//  Created by bigzero on 2021/08/21.
//

import UIKit
import CoreData

class ListVC : UITableViewController {

    lazy var list: [NSManagedObject] = {
        self.fetch()
    }()

    override func viewDidLoad() {
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add(_:)))
        navigationItem.rightBarButtonItem = addBtn
    }

    func fetch() -> [NSManagedObject] {
        //
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Board")

        let sort = NSSortDescriptor(key: "regdate", ascending: false)
        fetchRequest.sortDescriptors = [sort]

        let result =  try! context.fetch(fetchRequest)
        return result
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list.count
    }

    override func tableView(_ tv: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let record = list[indexPath.row]
        let title = record.value(forKey: "title") as? String
        let contents = record.value(forKey: "contents") as? String

        let cell = tv.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = contents

        return cell
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
         .delete
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let object = list[indexPath.row]

        if delete(object: object) {
            list.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = list[indexPath.row]
        let title = object.value(forKey: "title") as? String
        let contents = object.value(forKey: "contents") as? String

        let alert = UIAlertController(title: "Editing", message: nil, preferredStyle: .alert)

        alert.addTextField {$0.text = title}
        alert.addTextField {$0.text = contents}

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Save", style: .default) {(_) in
            guard let title = alert.textFields?.first?.text, let contents = alert.textFields?.last?.text else {
                return
            }

            if self.edit(object: object, title: title, contents: contents) == true {
//                self.tableView.reloadData()
                let cell = self.tableView.cellForRow(at: indexPath)
                cell?.textLabel?.text = title
                cell?.detailTextLabel?.text = contents

                let firstIndexPath = IndexPath(item: 0, section: 0)
                self.tableView.moveRow(at: indexPath, to: firstIndexPath)
            }
        })
        present(alert, animated: false)
    }

    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let object = list[indexPath.row]
        let uvc = storyboard?.instantiateViewController(withIdentifier: "LogVC") as! LogVC
        uvc.board = object as? BoardMO
        show(uvc, sender: self)
    }

    func save(title: String, contents: String) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let object = NSEntityDescription.insertNewObject(forEntityName: "Board", into: context)
        object.setValue(title, forKey: "title")
        object.setValue(contents, forKey: "contents")
        object.setValue(Date(), forKey: "regdate")

        // 3-1. log 관리객체 생성 및 어트리뷰트에 값 대입
        let logObject = NSEntityDescription.insertNewObject(forEntityName: "Log", into: context) as! LogMO
        logObject.regdate = Date()
        logObject.type = LogType.create.rawValue
        // 3-2. 게시글 객체의 logs 속성에 새로 생성된 로그 객체 추가
        (object as! BoardMO).addToLogs(logObject)

        do {
            try context.save()
            list.insert(object, at: 0)
            return true
        } catch let error as NSError {
            NSLog("save error : \(error.localizedDescription)")
            context.rollback()
            return false
        }
    }

    @objc func add(_ sender: Any) {
        let alert = UIAlertController(title: "게시글등록", message: nil, preferredStyle: .alert)
        alert.addTextField {$0.placeholder = "제목"}
        alert.addTextField {$0.placeholder = "내용"}

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Save", style: .default) {(_) in
           guard let title = alert.textFields?.first?.text, let contents = alert.textFields?.last?.text else {
               return
            }
            // Save value and if SUCCESS , table reload
           if self.save(title: title, contents: contents) == true {
               self.tableView.reloadData()
           }
        })
        present(alert, animated: false)
    }


    func delete(object: NSManagedObject) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        context.delete(object)

        do {
            try context.save()
            return true
        } catch {
            context.rollback()
            return false
        }
    }

    func edit(object: NSManagedObject, title: String, contents: String) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        object.setValue(title, forKey: "title")
        object.setValue(contents, forKey: "contents")
        object.setValue(Date(), forKey: "regdate")

        // 3-1. log 관리객체 생성 및 어트리뷰트에 값 대입
        let logObject = NSEntityDescription.insertNewObject(forEntityName: "Log", into: context) as! LogMO
        logObject.regdate = Date()
        logObject.type = LogType.edit.rawValue
        // 3-2. 게시글 객체의 logs 속성에 새로 생성된 로그 객체 추가
        (object as! BoardMO).addToLogs(logObject)

        do {
            try context.save()
            list = fetch()
            return true
        } catch {
            context.rollback()
            return false
        }

    }

}
