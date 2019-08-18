import Foundation

/// Subclasses should implement main, and not call super. Super will switch `state` to executing.
/// When you're finished with async work, switch the operation `state` to `.finished`.
/// Finally, when switching threads or between subtasks check if the operation is cancelled. If it is switch the state to `.finished` and return.
class AsyncOperation: Operation {
    enum State {
        case waiting
        case executing
        case finished
        
        var kvoKey: String? {
            switch self {
            case .executing: return "isExecuting"
            case .finished: return "isFinished"
            default: return nil
            }
        }
    }
    
    var state: State = .waiting {
        willSet {
            if let kvoKey = state.kvoKey { willChangeValue(forKey: kvoKey) }
            if let kvoKey = newValue.kvoKey { willChangeValue(forKey: kvoKey) }
        }
        didSet {
            if let kvoKey = oldValue.kvoKey { didChangeValue(forKey: kvoKey) }
            if let kvoKey = state.kvoKey { didChangeValue(forKey: kvoKey) }
        }
    }
    
    override var isAsynchronous: Bool { return true }
    override var isExecuting: Bool { return state == .executing }
    override var isFinished: Bool { return state == .finished }
    
    override func start() {
        guard !isCancelled else { state = .finished; return }
        state = .executing
        main()
    }
}
