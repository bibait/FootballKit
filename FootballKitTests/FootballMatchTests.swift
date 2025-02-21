import Testing
@testable import FootballKit

struct FootballMatchTests {

    @Test
    func canInit() {
        let homeTeam = FootballTeam()
        let awayTeam = FootballTeam()
        let sut = FootballMatch(homeTeam: homeTeam, awayTeam: awayTeam, duration: 60)
        sut.timer = FakeTimer()
    }
    
    @Test
    func start_withNoSecondPassed_doesNotNotifyCaller() async {
        let homeTeam = FootballTeam()
        let awayTeam = FootballTeam()
        let sut = FootballMatch(homeTeam: homeTeam, awayTeam: awayTeam, duration: 60)
        sut.timer = FakeTimer()
        
        await confirmation(expectedCount: 0) { confirmation in
            sut.start { _ in
                confirmation()
            }
        }
    }
    
    // MARK: - Helpers
    
    private struct FakeTimer: Timer {
        
    }

}
