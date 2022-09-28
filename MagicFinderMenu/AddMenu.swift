//
//  AddMenu.swift
//  MagicFinderMenu
//
//  Created by sheiy on 2022/9/27.
//

import SwiftUI
import Common


struct AddMenu: View {
    @State var name:String = ""
    @State var type:MenuType = MenuType.shell
    @State var cmd:String = ""
    
    @Environment(\.presentationMode) var mode:Binding<PresentationMode>
    
    var body: some View {
        VStack{
            TextField("菜单名称",text: $name)
                .padding(10)
                .background(Color(.systemGray))
                .cornerRadius(5)
                .disableAutocorrection(true)
            
            GroupBox(){
                DisclosureGroup("菜单类型") {
                    ForEach(0..<MenuType.allCases.count, id: \.self){ index in
                        Divider()
                            .padding(.vertical, 2)
                        HStack{
                            Group{
                                Image(systemName: "info.circle")
                                Text(MenuType.allCases[index].rawValue)
                            }
                            //                                    .foregroundColor(.gray)
                            //                                    .font(.system(.body)
                            //                                        .bold())
                            
                            //                                    Spacer(minLength: 25)
                            //
                            //                                    Text("1g")
                            //                                        .multilineTextAlignment(.trailing)
                        }
                    }
                }
            }
            
            TextField("Shell命令",text: $cmd)
                .padding(10)
                .background(Color(.systemGray))
                .cornerRadius(5)
                .disableAutocorrection(true)
            
            Button(action: {
                DBManager().addMenu(name: self.name, type: self.type, cmd: self.cmd)
                self.mode.wrappedValue.dismiss()
            }, label: {Text("确定")})
            .frame(maxWidth: .infinity,alignment: .trailing).padding(.top,10).padding(.bottom,10)
            .padding()
        }
    }
}

struct AddMenu_Previews: PreviewProvider {
    static var previews: some View {
        AddMenu()
    }
}
