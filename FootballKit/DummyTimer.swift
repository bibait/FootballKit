class DummyTimer: Timer {
    func start(
        duration: Int,
        onSecondPassed: @escaping (Int) -> Void,
        onMatchEnded: @escaping () -> Void
    ) { }
    
    func cancel() {}
}
