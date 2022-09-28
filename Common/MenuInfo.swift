//
//  MenuInfo.swift
//  MagicFinderMenu
//
//  Created by sheiy on 2022/9/27.
//

import Foundation


public class MenuInfo : Identifiable {
    public var id:Int;
    public var name:String;
    public var menuType:MenuType;
    
    public init(id:Int,name: String, menuType: MenuType) {
        self.id = id
        self.name = name
        self.menuType = menuType
    }
    
}


public class ShellMenuInfo : MenuInfo{
    public var cmd:String;
    public init(id:Int,name: String, menuType: MenuType ,cmd: String) {
        self.cmd = cmd
        super.init(id:id,name: name, menuType: menuType)
    }
}

