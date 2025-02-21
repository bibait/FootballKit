public class FootballTeam {
    public init() {}
    
    private var currentScore = 0
    
    func score() {
        currentScore += 1
    }
    
    public func getScore() -> Int {
        currentScore
    }
}
