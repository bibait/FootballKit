import Foundation

class FoundationTimer: Timer {
    private var _timer: Foundation.Timer?
    
    private var _duration: Int?
    private var _onSecondPassed: ((Int) -> Void)?
    private var _onMatchEnded: (() -> Void)?

    func start(
        duration: Int,
        onSecondPassed: @escaping (Int) -> Void,
        onMatchEnded: @escaping () -> Void
    ) {
        _duration = duration
        _onSecondPassed = onSecondPassed
        _onMatchEnded = onMatchEnded
        
        _timer = Foundation.Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
            guard let self = self else {
                return
            }

            if self._duration == 0 {
                _onMatchEnded!()
                return
            }
            
            self._duration! -= 1
            _onSecondPassed!(self._duration!)
        })
    }
    
    func pause() {
        _timer?.invalidate()
        _timer = nil
    }
    
    func resume() {
        guard let duration = _duration, let onSecondPassed = _onSecondPassed, let onMatchEnded = _onMatchEnded else {
            return
        }
        
        start(duration: duration, onSecondPassed: onSecondPassed, onMatchEnded: onMatchEnded)
    }
    
    func cancel() {
        _timer?.invalidate()
        _timer = nil
    }
}
