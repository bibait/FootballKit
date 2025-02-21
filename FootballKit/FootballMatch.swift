public class FootballMatch {
    private let _homeTeam: FootballTeam
    private let _awayTeam: FootballTeam
    private let _duration: Int

    public init(
        homeTeam: FootballTeam,
        awayTeam: FootballTeam,
        duration: Int
    ) {
        _homeTeam = homeTeam
        _awayTeam = awayTeam
        _duration = duration
    }
    
    internal var timer: Timer = DummyTimer()
    
    public func start(
        onSecondPassed: @escaping (Int) -> Void,
        onMatchEnded: @escaping () -> Void
    ) {
        timer.start(
            duration: _duration,
            onSecondPassed: onSecondPassed,
            onMatchEnded: { [weak self] in
                guard let self = self else { return
                }
                
                onMatchEnded()
                self.timer.cancel()
            }
        )
    }
    
    public func pause() {
        timer.pause()
    }
    
    public func resume() {
        timer.resume()
    }
}
