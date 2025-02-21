public class FootballTeam {
    private let _name: String

    public init(name: String) {
        _name = name
    }
    
    private var currentScore = 0
    
    func score() { currentScore += 1 }
    
    func removeGoal() {
        guard currentScore > 0 else {
            return
        }
        
        currentScore -= 1
    }
    
    func getScore() -> Int { currentScore }
    
    func getName() -> String { _name }
}
