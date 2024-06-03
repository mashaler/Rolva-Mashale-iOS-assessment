import XCTest
@testable import About_You

class About_YouTests: XCTestCase {
    
    func testEngineerStruct() {
        let engineer = Engineer(name: "John Doe",
                                role: "Developer",
                                defualtImageName: "defaultImage",
                                quickStats: QuickStats(years: 5, coffees: 1000, bugs: 50),
                                questions: [],
                                profileImage: UIImage(named: "profileImage"))
        
        XCTAssertEqual(engineer.name, "John Doe")
        XCTAssertEqual(engineer.role, "Developer")
        XCTAssertEqual(engineer.defualtImageName, "defaultImage")
        XCTAssertEqual(engineer.quickStats.years, 5)
        XCTAssertEqual(engineer.quickStats.coffees, 1000)
        XCTAssertEqual(engineer.quickStats.bugs, 50)
        XCTAssertNotNil(engineer.defualtImageName)
    }
    
    func testQuestionStruct() {
        let answer = Answer(text: "Sample answer", index: 1)
        let question = Question(questionText: "Sample question",
                                answerOptions: ["Option 1", "Option 2"],
                                questionType: "Type",
                                answer: answer)
        
        XCTAssertEqual(question.questionText, "Sample question")
        XCTAssertEqual(question.answerOptions, ["Option 1", "Option 2"])
        XCTAssertEqual(question.questionType, "Type")
        XCTAssertEqual(question.answer?.text, "Sample answer")
        XCTAssertEqual(question.answer?.index, 1)
    }

}
