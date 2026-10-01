import SwiftUI

// SwiftUI View struct representing the AddView for adding new expenses.
struct AddView: View {
    // Environment property wrapper to dismiss the view.
    @Environment(\.dismiss) var dismiss

    // State properties to manage the name, type, and amount of the new expense.
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0

    // Reference to the Expenses object to add the new expense.
    var expenses: Expenses

    // Array of expense types.
    let types = ["Business", "Personal"]

    var body: some View {
        // Navigation view stack to provide navigation functionality.
        NavigationStack {
            // Form view to collect input for the new expense.
            Form {
                // Text field to input the name of the expense.
                TextField("Name", text: $name)

                // Picker view to select the type of the expense.
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }

                // Text field to input the amount of the expense.
                TextField("Amount", value: $amount, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
            }
            // Set the navigation title.
            .navigationTitle("Add new expense")
            // Add a toolbar button to save the new expense.
            .toolbar {
                Button("Save") {
                    // Create a new ExpenseItem with the provided details and append it to the expenses array.
                    let item = ExpenseItem(name: name, type: type, amount: amount)
                    expenses.items.append(item)
                    // Dismiss the AddView.
                    dismiss()
                }
            }
        }
    }
}

// Preview provider for AddView.
#Preview {
    AddView(expenses: Expenses())
}
