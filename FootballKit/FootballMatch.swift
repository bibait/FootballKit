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
    
    public enum Team {
        case home, away
    }
    
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
    
    public func score(_ team: Team) {
        switch team {
        case .home:
            _homeTeam.score()
        case .away:
            _awayTeam.score()
        }
    }
    
    public func getScore(_ team: Team) -> Int {
        switch team {
        case .home:
            _homeTeam.getScore()
        case .away:
            _awayTeam.getScore()
        }
    }
    
    public func getName(_ team: Team) -> String {
        switch team {
        case .home:
            _homeTeam.getName()
        case .away:
            _awayTeam.getName()
        }
    }
    
    public func pause() { timer.pause() }
    
    public func resume() { timer.resume() }
    
    public func cancel() { timer.cancel() }
}
