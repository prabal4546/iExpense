//
//  AddView.swift
//  iExpense
//
//  Created by PRABALJIT WALIA     on 24/09/20.
//

import SwiftUI

struct AddView: View {
    //storing the view's presentation mode
    @Environment(\.presentationMode) var presentationMode
    @State private var name =  ""
    @State private var type = "Personal"
    @State private var amount = ""
    static let types = ["Business", "Personal"]
    @ObservedObject var expenses: Expenses
    var body: some View {
        NavigationView{
            Form{
                TextField("Name", text: $name)
                Picker("Type", selection:$type){
                    ForEach(AddView.types, id: \.self){
                        Text($0)
                    }
                }
                TextField("Amount",text: $amount)
                    .keyboardType(.numberPad)

            }
            .navigationBarTitle("Add new expense")
            .navigationBarItems(trailing: Button("Save"){
                if let actualAmount = Int(self.amount)
                {
                    let item = ExpenseItem(name: self.name, type: self.type, amount: actualAmount)
                    self.expenses.items.append(item)
                    self.presentationMode.wrappedValue.dismiss()
                }
            })
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
