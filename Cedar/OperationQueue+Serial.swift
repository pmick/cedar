import Foundation

extension OperationQueue {
    static var serial: OperationQueue {
        let q = OperationQueue()
        q.maxConcurrentOperationCount = 1
        return q
    }
}
