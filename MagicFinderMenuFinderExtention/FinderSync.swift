//
//  FinderSync.swift
//  MagicFinderMenuFinderExtention
//
//  Created by sheiy on 2022/9/28.
//

import Cocoa
import FinderSync
import Common

class FinderSync: FIFinderSync {
    
    var myFolderURL = URL(fileURLWithPath: "/")
    
    override init() {
        super.init()
        NSLog("FinderSync() launched from %@", Bundle.main.bundlePath as NSString)
        FIFinderSyncController.default().directoryURLs = [self.myFolderURL]
    }
    
    override func menu(for menuKind: FIMenuKind) -> NSMenu {
        NSLog("FinderSync.menu()")
        let menu = NSMenu(title: "")
        let menus = DBManager().loadMenus()
        for menuInfo in menus {
            let menuItem = NSMenuItem(title: "\(menuInfo.name)", action: #selector(menuClickAction(_:)), keyEquivalent:"");
            menuItem.tag = menuInfo.id
            menu.addItem(menuItem)
        }
        return menu
    }
    
    @IBAction func menuClickAction(_ sender: AnyObject?) {
        let target = FIFinderSyncController.default().targetedURL()
        let items = FIFinderSyncController.default().selectedItemURLs()
        
        let item = sender as! NSMenuItem
        NSLog("menuClickAction: menu item: %@, target = %@, items = ", item.title as NSString, target!.path as NSString)
        for obj in items! {
            NSLog("    %@", obj.path as NSString)
        }
        let menuInfo = DBManager().getMenuById(id:item.tag)
        if let shellMenu = menuInfo as? ShellMenuInfo {
            NSLog(self.execCmd(shellMenu.cmd))
        }
    }
    
    func execCmd(_ command: String)->String{
        NSLog("FinderSync.execCmd(command:\(command)")
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.launchPath = "/bin/zsh"
        task.standardInput = nil
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        
        return output
    }
    
}

