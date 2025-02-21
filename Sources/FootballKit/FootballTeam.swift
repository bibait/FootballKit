public class FootballTeam {
    private let _name: String

    public init(name: String) {
        _name = name
    }
    
    private var currentScore = 0
    
    internal func score() { currentScore += 1 }
    
    internal func removeGoal() {
        guard currentScore > 0 else {
            return
        }
        
        currentScore -= 1
    }
    
    internal func getScore() -> Int { currentScore }
    
    internal func getName() -> String { _name }
}
