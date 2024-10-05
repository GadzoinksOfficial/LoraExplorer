//
//  SafeArray.swift
//  
//
//  Created by Neal Katz on 4/3/24.
//

import Foundation

extension NSLock {
    @discardableResult
    func with<T>(_ block: () throws -> T) rethrows -> T {
        //os.Logger.misc.info("LOCK")
        lock()
        defer {
            //os.Logger.misc.info("PRE UNLOCK")
            unlock()
            //os.Logger.misc.info("UNLOCK")
        }
        return try block()
    }
}

class SafeArray : ObservableObject , Sequence {
    @Published var items = [String]()
    let lock = NSLock()
    var count:Int {
        return lock.with  {
            return items.count
        }
    }
    subscript(index:Int) ->  String {
        set(gzitem) {
            lock.with  {
                items[index] = gzitem
            }
        }
        get  {
            lock.with  {
                return items[index]
            }
        }
    }
    func push(_ s : String) {
        lock.with {
            items.append( s )
        }
    }
    func pop() -> String? {
        lock.with {
            return items.isEmpty ? nil :   items.removeFirst()
        }
    }
    
    func makeIterator() -> SafeArrayIterator {
        return SafeArrayIterator(items)
    }
}
struct SafeArrayIterator: IteratorProtocol {
    typealias Element = String
    let values : [Element]
    var index = 0
    init(_ values: [String]) {
           self.values = values
       }
    mutating func next() -> String? {
        if index < 0 || index >= values.count {
            return nil
        }
        let rc = values[index]
        index += 1
        return rc
    }
}
