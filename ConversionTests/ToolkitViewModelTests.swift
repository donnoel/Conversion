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

    func testVolumeCategoryExposesNewUnitsInPreferredOrder() {
        let viewModel = ToolkitViewModel(defaultCategory: .volume)

        XCTAssertEqual(viewModel.sourceUnitSymbol, "L")
        XCTAssertEqual(viewModel.availableUnitSymbols, ["L", "qt", "pt", "gal", "cup", "fl oz", "tbsp", "tsp", "mL"])
    }

    func testAreaCategoryExposesNewHectaresUnit() {
        let viewModel = ToolkitViewModel(defaultCategory: .area)

        XCTAssertEqual(viewModel.availableUnitSymbols, ["ha", "ac", "sq m", "sq ft"])
    }

    func testPressureCategoryExposesExpectedUnitsInPreferredOrder() {
        let viewModel = ToolkitViewModel(defaultCategory: .pressure)

        XCTAssertEqual(viewModel.sourceUnitSymbol, "psi")
        XCTAssertEqual(viewModel.availableUnitSymbols, ["psi", "bar", "kPa"])
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
