public protocol Timer {
    func start(
        duration: Int,
        onSecondPassed: @escaping (Int) -> Void,
        onMatchEnded: @escaping () -> Void
    )
    
    func pause()
    func resume()
    func cancel()
}
