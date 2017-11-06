//
//  Operation.swift
//  Tinkoff-Homework
//
//  Created by Кирилл Володин on 31.10.2017.
//  Copyright © 2017 Кирилл Володин. All rights reserved.
//

import UIKit

class OperationTaskManager : IProfileStorage  {

    let operationQueue = OperationQueue()
    weak var delegate: IProfileStorageDelegate?
    
    func saveProfile(profile: IProfileProtocol) {
        let saveOperation = SaveProfileOperation(profile: profile)
        saveOperation.completionBlock = {
            if saveOperation.result != nil {
                DispatchQueue.main.async() {
                    self.delegate?.showErrorAlert()
                }
            } else {
                DispatchQueue.main.async() {
                    self.delegate?.showSucsessAlert()
                }
            }
        }
        operationQueue.addOperation(saveOperation)
    }
    
    func readProfile() {
        let readOperation = ReadProfileOperation()
        readOperation.completionBlock = {
            if let profile = readOperation.profile {
                DispatchQueue.main.async() {
                    self.delegate?.receiveProfile(profile: profile)
                }
            }
        }
        operationQueue.addOperation(readOperation)
    }
}


class AsyncOperation: Operation {
    
    enum State: String {
        case ready, executing, finished
        
        fileprivate var keyPath: String {
            return "is" + rawValue.capitalized
        }
    }
    
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

class ReadProfileOperation: AsyncOperation, IProfileLoaderProtocol {
    var profile: IProfileProtocol?
    
    override func main() {
        profile = readProfileFromFile()
        self.state = .finished
    }
}

class SaveProfileOperation: AsyncOperation, IProfileLoaderProtocol {
    
    var result: String?
    var profile: IProfileProtocol
    
    init(profile: IProfileProtocol) {
        self.profile = profile
        super.init()
    }
    override func main() {
        result = saveProfileToFile(profile: profile)
        self.state = .finished
    }
}
