import 'package:test/test.dart';
import '../lib/ExtensionMethods.dart';

void main() {
  group('String Extension Methods', () {
    group('reverse() method', () {
      test('should reverse simple string', () {
        expect("hello".reverse(), equals("olleh"));
      });

      test('should reverse single character', () {
        expect("a".reverse(), equals("a"));
      });

      test('should handle empty string', () {
        expect("".reverse(), equals(""));
      });

      test('should reverse palindrome correctly', () {
        expect("racecar".reverse(), equals("racecar"));
      });

      test('should reverse string with numbers', () {
        expect("abc123".reverse(), equals("321cba"));
      });

      test('should reverse string with special characters', () {
        expect("hello!@#".reverse(), equals("#@!olleh"));
      });

      test('should reverse string with spaces', () {
        expect("hello world".reverse(), equals("dlrow olleh"));
      });
    });

    group('isEmail getter', () {
      test('should return true for valid email formats', () {
        expect("test@email.com".isEmail, isTrue);
        expect("user@domain.org".isEmail, isTrue);
        expect("name@company.co.uk".isEmail, isTrue);
        expect("first.last@subdomain.domain.com".isEmail, isTrue);
      });

      test('should return false for invalid email formats', () {
        expect("invalid".isEmail, isFalse);
        expect("@email.com".isEmail, isFalse);
        expect("test@".isEmail, isFalse);
        expect("test.com".isEmail, isFalse);
        expect("test@email".isEmail, isFalse);
      });

      test('should return false for empty string', () {
        expect("".isEmail, isFalse);
      });

      test('should return false for strings with only @ symbol', () {
        expect("@".isEmail, isFalse);
      });

      test('should return false for strings with only dot', () {
        expect(".".isEmail, isFalse);
      });

      test('should return false for strings with @ but no dot', () {
        expect("test@email".isEmail, isFalse);
      });

      test('should return false for strings with dot but no @', () {
        expect("test.email".isEmail, isFalse);
      });
    });
  });

  group('Extension Method Examples Function', () {
    test('extensionMethodExample should demonstrate extensions', () {
      expect(() => extensionMethodExample(), 
             prints(contains('=== Extension Method Examples ===')));
    });

    test('extensionMethodExample should show reverse example', () {
      expect(() => extensionMethodExample(), 
             prints(contains('"hello".reverse(): olleh')));
    });

    test('extensionMethodExample should show valid email example', () {
      expect(() => extensionMethodExample(), 
             prints(contains('"test@email.com".isEmail: true')));
    });

    test('extensionMethodExample should show invalid email example', () {
      expect(() => extensionMethodExample(), 
             prints(contains('"invalid".isEmail: false')));
    });

    test('main function should run all examples', () {
      expect(() => main(), 
             prints(contains('=== EXTENSION METHODS ===')));
    });
  });

  group('Real-world Usage Examples', () {
    test('should chain extension methods', () {
      // Test chaining extensions
      String original = "hello@test.com";
      String reversed = original.reverse();
      
      expect(reversed, equals("moc.tset@olleh"));
      // Note: reversed email is not a valid email
      expect(reversed.isEmail, isFalse);
    });

    test('should work with string literals', () {
      expect("abc".reverse(), equals("cba"));
      expect("user@domain.com".isEmail, isTrue);
    });

    test('should work with string variables', () {
      String testString = "world";
      String emailString = "contact@company.com";
      
      expect(testString.reverse(), equals("dlrow"));
      expect(emailString.isEmail, isTrue);
    });

    test('should handle Unicode characters', () {
      expect("café".reverse(), equals("éfac"));
      expect("müller@üniversity.de".isEmail, isTrue);
    });
  });

  group('Performance and Edge Cases', () {
    test('should handle very long strings', () {
      String longString = "a" * 1000;
      String reversed = longString.reverse();
      
      expect(reversed.length, equals(1000));
      expect(reversed, equals("a" * 1000)); // All 'a's, so reverse is same
    });

    test('should handle strings with newlines', () {
      String multiLine = "line1\nline2";
      expect(multiLine.reverse(), equals("2enil\n1enil"));
    });

    test('should handle complex email validation edge cases', () {
      // These are technically not fully RFC-compliant but our simple check allows them
      expect("a@b.c".isEmail, isTrue); // Very short but has both @ and .
      expect("test@sub.domain.co.uk".isEmail, isTrue); // Multiple dots
    });
  });
}
