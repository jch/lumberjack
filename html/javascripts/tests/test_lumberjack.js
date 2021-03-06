module("Lumberjack");

var l1 = "Processing ReviewsController#index (for 127.0.0.1 at 2011-01-12 19:53:28) [GET]"
var l2 = "Started GET \"/stylesheets/reset-min.css\" for 127.0.0.1 at Wed Jan 12 14:07:58 -0800 2011"

test("insertEntry should only have top most entry be selected", function() {
  ok( Lumberjack.entries().length == 0, "no entries before test" );
  Lumberjack.prependEntry("#qunit-fixture");
  Lumberjack.prependEntry("#qunit-fixture");
  ok( Lumberjack.entries().length == 2, "2 entries added" );

  ok( Lumberjack.entries().filter(":last").hasClass('selected'), "first entry not selected" );
  ok( !Lumberjack.entries().filter(':first').hasClass('selected'), "last entry selected" );
  Lumberjack.entries().remove();
});

test("appendLineToCurrentEntry should append to given destination within current entry", function() {
  Lumberjack.prependEntry("#qunit-fixture");
  ok( Lumberjack.currentEntry().length == 1, "current entry exists" );
  var controllerAction = "UserController#new";
  Lumberjack.appendLineToCurrentEntry(".controller_action", controllerAction);
  ok( Lumberjack.currentEntry().find('.controller_action').text() == controllerAction,
      "appending to .controller_action worked");
});

test("seeing a rails2 log should switch Lumberjack.rules", function() {
  oldRules = Lumberjack.rules
  notEqual(Lumberjack.rules, Lumberjack.rails2.rules, "rules shouldn't be the same at first");
  Lumberjack.process(l1);
  equal(Lumberjack.rules, Lumberjack.rails2.rules);
  Lumberjack.rules = oldRules;
});

test("seeing a rails3 log should switch Lumberjack.rules", function() {
  oldRules = Lumberjack.rules
  notEqual(Lumberjack.rules, Lumberjack.rails3.rules, "rules shouldn't be the same at first");
  Lumberjack.process(l2);
  equal(Lumberjack.rules, Lumberjack.rails3.rules);
  Lumberjack.rules = oldRules;
});