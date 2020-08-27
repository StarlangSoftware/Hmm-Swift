import XCTest
@testable import Hmm

final class Hmm2Test: XCTestCase {
    func testViterbi() {
        let observations = [["HOT", "HOT", "HOT"],
                        ["HOT", "COLD", "COLD", "COLD"],
                        ["HOT", "COLD", "HOT", "COLD"],
                        ["COLD", "COLD", "COLD", "HOT", "HOT"],
                        ["COLD", "HOT", "HOT", "COLD", "COLD"]]
        let emittedSymbols = [[3, 2, 3],
                          [2, 2, 1, 1],
                          [3, 1, 2, 1],
                          [3, 1, 2, 2, 3],
                          [1, 2, 3, 2, 1]]
        var states : Set<String> = Set<String>()
        states.insert("HOT")
        states.insert("COLD")
        let hmm2 : Hmm2<String, Int> = Hmm2<String, Int>(states: states, observations: observations, emittedSymbols: emittedSymbols)
        var observed : [Int] = [1, 1, 1, 1, 1, 1]
        var observedStates : [String] = hmm2.viterbi(s: observed)
        XCTAssertEqual("COLD", observedStates[0])
        XCTAssertEqual("COLD", observedStates[1])
        XCTAssertEqual("COLD", observedStates[2])
        XCTAssertEqual("COLD", observedStates[3])
        XCTAssertEqual("COLD", observedStates[4])
        XCTAssertEqual("COLD", observedStates[5])
        observed = [1, 2, 3, 3, 2, 1]
        observedStates = hmm2.viterbi(s: observed)
        XCTAssertEqual("COLD", observedStates[0])
        XCTAssertEqual("HOT", observedStates[1])
        XCTAssertEqual("HOT", observedStates[2])
        XCTAssertEqual("HOT", observedStates[3])
        XCTAssertEqual("HOT", observedStates[4])
        XCTAssertEqual("COLD", observedStates[5])
        observed = [3, 3, 3, 3, 3, 3]
        observedStates = hmm2.viterbi(s: observed)
        XCTAssertEqual("HOT", observedStates[0])
        XCTAssertEqual("HOT", observedStates[1])
        XCTAssertEqual("HOT", observedStates[2])
        XCTAssertEqual("HOT", observedStates[3])
        XCTAssertEqual("HOT", observedStates[4])
        XCTAssertEqual("HOT", observedStates[5])
    }

    static var allTests = [
        ("testExample", testViterbi),
    ]
}
