import Testing
@testable import FootballKit

final class FootballMatchTests {
    private var sutTracker: MemoryLeakTracker<FootballMatch>?
    
    deinit {
        sutTracker?.verify()
    }
    
    @Test
    func initialData() {
        let homeTeam = makeHomeTeam(name: "Trabzonspor")
        let awayTeam = makeAwayTeam(name: "Stuttgart")
        let (sut, _) = makeSUT(
            homeTeam: homeTeam,
            awayTeam: awayTeam
        )
        
        #expect(sut.getName(.home) == "Trabzonspor")
        #expect(sut.getScore(.home) == 0)
        #expect(sut.getName(.away) == "Stuttgart")
        #expect(sut.getScore(.away) == 0)
    }
    
    @Test
    func start_startsTimerWithGivenDuration() {
        let (sut, timer) = makeSUT(
            homeTeam: makeHomeTeam(),
            awayTeam: makeAwayTeam(),
            duration: 60
        )
        
        sut.start { _ in
        } onMatchEnded: { }
        
        #expect(timer.receivedDuration == 60)
    }
    
    @Test
    func start_withNoSecondPassed_doesNotNotifyCaller() async {
        let (sut, _) = makeSUT(
            homeTeam: makeHomeTeam(),
            awayTeam: makeAwayTeam()
        )
        
        await confirmation(expectedCount: 0) { confirmation in
            sut.start { _ in
                confirmation()
            } onMatchEnded: { }
        }
    }
    
    @Test
    func start_withSecondPassed_notifiesCaller() async {
        let (sut, timer) = makeSUT(
            homeTeam: makeHomeTeam(),
            awayTeam: makeAwayTeam(),
            duration: 60
        )
        
        await confirmation { confirmation in
            sut.start { receivedTimeLeft in
                #expect(receivedTimeLeft == 59)
                confirmation()
            } onMatchEnded: { }
            
            timer.callOnSecondPassed(timeLeft: 59)
        }
    }
    
    @Test
    func start_withMatchNotEnded_doesNotNotifyCaller() async {
        let (sut, timer) = makeSUT(
            homeTeam: makeHomeTeam(),
            awayTeam: makeAwayTeam(),
            duration: 60
        )
        
        await confirmation(expectedCount: 0) { confirmation in
            sut.start { _ in
            } onMatchEnded: {
                confirmation()
            }
            
            timer.callOnSecondPassed(timeLeft: 59)
        }
    }
    
    @Test
    func start_withMatchEnded_notifiesCaller() async {
        let (sut, timer) = makeSUT(
            homeTeam: makeHomeTeam(),
            awayTeam: makeAwayTeam(),
            duration: 60
        )
        
        await confirmation { confirmation in
            sut.start { _ in
            } onMatchEnded: {
                confirmation()
            }
            
            timer.callMatchEnded()
        }
    }
    
    @Test
    func matchEnded_cancelsTimer() {
        let (sut, timer) = makeSUT(
            homeTeam: makeHomeTeam(),
            awayTeam: makeAwayTeam()
        )
        
        sut.start { _ in
        } onMatchEnded: { }
        
        timer.callMatchEnded()
        
        #expect(timer.actions == [.start, .cancel])
    }
    
    @Test
    func pause_pausesTimer() {
        let (sut, timer) = makeSUT(
            homeTeam: makeHomeTeam(),
            awayTeam: makeAwayTeam()
        )
        
        sut.pause()
        
        #expect(timer.actions == [.pause])
    }
    
    @Test
    func resume_resumesTimer() {
        let (sut, timer) = makeSUT(
            homeTeam: makeHomeTeam(),
            awayTeam: makeAwayTeam()
        )
        
        sut.resume()
        
        #expect(timer.actions == [.resume])
    }
    
    @Test
    func cancel_cancelsTimer() {
        let (sut, timer) = makeSUT(
            homeTeam: makeHomeTeam(),
            awayTeam: makeAwayTeam()
        )
        
        sut.cancel()
        
        #expect(timer.actions == [.cancel])
    }
    
    @Test
    func score_incrementsByOne() {
        let homeTeam = makeHomeTeam()
        let awayTeam = makeHomeTeam()
        let (sut, _) = makeSUT(
            homeTeam: homeTeam,
            awayTeam: awayTeam
        )
        
        sut.score(.home)
        sut.score(.home)
        sut.score(.away)
        
        #expect(sut.getScore(.home) == 2)
        #expect(sut.getScore(.away) == 1)
    }
    
    @Test
    func removeGoal_doesNotGoNegative() {
        let homeTeam = makeHomeTeam()
        let awayTeam = makeHomeTeam()
        let (sut, _) = makeSUT(
            homeTeam: homeTeam,
            awayTeam: awayTeam
        )
        
        sut.removeGoal(.home)
        sut.score(.away)
        sut.score(.away)
        sut.removeGoal(.away)
        
        #expect(sut.getScore(.home) == 0)
        #expect(sut.getScore(.away) == 1)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        homeTeam: FootballTeam,
        awayTeam: FootballTeam,
        duration: Int = 60,
        filePath: String = #filePath,
        line: Int = #line,
        column: Int = #column
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
        
        let sourceLocation = SourceLocation(fileID: #fileID, filePath: filePath, line: line, column: column)
        sutTracker = .init(instance: sut, sourceLocation: sourceLocation)
        
        return (sut, timer)
    }
    
    private func makeHomeTeam(
        name: String = "Home"
    ) -> FootballTeam {
        FootballTeam(name: name)
    }
    
    private func makeAwayTeam(
        name: String = "Away"
    ) -> FootballTeam {
        FootballTeam(name: name)
    }
    
    private class StubTimer: Timer {
        private var _onSecondPassed: ((Int) -> Void)?
        private var _onMatchEnded: (() -> Void)?
        
        var receivedDuration: Int?
        
        var actions = [Action]()
        
        enum Action: Equatable {
            case start, pause, resume, cancel
        }

        func start(
            duration: Int,
            onSecondPassed: @escaping (Int) -> Void,
            onMatchEnded: @escaping () -> Void
        ) {
            receivedDuration = duration
            _onSecondPassed = onSecondPassed
            _onMatchEnded = onMatchEnded
            actions.append(.start)
        }
        
        func pause() {
            actions.append(.pause)
        }
        
        func resume() {
            actions.append(.resume)
        }

        func cancel() {
            actions.append(.cancel)
        }

        func callOnSecondPassed(timeLeft: Int) {
            _onSecondPassed?(timeLeft)
        }
        
        func callMatchEnded() {
            _onMatchEnded?()
        }
    }

}
