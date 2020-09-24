//
//  ContentView.swift
//  iExpense
//
//  Created by PRABALJIT WALIA     on 23/09/20.
//

import SwiftUI

struct ExpenseItem:Identifiable, Codable{
    let id = UUID()
    let name: String
    let type:String
    let amount:Int
}
//array of expenseItem objects
// @ObservedObject asks SwiftUI to watch the object for any changes
class Expenses:ObservableObject{
    @Published var items = [ExpenseItem](){
    didSet{
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(items){
            UserDefaults.standard.set(encoded, forKey: "Items")
        }
    }
        
}
    init(){
        if let items = UserDefaults.standard.data(forKey: "Items"){
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ExpenseItem].self, from: items){
                self.items = decoded
                return
            }
        }
        self.items = []
    }
}
//challenge2
struct checkAmount:View{
    var text:String
    var amount:Double
    var body: some View {
           if amount < 10 {
               return Text(text)
                   .foregroundColor(.green)
           } else if (amount > 10 && amount < 101) {
               return Text(text)
                   .foregroundColor(.orange)
           } else {
               // amount > 100
               return Text(text)
                   .foregroundColor(.red)
           }
       }
}
struct ContentView: View {
    @ObservedObject var expenses = Expenses()
    @State private var showingAddExpense = false
    
    
    var body: some View {
        
        NavigationView{
            List{
                ForEach(expenses.items){item in
                    HStack{
                        VStack(alignment: .leading){
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                            
                        }
                        Spacer()
                        checkAmount(text: "$\(item.amount)", amount: Double(item.amount))
                        
                    }
                }
                .onDelete(perform: removeItems)
            }
            .sheet(isPresented: $showingAddExpense) {
                // show an AddView here
                AddView(expenses: self.expenses)
            }
            .navigationBarTitle("iExpense")
            .navigationBarItems(leading:EditButton(),trailing:
            Button(action:{
                self.showingAddExpense = true
                    }){
                        Image(systemName: "plus")
                            }
            )
           
            
        }
     
    }
    func removeItems(at offsets:IndexSet){
        expenses.items.remove(atOffsets: offsets)
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
