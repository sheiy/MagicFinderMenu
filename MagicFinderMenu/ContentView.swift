//
//  ContentView.swift
//  MagicFinderMenu
//
//  Created by sheiy on 2022/9/27.
//

import SwiftUI
import Common

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ContentView: View {
    
    var body: some View{
        NavigationView{
            VStack {
                HStack{
                    Spacer()
                    NavigationLink( destination: AddMenu(), label: {Text("新建菜单")
                    })
                }
                MenuList()
            }.padding()
        }
    }
}

struct MenuList: View {
    @State var menus:[MenuInfo] = []
    var body: some View {
        List(self.menus){(menu) in
            VStack{
                HStack{
                    Text(menu.name)
                    Spacer()
                    Text(menu.menuType.rawValue)
                }
                if let shellMenu = menu as? ShellMenuInfo {
                    Spacer()
                    Text(shellMenu.cmd)
                }
            }
        }
        .onAppear(perform: {
            self.menus = DBManager().loadMenus()
        })
    }
}
