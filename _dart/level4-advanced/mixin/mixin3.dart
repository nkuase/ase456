import 'dart:math';

mixin BallSports {
  void playsWith() => print("Ball");
  double ballVolume(double radius) {
      const values = 4/3 * 3.14;
      return values * pow(radius, 3);
  }
}

abstract class FootballTeam with BallSports {
  String name();
}
class RealMadrid extends FootballTeam { name() => "RealMadrid"; }
class LiverpoolFC extends FootballTeam { name() => "LiverpoolFC"; }

abstract class VolleyballTeam with BallSports {
  String nameAndAbbreviation();
}
class TeamA extends VolleyballTeam { nameAndAbbreviation() => "TeamA"; }
class TeamB extends VolleyballTeam { nameAndAbbreviation() => "TeamB"; }

main() {
  var ta = TeamA();
  var tb = TeamB();
  var r  = RealMadrid();
  var l  = LiverpoolFC();
  
  ta.playsWith();
  tb.playsWith();
  r.playsWith();
  l.playsWith();
}