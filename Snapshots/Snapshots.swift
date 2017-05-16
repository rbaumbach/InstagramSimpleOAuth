import XCTest

class Snapshots: XCTestCase {
    override func setUp() {
        super.setUp()
        
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }
    
    func testLoginView() {
        let app = XCUIApplication()
        
        app.buttons["Present InstagramVC"].tap()
        
        // I found out the 'label' for the progress bar using The Developer tool
        // Accessibility Inspector.
        
        // Use "hittable" to determine if something is "hidden" or not.
        // If a view is "hittable" then isHidden is false
        
        let progress = app.activityIndicators["In progress"]
        let isHidden = NSPredicate(format: "hittable == false")

        expectation(for: isHidden, evaluatedWith: progress, handler: nil)
        waitForExpectations(timeout: 10) { (_) in
            snapshot("InstagramLoginView")
        }
    }
}
