public struct FootballTeam {
    public init() {}
}

public protocol Timer {
}

class FoundationTimer: Timer {}

public class FootballMatch {
    private let _homeTeam: FootballTeam
    private let _awayTeam: FootballTeam
    private let _duration: Int

    public init(
        homeTeam: FootballTeam,
        awayTeam: FootballTeam,
        duration: Int
    ) {
        self._homeTeam = homeTeam
        self._awayTeam = awayTeam
        self._duration = duration
    }
    
    internal var timer: Timer = FoundationTimer()
}
