import XCTest
import Reporter

class TimerTests: XCTestCase {
    func testExample() throws {
        let testCases =
            [
                (300_000, "05:00"),
                (299_999, "05:00"),
                (299_001, "05:00"),
                (299_000, "04:59"),
                (60_001, "01:01"),
                (60_000, "01:00"),
                (59_999, "01:00"),
                (59_001, "01:00"),
                (59_000, "00:59"),
                (10_000, "00:10"),
                (05_000, "00:05"),
                (01_000, "00:01"),
                (00_999, "00:01"),
                (00_500, "00:01"),
                (00_001, "00:01"),
                (00_000, "00:00")
            ]

        testCases.forEach {
            XCTAssertEqual(TimerUtils.getFormattedTimeLeft(numberOfMilliseconds: $0), $1)
        }
    }
}
