import Foundation

struct Todo: CustomStringConvertible, Codable {
  var id: UUID
  var title: String
  var isCompleted: Bool
  var description: String {
    return "\(isCompleted ? "✅" : "❌") \(title)"
  }
}

protocol Cache {
  func save(todos: [Todo]) -> Bool
  func load() -> [Todo]?
}

final class JSONFileManagerCache: Cache {

  var todos: [Todo]?

  func save(todos: [Todo]) -> Bool {
    let encoder: JSONEncoder = JSONEncoder()
    if let encodedData: Data = try? encoder.encode(todos) {
      let currentDirectoryPath: String = FileManager.default.currentDirectoryPath
      let fileURL: URL = URL(fileURLWithPath: currentDirectoryPath).appendingPathComponent(
        "todos.json")

      do {
        try encodedData.write(to: fileURL)
        return true
      } catch {
        print("Error saving todos: \(error)")
        return false
      }
    }
    return false
  }

  func load() -> [Todo]? {
    let currentDirectoryPath = FileManager.default.currentDirectoryPath
    let fileURL = URL(fileURLWithPath: currentDirectoryPath).appendingPathComponent("todos.json")

    if let data: Data = try? Data(contentsOf: fileURL) {
      let decoder: JSONDecoder = JSONDecoder()
      if let loadedTodos: [Todo] = try? decoder.decode([Todo].self, from: data) {
        self.todos = loadedTodos
        return loadedTodos
      }
    }
    return nil
  }

}

final class InMemoryCache: Cache {

  var todos: [Todo]?

  func save(todos: [Todo]) -> Bool {
    self.todos = todos
    return true
  }
  func load() -> [Todo]? {
    return self.todos ?? nil
  }

}

final class TodoManager {

  //deleted the two properties and used only one which is called cache and it can take any type of the two cache implementations
  var cache: Cache

  init(cache: Cache) {
    self.cache = cache
  }

  func listTodos() {
    print("\n📝 Your Todos:")
    var i: Int = 0
    if let todos: [Todo] = self.cache.load() {
      for todo: Todo in todos {
        i += 1
        print("\t", terminator: "")
        print(i, terminator: "")
        print(". ", terminator: "")
        print(todo.description)
      }
      print("\nTotal number of Todos: ", todos.count)
    } else {
      print("No todos found")
    }
  }

  func addTodo(with title: String) {
    let todo: Todo = Todo(id: UUID(), title: title, isCompleted: false)
    var todos: [Todo] = self.cache.load() ?? []
    todos.append(todo)
    _ = self.cache.save(todos: todos)
    self.listTodos()
    print("\n📌 Todo added!\n")
  }

  func toggleCompletion(forTodoAtIndex index: Int) {
    if let todos: [Todo] = self.cache.load(), index > 0 && index <= todos.count {
      var updatedTodos = todos
      updatedTodos[index - 1].isCompleted.toggle()
      _ = self.cache.save(todos: updatedTodos)
      print("\n🔁 Todo Completion status toggled!")
    } else {
      print("Invalid index")
    }
  }

  func deleteTodo(atIndex index: Int) {
    if let todos: [Todo] = self.cache.load(), index > 0 && index <= todos.count {
      var updatedTodos = todos
      updatedTodos.remove(at: index - 1)
      _ = self.cache.save(todos: updatedTodos)
      print("\n🗑️ Todo deleted!")
    } else {
      print("Invalid index")
    }
  }

  func exit(todos: [Todo]) -> Bool {
    return self.cache.save(todos: todos)
  }

}

final class App {
  enum Command: String {
    case add = "add"
    case list = "list"
    case toggle = "toggle"
    case delete = "delete"
    case exit = "exit"
  }

  var command: Command = .list
  let todosManager: TodoManager

  init() {
    // here we can change the cache implementation to the either two, as rubric requested, sorry for the misunderstanding
    self.todosManager = TodoManager(cache: InMemoryCache())
    ////self.todosManager = TodoManager(cache: JSONFileManagerCache())
  }

  func run() {
    print("Welcome To Todo CLI! 👋")
    while command != .exit {
      print("\nWhat would you like to do? (add, list, toggle, delete, exit):  ", terminator: "")
      if let input: String = readLine(), let parsedCommand: Command = Command(rawValue: input) {
        command = parsedCommand
      } else {
        print("\nInvalid input")
        continue
      }

      switch command {
      case .add:
        print("\nEnter Todo Title: ", terminator: "")
        if let input: String = readLine() {
          todosManager.addTodo(with: input)
        }
      case .list:
        todosManager.listTodos()
      case .toggle:
        todosManager.listTodos()
        print("\nEnter Todo number to toggle: ", terminator: "")
        if let input = readLine(), let index = Int(input) {
          todosManager.toggleCompletion(forTodoAtIndex: index)
        }
      case .delete:
        todosManager.listTodos()
        print("\nEnter Todo number to delete: ", terminator: "")
        if let input = readLine(), let index = Int(input) {
          todosManager.deleteTodo(atIndex: index)
        }
      case .exit:
        let isOK: Bool = todosManager.exit(todos: todosManager.cache.load() ?? [])
        if isOK {
          print("Thank you for using Todo CLI! See you next time! 👋")
        } else {
          print("Error while saving todos")
        }
      }
    }
  }
}

let app: App = App()
app.run()
