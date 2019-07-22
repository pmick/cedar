import XCTest

@testable import Cedar

class HabitControllerTests: XCTestCase {
    let sut = HabitController()
    
    let noCompletionsHabit = Habit(id: "1", title: "Test", completions: [])
    let completedLongAgoHabit = Habit(id: "1", title: "Test", completions: [HabitCompletion(date: Date(timeIntervalSince1970: 0))])
    let completedTodayHabit = Habit(id: "1", title: "Test", completions: [HabitCompletion()])
    let completedYesterdayHabit = Habit(id: "1", title: "Test", completions: [HabitCompletion(date: Date(timeIntervalSinceNow: -(24 * 60 * 60)))])
    let completedNinetyDaysAgoHabit = Habit(id: "1", title: "Test", completions: [HabitCompletion(date: Date(timeIntervalSinceNow: -(24 * 60 * 60 * 90)))])
    
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
