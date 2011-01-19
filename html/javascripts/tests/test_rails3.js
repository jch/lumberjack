module("Rails 3");

var l1  = 'Started POST "/votes" for 127.0.0.1 at Fri Dec 31 18:54:35 -0800 2010'
var l2  = '  Processing by VotesController#create as */*'
var l3  = '  Parameters: {"vote"=>{"email"=>""}, "authenticity_token"=>"jx5q7j0gvvSUb/tD8C4x3kD6d38cKg8xUSxGurBf3Ug=", "utf8"=>"✓"}'
var l4  = "  AREL (0.4ms)  INSERT INTO \"votes\" (\"updated_at\", \"email\", \"built_it\", \"created_at\") VALUES ('2011-01-01 02:54:35.067806', '', NULL, '2011-01-01 02:54:35.067806')"
var l5  = 'Completed 200 OK in 19ms (Views: 8.6ms | ActiveRecord: 0.4ms)'

function setup() {
  Lumberjack.setup({
    prependTo: '#qunit-fixture',
    debug: true
  })
  Lumberjack.prependEntry();
}

function teardown() {
  Lumberjack.entries().remove();
}

test("'Started' lines should start add a new entry and add the line", function() {
  setup();
  Lumberjack.process(l1);
  equal(Lumberjack.entries().length, 1, "should add an entry");
  e = Lumberjack.currentEntry();
  equal(e.find('.host').text(), "127.0.0.1");
  equal(e.find('.timestamp').text(), "Fri Dec 31 18:54:35 -0800 2010");
  equal(e.find('.method').text(), "POST");
  teardown();
});