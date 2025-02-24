@testable import FootballKit

class StubTimer: Timer {
    private var _onSecondPassed: ((Int) -> Void)?
    private var _onMatchEnded: (() -> Void)?

    var receivedDuration: Int?

    var actions = [Action]()

    enum Action: Equatable {
        case start, pause, resume, cancel, reset
    }

    func start(
        duration: Int,
        onSecondPassed: @escaping (Int) -> Void,
        onMatchEnded: @escaping () -> Void
    ) {
        receivedDuration = duration
        _onSecondPassed = onSecondPassed
        _onMatchEnded = onMatchEnded
        actions.append(.start)
    }

    func pause() {
        actions.append(.pause)
    }

    func resume() {
        actions.append(.resume)
    }
    
    func reset() {
        actions.append(.reset)
    }

    func cancel() {
        actions.append(.cancel)
    }

    func callOnSecondPassed(timeLeft: Int) {
        _onSecondPassed?(timeLeft)
    }

    func callMatchEnded() {
        _onMatchEnded?()
    }
}
