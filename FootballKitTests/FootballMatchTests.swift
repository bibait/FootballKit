import Testing
@testable import FootballKit

struct FootballMatchTests {

    @Test
    func canInit() {
        let homeTeam = FootballTeam()
        let awayTeam = FootballTeam()
        let sut = FootballMatch(homeTeam: homeTeam, awayTeam: awayTeam, duration: 60)
        sut.timer = StubTimer()
    }
    
    @Test
    func start_withNoSecondPassed_doesNotNotifyCaller() async {
        let homeTeam = FootballTeam()
        let awayTeam = FootballTeam()
        let (sut, _) = makeSUT(homeTeam: homeTeam, awayTeam: awayTeam)
        
        await confirmation(expectedCount: 0) { confirmation in
            sut.start { _ in
                confirmation()
            }
        }
    }
    
    @Test
    func start_withSecondPassed_notifiesCaller() async {
        let homeTeam = FootballTeam()
        let awayTeam = FootballTeam()
        let (sut, timer) = makeSUT(homeTeam: homeTeam, awayTeam: awayTeam, duration: 60)
        
        await confirmation { confirmation in
            sut.start { receivedTimeLeft in
                #expect(receivedTimeLeft == 59)
                confirmation()
            }
            
            timer.callOnSecondPassed(timeLeft: 59)
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        homeTeam: FootballTeam,
        awayTeam: FootballTeam,
        duration: Int = 60
    ) -> (
        sut: FootballMatch,
        timer: StubTimer
    ) {
        let sut = FootballMatch(
            homeTeam: homeTeam,
            awayTeam: awayTeam,
            duration: duration
        )
        let timer = StubTimer()
        sut.timer = timer
        
        return (sut, timer)
    }
    
    private class StubTimer: Timer {
        private var _onSecondPassed: ((Int) -> Void)?

        func start(
            onSecondPassed: @escaping (Int) -> Void
        ) {
            _onSecondPassed = onSecondPassed
        }

        func callOnSecondPassed(timeLeft: Int) {
            _onSecondPassed?(timeLeft)
        }
    }

}
