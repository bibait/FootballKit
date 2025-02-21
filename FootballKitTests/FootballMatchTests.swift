import Testing
import FootballKit

struct FootballMatchTests {

    @Test
    func canInit() {
        let homeTeam = FootballTeam()
        let awayTeam = FootballTeam()
        _ = FootballMatch(homeTeam: homeTeam, awayTeam: awayTeam)
    }

}
