import XCTest
@testable import Conversion

@MainActor
final class ToolkitViewModelTests: XCTestCase {
    func testLengthCategoryExposesExpectedDefaultSourceUnit() {
        let viewModel = ToolkitViewModel(defaultCategory: .length)

        XCTAssertEqual(viewModel.selectedCategory, .length)
        XCTAssertEqual(viewModel.sourceUnitSymbol, "km")
    }

    func testSpeedCategoryConvertsOneInputToMultipleOutputs() {
        let viewModel = ToolkitViewModel(defaultCategory: .speed)
        viewModel.sourceUnitSymbol = "kph"
        viewModel.inputText = "100"

        let mphValue = viewModel.conversionResults.first(where: { $0.unitSymbol == "mph" })?.outputValue
        let metersPerSecondValue = viewModel.conversionResults.first(where: { $0.unitSymbol == "m/s" })?.outputValue

        XCTAssertNotNil(mphValue)
        XCTAssertNotNil(metersPerSecondValue)
        XCTAssertEqual(mphValue ?? 0, 62.137_119, accuracy: 0.000_1)
        XCTAssertEqual(metersPerSecondValue ?? 0, 27.777_778, accuracy: 0.000_1)
    }

    func testInvalidInputReturnsNoComputedOutputValues() {
        let viewModel = ToolkitViewModel(defaultCategory: .volume)
        viewModel.sourceUnitSymbol = "L"
        viewModel.inputText = "-"

        XCTAssertTrue(viewModel.conversionResults.allSatisfy { $0.outputValue == nil })
    }

    func testCategoryChangeResetsSourceToValidUnitWhenNeeded() {
        let viewModel = ToolkitViewModel(defaultCategory: .power)
        viewModel.sourceUnitSymbol = "hp"

        viewModel.selectedCategory = .temperature

        XCTAssertEqual(viewModel.sourceUnitSymbol, "c")
        XCTAssertTrue(viewModel.availableUnitSymbols.contains(viewModel.sourceUnitSymbol))
    }
}
