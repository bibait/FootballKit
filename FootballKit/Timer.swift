public protocol Timer {
    func start(
        duration: Int,
        onSecondPassed: @escaping (Int) -> Void
    )
}
