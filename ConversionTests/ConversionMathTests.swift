import XCTest
@testable import Conversion

final class ConversionMathTests: XCTestCase {
    func testCatalogContainsAllRequiredReversiblePairs() {
        let expectedIDs: Set<String> = [
            "length.cm-in",
            "weight.kg-lb",
            "temp.c-f",
            "length.mm-in",
            "length.m-ft",
            "length.km-mi",
            "length.cm-ft",
            "weight.g-oz",
            "length.in-ft",
            "volume.l-gal",
            "weight.lb-oz",
            "speed.mph-kph",
            "area.acre-sqft",
            "angle.rad-deg",
            "power.hp-kw",
            "length.m-yd",
            "volume.ml-cup"
        ]

        XCTAssertEqual(Set(ConversionCatalog.allPairs.map(\.id)), expectedIDs)
    }

    func testRoundTripForAllPairs() {
        for pair in ConversionCatalog.allPairs {
            let original = 123.456
            let converted = pair.convert(original, isReversed: false)
            let roundTripped = pair.convert(converted, isReversed: true)
            XCTAssertEqual(roundTripped, original, accuracy: 0.000_000_1, "Round-trip failed for \(pair.id)")
        }
    }

    func testTemperatureConversionFormula() {
        guard let pair = ConversionCatalog.pair(withID: "temp.c-f") else {
            return XCTFail("Missing celsius/fahrenheit converter")
        }

        XCTAssertEqual(pair.convert(0, isReversed: false), 32, accuracy: 0.000_001)
        XCTAssertEqual(pair.convert(100, isReversed: false), 212, accuracy: 0.000_001)
        XCTAssertEqual(pair.convert(32, isReversed: true), 0, accuracy: 0.000_001)
    }

    func testNumericInputParserTypingStates() throws {
        XCTAssertNil(NumericInputParser.parse(""))
        XCTAssertNil(NumericInputParser.parse("-"))
        XCTAssertNil(NumericInputParser.parse("."))
        XCTAssertNil(NumericInputParser.parse("-."))

        let trailingDecimalValue = try XCTUnwrap(NumericInputParser.parse("1."))
        XCTAssertEqual(trailingDecimalValue, 1.0, accuracy: 0.000_001)

        let commaDecimalValue = try XCTUnwrap(NumericInputParser.parse("12,5"))
        XCTAssertEqual(commaDecimalValue, 12.5, accuracy: 0.000_001)
    }

    func testNumberFormattingRemovesTrailingZeros() {
        let locale = Locale(identifier: "en_US_POSIX")
        XCTAssertEqual(NumberFormatting.display(10.0, locale: locale), "10")
        XCTAssertEqual(NumberFormatting.display(10.5, locale: locale), "10.5")
        XCTAssertEqual(NumberFormatting.display(1_500.125, locale: locale), "1500.125")
    }
}
