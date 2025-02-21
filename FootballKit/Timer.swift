public protocol Timer {
    func start(
        onSecondPassed: @escaping (Int) -> Void
    )
}
