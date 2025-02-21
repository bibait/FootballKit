public struct FootballTeam {
    public init() {}
}

public protocol Timer {
}

class FoundationTimer: Timer {}

public class FootballMatch {
    private let _homeTeam: FootballTeam
    private let _awayTeam: FootballTeam

    public init(
        homeTeam: FootballTeam,
        awayTeam: FootballTeam
    ) {
        self._homeTeam = homeTeam
        self._awayTeam = awayTeam
    }
    
    internal var timer: Timer = FoundationTimer()
}
