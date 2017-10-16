//
//  Operations.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 16.10.17.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class AsyncOperation: Operation {
    
    // Определяем перечисление enum State со свойством keyPath
    enum State: String {
        case ready, executing, finished
        
        fileprivate var keyPath: String {
            return "is" + rawValue.capitalized
        }
    }
    
    // Помещаем в subclass свойство state типа State
    var state = State.ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
}

extension AsyncOperation {
    // Переопределения для Operation
    override var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    override var isExecuting: Bool {
        return state == .executing
    }
    
    override var isFinished: Bool {
        return state == .finished
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override func start() {
        if isCancelled {
            state = .finished
            return
        }
        main()
        state = .executing
    }
    
    override func cancel() {
        state = .finished
    }
    
}

class ReadProfileOperation: AsyncOperation {
    var profile:Profile?
    
    override func main() {
        profile = Profile.getProfile()
        sleep(4)
        self.state = .finished
    }
}

class SaveProfileOperation: AsyncOperation {
    var result:String?
    var profile:Profile
    
    init(profile:Profile) {
        self.profile = profile
        super.init()
    }
    override func main() {
        result = profile.saveProfile()
        sleep(4)
        self.state = .finished
    }
}
