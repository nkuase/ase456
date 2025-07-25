class Arith {
    /// Adds two integers and returns the result.
    int add(int a, int b) {
        return a + b;
    }
    
    /// Subtracts the second integer from the first and returns the result.
    int subtract(int a, int b) {
        return a - b;
    }
    
    /// Multiplies two integers and returns the result.
    int multiply(int a, int b) {
        return a * b;
    }
    
    /// Divides the first integer by the second and returns the result.
    /// Throws an [ArgumentError] if the second integer is zero.
    double divide(int a, int b) {
        if (b == 0) {
        throw ArgumentError('Cannot divide by zero');
        }
        return a / b;
    }
}