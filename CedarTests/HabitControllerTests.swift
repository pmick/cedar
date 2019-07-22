import XCTest

@testable import Cedar

final class HabitControllerTests: XCTestCase {
    let sut = HabitController()
    
    let noCompletionsHabit = Habit(title: "Test", completions: [])
    let completedLongAgoHabit = Habit(title: "Test", completions: [HabitCompletion(date: Date(timeIntervalSince1970: 0))])
    let completedTodayHabit = Habit(title: "Test", completions: [HabitCompletion()])
    let completedYesterdayHabit = Habit(title: "Test", completions: [HabitCompletion(date: Date(timeIntervalSinceNow: -(24 * 60 * 60)))])
    let completedNinetyDaysAgoHabit = Habit(title: "Test", completions: [HabitCompletion(date: Date(timeIntervalSinceNow: -(24 * 60 * 60 * 90)))])
    
    func testIsCompleted() {
        XCTAssertFalse(sut.isComplete(habit: noCompletionsHabit))
        XCTAssertFalse(sut.isComplete(habit: completedLongAgoHabit))
        XCTAssertTrue(sut.isComplete(habit: completedTodayHabit))
    }
    
    func testWasCompleted() {
        XCTAssertFalse(sut.wasCompleted(daysAgo: 0, habit: noCompletionsHabit))
        XCTAssertFalse(sut.wasCompleted(daysAgo: 1, habit: noCompletionsHabit))
        
        XCTAssertFalse(sut.wasCompleted(daysAgo: 1, habit: completedTodayHabit))
        XCTAssertTrue(sut.wasCompleted(daysAgo: 0, habit: completedTodayHabit))
        
        XCTAssertTrue(sut.wasCompleted(daysAgo: 1, habit: completedYesterdayHabit))
        XCTAssertTrue(sut.wasCompleted(daysAgo: 90, habit: completedNinetyDaysAgoHabit))
    }
}
