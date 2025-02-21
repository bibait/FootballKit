import Testing
@testable import FootballKit

struct FootballMatchTests {

    @Test
    func canInit() {
        let homeTeam = FootballTeam()
        let awayTeam = FootballTeam()
        let sut = FootballMatch(homeTeam: homeTeam, awayTeam: awayTeam)
        sut.timer = FakeTimer()
    }
    
    // MARK: - Helpers
    
    private struct FakeTimer: Timer {
        
    }

}
