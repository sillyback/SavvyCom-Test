//
//  BaseCoordinator.swift
//  CodingTest
//
//  Created by Chung Cr on 30/05/2022.
//

import Foundation
import RxSwift

open class BaseCoordinator<ResultType> {
    typealias CoordinatorResult = ResultType
    
    let disposeBag = DisposeBag()
    private let uuid = UUID()
    private var childCoordinators = [UUID: Any]()

    private func store<T>(coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.uuid] = coordinator
    }

    private func release<T>(coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.uuid] = nil
    }

    @discardableResult
    open func coordinate<T>(to coordinator: BaseCoordinator<T>) -> Observable<T> {
        store(coordinator: coordinator)
        return coordinator.start()
            .do(onNext: { [weak self] _ in
                self?.release(coordinator: coordinator) })
    }

    open func start() -> Observable<ResultType> {
        fatalError("start() method must be implemented")
    }
}
