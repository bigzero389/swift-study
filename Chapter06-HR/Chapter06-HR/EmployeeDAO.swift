//
//  EmployeeDAO.swift
//  EmployeeDAO
//
//  Created by bigzero on 2021/08/15.
//

import Foundation

enum EmpStateType: Int {
    case ING = 0, STOP, OUT
    
    func desc() -> String {
        switch self {
        case .ING:
            return "working"
        case .STOP:
            return "leave of absence"
        case .OUT:
            return "resignation"
        }
    }
}

struct EmployeeVO {
    var empCd = 0
    var empName = ""
    var joinDate = ""
    var stateCd = EmpStateType.ING
    var departCd = 0
    var departTitle = ""
}

class EmployeeDAO {
    lazy var fmdb : FMDatabase! = {
        let fileMgr = FileManager.default
        
        let docPath = fileMgr.urls(for: .documentDirectory, in: .userDomainMask).first
        let dbPath = docPath!.appendingPathComponent("hr.sqlite").path
        
        if fileMgr.fileExists(atPath: dbPath) == false {
            let dbSource = Bundle.main.path(forResource: "hr", ofType: "sqlite")
            try! fileMgr.copyItem(atPath: dbSource!, toPath: dbPath)
        }
        
        let db = FMDatabase(path: dbPath)
        return db
    }()
    
    init() {
        self.fmdb.open()
    }
    deinit {
        self.fmdb.close()
    }
    
    func find() -> [EmployeeVO] {
        var employeeList = [EmployeeVO]()
        
        do {
            let sql = """
                SELECT emp_cd, emp_name, join_date, state_cd, department.depart_title
                FROM employee
                JOIN department On department.depart_cd = employee.depart_cd
                ORDER BY employee.depart_cd ASC
            """
            
            let rs = try self.fmdb.executeQuery(sql, values: nil)
            
            while rs.next() {
                var record = EmployeeVO()
                record.empCd = Int(rs.int(forColumn: "emp_cd"))
                record.empName = rs.string(forColumn: "emp_name")!
                record.joinDate = rs.string(forColumn: "join_date")!
                record.departTitle = rs.string(forColumn: "depart_title")!
                record.stateCd = EmpStateType(rawValue: Int(rs.int(forColumn: "state_cd")))!
                
                employeeList.append(record)
            }
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        return employeeList
    }
    
    func find(departCd: Int) -> [EmployeeVO] {
        var employeeList = [EmployeeVO]()
        
        do {
            let condition = departCd == 0 ? "" : "WHERE A.depart_cd = \(departCd)"
            let sql = """
                SELECT emp_cd, emp_name, join_date, state_cd, B.depart_title
                FROM employee A
                JOIN department B On A.depart_cd = B.depart_cd
                \(condition)
            """
            let rs = try self.fmdb.executeQuery(sql, values: nil)
            
            while rs.next() {
                var record = EmployeeVO()
                record.empCd = Int(rs.int(forColumn: "emp_cd"))
                record.empName = rs.string(forColumn: "emp_name")!
                record.joinDate = rs.string(forColumn: "join_date")!
                record.departTitle = rs.string(forColumn: "depart_title")!
                record.stateCd = EmpStateType(rawValue: Int(rs.int(forColumn: "state_cd")))!
                
                employeeList.append(record)
            }
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        return employeeList
    }
    
    func get(empCd: Int) -> EmployeeVO? {
        // 1. execute SQL
        let sql = """
            SELECT emp_cd, emp_name, join_date, state_cd, department.depart_title
            FROM employee A
            JOIN department B On A.depart_cd = B.depart_cd
            WHERE A.emp_cd = ?
        """
        
        let rs = self.fmdb.executeQuery(sql, withArgumentsIn: [empCd])
        
        if let _rs = rs {
            _rs.next()
            var record = EmployeeVO()
            record.empCd = Int(_rs.int(forColumn: "emp_cd"))
            record.empName = _rs.string(forColumn: "emp_name")!
            record.joinDate = _rs.string(forColumn: "join_date")!
            record.departTitle = _rs.string(forColumn: "depart_title")!
            record.stateCd = EmpStateType(rawValue: Int(_rs.int(forColumn: "state_cd")))!
           
            return record
        } else {
            return nil
        }
    }
    
    func create(param: EmployeeVO) -> Bool {
        do {
            let sql = "INSERT INTO employee (emp_name, join_date, state_cd, depart_cd) VALUES( ?, ?, ?, ?)"
            var params = [Any]()
            params.append(param.empName)
            params.append(param.joinDate)
            params.append(param.stateCd.rawValue)
            params.append(param.departCd)
            try self.fmdb.executeUpdate(sql, values: params)
            return true
        } catch let error as NSError {
            print("Insert Error: \(error.localizedDescription)")
            return false
        }
    }
    
    func remove(empCd: Int) -> Bool {
        do {
            let sql = "DELETE FROM employee WHERE emp_cd = ?"
            try self.fmdb.executeUpdate(sql, values: [empCd])
            return false
        } catch let error as NSError {
            print("DELETE Error : \(error.localizedDescription)")
            return false
        }
    }
    
    func editState(empCd: Int, stateCd: EmpStateType) -> Bool {
        do {
            let sql = " UPDATE Employee SET state_cd = ? WHERE emp_cd = ? "
            var params = [Any]()
            params.append(stateCd.rawValue)
            params.append(empCd)
            
            try self.fmdb.executeUpdate(sql, values: params)
            return true
        } catch let error as NSError {
            print("UPDATE Error : \(error.localizedDescription)")
            return false
        }
    }
    
    
}
