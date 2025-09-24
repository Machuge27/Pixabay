import 'package:flutter_test/flutter_test.dart';
import 'package:form_field_validator/form_field_validator.dart';

void main() {
  group('Form Validation Tests', () {
    group('Full Name Validation', () {
      final validator = MultiValidator([
        RequiredValidator(errorText: 'Full name is required'),
        MinLengthValidator(2, errorText: 'Name must be at least 2 characters'),
      ]);

      test('should return error for empty name', () {
        expect(validator(''), 'Full name is required');
      });

      test('should return error for name less than 2 characters', () {
        expect(validator('A'), 'Name must be at least 2 characters');
      });

      test('should return null for valid name', () {
        expect(validator('John Doe'), null);
      });
    });

    group('Email Validation', () {
      final validator = MultiValidator([
        RequiredValidator(errorText: 'Email is required'),
        EmailValidator(errorText: 'Enter a valid email address'),
      ]);

      test('should return error for empty email', () {
        expect(validator(''), 'Email is required');
      });

      test('should return error for invalid email format', () {
        expect(validator('invalid-email'), 'Enter a valid email address');
      });

      test('should return null for valid email', () {
        expect(validator('test@example.com'), null);
      });
    });

    group('Password Validation', () {
      final validator = MultiValidator([
        RequiredValidator(errorText: 'Password is required'),
        MinLengthValidator(6, errorText: 'Password must be at least 6 characters'),
      ]);

      test('should return error for empty password', () {
        expect(validator(''), 'Password is required');
      });

      test('should return error for password less than 6 characters', () {
        expect(validator('12345'), 'Password must be at least 6 characters');
      });

      test('should return null for valid password', () {
        expect(validator('password123'), null);
      });
    });

    group('Confirm Password Validation', () {
      String confirmPasswordValidator(String? value, String password) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your password';
        }
        if (value != password) {
          return 'Passwords do not match';
        }
        return '';
      }

      test('should return error for empty confirm password', () {
        expect(confirmPasswordValidator('', 'password123'), 'Please confirm your password');
      });

      test('should return error for mismatched passwords', () {
        expect(confirmPasswordValidator('different', 'password123'), 'Passwords do not match');
      });

      test('should return empty string for matching passwords', () {
        expect(confirmPasswordValidator('password123', 'password123'), '');
      });
    });
  });
}