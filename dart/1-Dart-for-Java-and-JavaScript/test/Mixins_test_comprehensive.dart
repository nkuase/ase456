import 'package:test/test.dart';
import '../lib/Mixins.dart';

void main() {
  group('Mixin Tests', () {
    group('Flyable Mixin', () {
      test('Duck should be able to fly', () {
        final duck = Duck();
        expect(() => duck.fly(), prints("Flying through the air!\n"));
        expect(duck.flyingSpeed, equals(50.0));
      });

      test('Eagle should fly faster than default', () {
        final eagle = Eagle();
        expect(eagle.flyingSpeed, equals(150.0));
        expect(() => eagle.fly(), prints("Flying through the air!\n"));
      });

      test('Superman should fly fastest', () {
        final superman = Superman();
        expect(superman.flyingSpeed, equals(1000.0));
      });
    });

    group('Swimmable Mixin', () {
      test('Fish can breathe underwater', () {
        final fish = Fish();
        expect(() => fish.breatheUnderwater(), prints("Breathing through gills!\n"));
      });

      test('Duck should swim gracefully (overridden method)', () {
        final duck = Duck();
        expect(() => duck.swim(), prints("Duck swimming gracefully!\n"));
      });

      test('Superman should swim faster than default', () {
        final superman = Superman();
        expect(superman.swimmingSpeed, equals(500.0));
      });

      test('Penguin should have default swimming behavior', () {
        final penguin = Penguin();
        expect(() => penguin.swim(), prints("Swimming in the water!\n"));
        expect(penguin.swimmingSpeed, equals(20.0));
      });
    });

    group('Walkable Mixin', () {
      test('Penguin should waddle adorably (overridden method)', () {
        final penguin = Penguin();
        expect(() => penguin.walk(), prints("Penguin waddling adorably!\n"));
      });

      test('Eagle should have default walking behavior', () {
        final eagle = Eagle();
        expect(() => eagle.walk(), prints("Walking on land!\n"));
        expect(eagle.walkingSpeed, equals(5.0));
      });

      test('Superman should walk faster than default', () {
        final superman = Superman();
        expect(superman.walkingSpeed, equals(100.0));
      });
    });

    group('Class-specific Methods', () {
      test('Duck should quack', () {
        final duck = Duck();
        expect(() => duck.quack(), prints("Quack! Quack!\n"));
      });

      test('Penguin should slide on ice', () {
        final penguin = Penguin();
        expect(() => penguin.slide(), prints("Sliding on ice!\n"));
      });

      test('Eagle should hunt', () {
        final eagle = Eagle();
        expect(() => eagle.hunt(), prints("Hunting for prey!\n"));
      });

      test('Superman should save the world', () {
        final superman = Superman();
        expect(() => superman.saveTheWorld(), prints("Saving the world!\n"));
      });
    });

    group('Mixin Composition Tests', () {
      test('Duck should have both flying and swimming abilities', () {
        final duck = Duck();
        
        // Duck should be able to fly
        expect(() => duck.takeOff(), prints("Taking off...\n"));
        expect(() => duck.land(), prints("Landing...\n"));
        
        // Duck should be able to swim
        expect(() => duck.dive(), prints("Diving underwater...\n"));
        expect(() => duck.surface(), prints("Coming to surface...\n"));
      });

      test('Penguin should have swimming and walking but not flying', () {
        final penguin = Penguin();
        
        // Penguin should be able to swim
        expect(() => penguin.swim(), prints("Penguin waddling adorably!\n"));
        
        // Penguin should be able to walk/run
        expect(() => penguin.run(), prints("Running fast!\n"));
        
        // Penguin should NOT have flying methods (this would cause compilation error)
        // penguin.fly(); // This line would not compile
      });

      test('Superman should have all abilities', () {
        final superman = Superman();
        
        // Should have all speed properties with enhanced values
        expect(superman.flyingSpeed, greaterThan(100));
        expect(superman.swimmingSpeed, greaterThan(100)); 
        expect(superman.walkingSpeed, greaterThan(50));
        
        // Should be able to perform all actions
        expect(() => superman.fly(), prints("Flying through the air!\n"));
        expect(() => superman.swim(), prints("Swimming in the water!\n"));
        expect(() => superman.walk(), prints("Walking on land!\n"));
      });
    });

    group('Integration Tests', () {
      test('demonstrateMixins should run without errors', () {
        expect(() => demonstrateMixins(), prints(contains('=== MIXIN EXAMPLES ===')));
      });

      test('demonstrateCascadeWithMixins should run without errors', () {
        expect(() => demonstrateCascadeWithMixins(), 
               prints(contains('=== MIXINS WITH CASCADE OPERATOR ===')));
      });

      test('main function should execute all demonstrations', () {
        expect(() => main(), prints(contains('MIXIN EXAMPLES')));
      });
    });

    group('Edge Cases and Validation', () {
      test('all speed values should be positive', () {
        final duck = Duck();
        final penguin = Penguin();
        final eagle = Eagle();
        final fish = Fish();
        final superman = Superman();
        
        expect(duck.flyingSpeed, greaterThan(0));
        expect(duck.swimmingSpeed, greaterThan(0));
        
        expect(penguin.swimmingSpeed, greaterThan(0));
        expect(penguin.walkingSpeed, greaterThan(0));
        
        expect(eagle.flyingSpeed, greaterThan(0));
        expect(eagle.walkingSpeed, greaterThan(0));
        
        expect(fish.swimmingSpeed, greaterThan(0));
        
        expect(superman.flyingSpeed, greaterThan(0));
        expect(superman.swimmingSpeed, greaterThan(0));
        expect(superman.walkingSpeed, greaterThan(0));
      });

      test('Superman should be fastest in all categories', () {
        final duck = Duck();
        final eagle = Eagle();
        final superman = Superman();
        
        expect(superman.flyingSpeed, greaterThan(eagle.flyingSpeed));
        expect(superman.flyingSpeed, greaterThan(duck.flyingSpeed));
        expect(superman.swimmingSpeed, greaterThan(duck.swimmingSpeed));
      });
    });
  });
}
