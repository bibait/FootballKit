import Testing
@testable import FootballKit

struct FootballMatchTests {
    
    @Test
    func start_withNoSecondPassed_doesNotNotifyCaller() async {
        let (sut, _) = makeSUT(homeTeam: makeHomeTeam(), awayTeam: makeAwayTeam())
        
        await confirmation(expectedCount: 0) { confirmation in
            sut.start { _ in
                confirmation()
            }
        }
    }
    
    @Test
    func start_withSecondPassed_notifiesCaller() async {
        let (sut, timer) = makeSUT(homeTeam: makeHomeTeam(), awayTeam: makeAwayTeam(), duration: 60)
        
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
    
    private func makeHomeTeam() -> FootballTeam {
        FootballTeam()
    }
    
    private func makeAwayTeam() -> FootballTeam {
        FootballTeam()
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
