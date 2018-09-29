//
//  ConversionTests.swift
//  OMDB ClientTests
//
//  Created by Prateek Pande on 29/09/18.
//  Copyright © 2018 Prateek Pande. All rights reserved.
//

import XCTest

typealias DateData = [String : Int]

class ConversionTests: XCTestCase {

    var dateTestCases = DateData()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let currentYear = Calendar.current.component(.year, from: Date())
        // Invalid dates
        dateTestCases[""] = 0
        dateTestCases[String(describing: currentYear)] = 0
        dateTestCases["NA"] = 0
        dateTestCases["–"] = 0
        dateTestCases[String(describing: currentYear+2)] = -2
        
        // Expected date
        for _ in 1...20{
            let randomYear = Int.random(in: 1800...currentYear)
            dateTestCases[String(describing: randomYear)] = currentYear - randomYear
        }
        
        dateTestCases["1839–1920"] = currentYear - 1920
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDateConversion(){
        
        for dateData in dateTestCases.keys{
             let difference = DateHelper.calculateAgeDifference(year: dateData)
            XCTAssertEqual(difference, dateTestCases[dateData])
        }
    }


//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
