//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
library Fractions {
    struct Fraction {
        int numerator;
        int denominator;
    }
    function add(Fraction memory fraction1, Fraction memory fraction2) internal pure returns(Fraction memory) {
        int numerator = fraction1.numerator * fraction2.denominator + fraction2.numerator * fraction1.denominator;
        int denominator = fraction1.denominator * fraction2.denominator;
        return Fraction({numerator: numerator, denominator: denominator});
    }
    function sub(Fraction memory fraction1, Fraction memory fraction2) internal pure returns(Fraction memory) {
        int numerator = fraction1.numerator * fraction2.denominator - fraction2.numerator * fraction1.denominator;
        int denominator = fraction1.denominator * fraction2.denominator;
        return Fraction({numerator: numerator, denominator: denominator});
    }
    function div(Fraction memory fraction1, Fraction memory fraction2) internal pure returns(Fraction memory) {
        int numerator = fraction1.numerator * fraction2.denominator;
        int denominator = fraction1.denominator * fraction2.numerator;
        return Fraction({numerator: numerator, denominator: denominator});
    }
    function mul(Fraction memory fraction1, Fraction memory fraction2) internal pure returns(Fraction memory) {
        int numerator = fraction1.numerator * fraction2.numerator;
        int denominator = fraction1.denominator * fraction2.denominator;
        return Fraction({numerator: numerator, denominator: denominator});
    }
}