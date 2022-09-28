//
//  DBManager.swift
//  MagicFinderMenu
//
//  Created by sheiy on 2022/9/27.
//

import Foundation
import SQLite

public class DBManager {
    private var connection:Connection!
    private var menus:Table!
    
    private var id:Expression<Int>!
    private var name:Expression<String>!
    private var type: Expression<String>!
    private var cmd:Expression<String>!
    private var createdAt : Expression<Date>!
    
    public init() {
        do {
            let sharedContainerPath:String = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "E8PMV7B653.MagicFinderMenu")!.path
            let dbFilePath = "\(sharedContainerPath)/db.sqlite3"
            NSLog("\(dbFilePath)")
            self.connection = try Connection(dbFilePath)
            self.menus = Table("menus")
            self.createdAt = Expression<Date>("createdAt")
            self.id = Expression<Int>("id")
            self.name = Expression<String>("name")
            self.type = Expression<String>("type")
            self.cmd = Expression<String>("cmd")
            
            try self.connection.run(self.menus.create(ifNotExists: true){
                (t) in t.column(self.name, unique: true)
                t.column(self.id, primaryKey: true)
                t.column(self.type)
                t.column(self.cmd)
                t.column(self.createdAt)
            })
        }catch{
            NSLog("DBManager.init() error: %@",error.localizedDescription)
        }
    }
    
    public func addMenu(name:String,type:MenuType,cmd:String) {
        if(name.isEmpty||cmd.isEmpty){
            return
        }
        NSLog("DBManager.addMenu(name:%@,type:%@,cmd:%@)",name,type.rawValue,cmd)
        do {
            try self.connection.run(self.menus.insert(self.name<-name,self.type<-type.rawValue,self.cmd<-cmd,self.createdAt<-Date()))
        }catch{
            NSLog("DBManager.addMenu(name:%@,type:%@,cmd:%@) error: %@",name,type.rawValue,cmd,error.localizedDescription)
        }
    }
    
    public func getMenuById(id:Int)-> MenuInfo? {
        var menuInfo:MenuInfo?
        do {
            let menu = try self.connection.prepare(self.menus.filter(self.id == id))
            try menu.forEach({(rowValue) in
                let id:Int = try rowValue.get(self.id)
                let name:String  = try rowValue.get(self.name)
                let type:MenuType = MenuType(rawValue: try rowValue.get(self.type))!
              
                switch type {
                case MenuType.shell :
                    let cmd:String = try rowValue.get(self.cmd)
                    menuInfo = ShellMenuInfo(id:id, name:name, menuType: type, cmd: cmd)
                }
            })
        }catch{
            NSLog("DBManager.getMenuById(id:\(id) error:\(error.localizedDescription)")
        }
        return menuInfo
    }
    
    public func loadMenus()->[MenuInfo] {
        NSLog("DBManager.loadMenus()")
        var menus :[MenuInfo] = []
        self.menus = self.menus.order(self.createdAt.asc)
        do {
            let dbDate = try self.connection.prepare(self.menus)
            for menu in dbDate {
                let id:Int = menu[self.id]
                let name:String  = menu[self.name]
                let type:MenuType = MenuType(rawValue: menu[self.type])!
                switch type {
                case MenuType.shell :
                    let cmd:String = menu[self.cmd]
                    menus.append(ShellMenuInfo(id:id, name:name, menuType: type, cmd: cmd))
                }
            }
        }catch{
            NSLog("DBManager.loadMenus() error: %@",error.localizedDescription)
        }
        return menus;
    }
}
