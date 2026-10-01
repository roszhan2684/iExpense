import SwiftUI

// Define a structure representing an expense item with properties id, name, type, and amount.
struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

// Define a class to manage expenses, conforming to the ObservableObject protocol.
@Observable
class Expenses {
    // Array to store expense items.
    var items = [ExpenseItem]() {
        didSet {
            // Encode the updated items array and save it to UserDefaults when the array changes.
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }

    // Initialize the expenses class, loading saved items from UserDefaults if available.
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }

        // If no saved items are found, initialize items as an empty array.
        items = []
    }
}

// SwiftUI View struct representing the main content view of the app.
struct ContentView: View {
    // State property to manage the expenses.
    @State private var expenses = Expenses()

    // State property to control the presentation of the AddView.
    @State private var showingAddExpense = false

    var body: some View {
        // Navigation view stack to provide navigation functionality.
        NavigationStack {
            // List view displaying the expense items.
            List {
                ForEach(expenses.items) { item in
                    // Horizontal stack to display each expense item.
                    HStack {
                        VStack(alignment: .leading) {
                            // Display the name of the expense item.
                            Text(item.name)
                                .font(.headline)

                            // Display the type of the expense item.
                            Text(item.type)
                        }

                        Spacer()

                        // Display the amount of the expense item in currency format.
                        Text(item.amount, format: .currency(code: "USD"))
                    }
                }
                // Enable deletion of expense items.
                .onDelete(perform: removeItems)
            }
            // Set the navigation title.
            .navigationTitle("iExpense")
            // Add a toolbar button to add new expenses.
            .toolbar {
                Button("Add Expense", systemImage: "plus") {
                    showingAddExpense = true
                }
            }
            // Present the AddView modally when showingAddExpense is true.
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
            }
        }
    }

    // Function to remove expense items at the specified offsets.
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

// Preview provider for ContentView.
#Preview {
    ContentView()
}
