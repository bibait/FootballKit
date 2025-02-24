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
        
        _timer = Foundation.Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerEvent), userInfo: nil, repeats: true)
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
    
    func reset() {
        cancel()
    }
    
    func cancel() {
        _timer?.invalidate()
        _timer = nil
    }
    
    @objc
    private func timerEvent() {
        guard _duration != nil, _onSecondPassed != nil, _onMatchEnded != nil else {
            return
        }

        if _duration == 0 {
           _onMatchEnded!()
            return
        }
        
        _duration! -= 1
        _onSecondPassed!(_duration!)
    }
}
