public class FootballMatch {
    private let _homeTeam: FootballTeam
    private let _awayTeam: FootballTeam
    private let _duration: Int
    
    /// Initializes a `FootballMatch`
    ///
    /// > Important: Match duration is given in seconds.
    ///
    /// - Parameters:
    ///   - homeTeam: The home team for the match.
    ///   - awayTeam: The away team for the match.
    ///   - duration: Match duration in seconds.
    public init(
        homeTeam: FootballTeam,
        awayTeam: FootballTeam,
        duration: Int
    ) {
        _homeTeam = homeTeam
        _awayTeam = awayTeam
        _duration = duration
    }
    
    internal var timer: Timer = FoundationTimer()
    
    public enum Team {
        case home, away
    }
    
    /// Starts a match.
    /// - Parameters:
    ///   - onSecondPassed: Called whenever a second passes with the remaining time.
    ///   - onMatchEnded: Called when the match ended after the given duration.
    public func start(
        onSecondPassed: @escaping (Int) -> Void,
        onMatchEnded: @escaping () -> Void
    ) {
        timer.start(
            duration: _duration,
            onSecondPassed: onSecondPassed,
            onMatchEnded: { [weak self] in
                guard let self = self else {
                    return
                }
                
                onMatchEnded()
                self.timer.cancel()
            }
        )
    }
    
    /// Increments the score by one.
    /// - Parameter team: The team that scored.
    public func score(_ team: Team) {
        switch team {
        case .home:
            _homeTeam.score()
        case .away:
            _awayTeam.score()
        }
    }
    
    /// Decrements the score by one.
    /// - Parameter team: The team from which to remove a goal.
    public func removeGoal(_ team: Team) {
        switch team {
        case .home:
            _homeTeam.removeGoal()
        case .away:
            _awayTeam.removeGoal()
        }
    }
    
    /// Get the score of a team.
    /// - Parameter team: The team whose score is retrieved.
    /// - Returns: The number of goals for the given team.
    public func getScore(_ team: Team) -> Int {
        switch team {
        case .home:
            _homeTeam.getScore()
        case .away:
            _awayTeam.getScore()
        }
    }
    
    /// Get the name of a team.
    /// - Parameter team: The team whose name is retrieved.
    /// - Returns: The team's name.
    public func getName(_ team: Team) -> String {
        switch team {
        case .home:
            _homeTeam.getName()
        case .away:
            _awayTeam.getName()
        }
    }
    
    /// Pause the match.
    ///
    /// Stops calling `onSecondPassed` and `onMatchEnded` closure.
    public func pause() { timer.pause() }
    
    /// Resets the match.
    ///
    /// Resets the score and invalidates the timer.
    public func reset() {
        _homeTeam.setScore(0)
        _awayTeam.setScore(0)
        timer.reset()
    }
    
    /// Resume the match.
    ///
    /// Continues calling `onSecondPassed` and `onMatchEnded` closure.
    public func resume() { timer.resume() }
    
    /// Cancel the match.
    ///
    /// Stops calling `onSecondPassed` and `onMatchEnded` closure.
    public func cancel() { timer.cancel() }
}
