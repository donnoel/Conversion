import XCTest
@testable import Conversion

final class ConversionMathTests: XCTestCase {
    func testCatalogContainsAllRequiredReversiblePairs() {
        let expectedIDs: Set<String> = [
            "length.cm-in",
            "length.m-cm",
            "weight.kg-lb",
            "weight.kg-g",
            "temp.c-f",
            "temp.c-k",
            "length.mm-in",
            "length.m-ft",
            "length.km-mi",
            "length.mi-ft",
            "length.cm-ft",
            "weight.lb-g",
            "weight.g-oz",
            "length.in-ft",
            "volume.tsp-ml",
            "volume.tbsp-ml",
            "volume.l-gal",
            "volume.pt-l",
            "volume.qt-l",
            "weight.lb-oz",
            "speed.mph-kph",
            "speed.kph-ms",
            "speed.mph-ms",
            "pressure.psi-bar",
            "pressure.psi-kpa",
            "pressure.bar-kpa",
            "area.ac-ha",
            "area.acre-sqft",
            "area.sqft-sqm",
            "angle.rad-deg",
            "power.hp-kw",
            "length.m-yd",
            "volume.ml-cup",
            "volume.floz-ml"
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

    func testNewPracticalPairsConvertCorrectly() throws {
        let cases: [(id: String, input: Double, reversed: Bool, expected: Double, accuracy: Double)] = [
            ("volume.tsp-ml", 1, false, 4.928_92, 0.000_01),
            ("volume.tbsp-ml", 1, false, 14.786_8, 0.000_1),
            ("volume.pt-l", 1, false, 0.473_176, 0.000_001),
            ("volume.qt-l", 1, false, 0.946_353, 0.000_001),
            ("length.m-cm", 1, false, 100, 0.000_001),
            ("length.mi-ft", 1, false, 5_280, 0.000_001),
            ("weight.kg-g", 1, false, 1_000, 0.000_001),
            ("weight.lb-g", 1, false, 453.592, 0.001),
            ("speed.kph-ms", 36, false, 10, 0.000_01),
            ("pressure.psi-bar", 1, false, 0.068_948, 0.000_001),
            ("pressure.psi-kpa", 1, false, 6.894_76, 0.000_01),
            ("pressure.bar-kpa", 1, false, 100, 0.000_001),
            ("area.ac-ha", 1, false, 0.404_686, 0.000_001)
        ]

        for testCase in cases {
            let pair = try XCTUnwrap(
                ConversionCatalog.pair(withID: testCase.id),
                "Missing pair \(testCase.id)"
            )

            XCTAssertEqual(
                pair.convert(testCase.input, isReversed: testCase.reversed),
                testCase.expected,
                accuracy: testCase.accuracy,
                "Unexpected conversion for \(testCase.id)"
            )
        }
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
