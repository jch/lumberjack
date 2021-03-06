module("Rails 2");

var l1  = "Processing ApplicationController#index (for 127.0.0.1 at 2010-01-21 03:21:21) [GET]";
var l2Date = new Date();
var l2  = "Processing ReviewsController#create (for 127.0.0.1 at " + l2Date.format("yyyy-mm-dd hh:mm:ss") + ") [POST]";
var l3  = "LoadError (Expected /Users/jch/projects/beerpad/app/controllers/beers_controller.rb to define BeersController):";
var l4  = "Rendered rescues/_request_and_response (21.7ms)";
var l5  = "Rendering rescues/layout (internal_server_error)";
var l5a = "Rendered /Library/Ruby/Gems/1.8/gems/actionpack-3.0.1/lib/action_dispatch/middleware/templates/rescues/_trace.erb (1.0ms)"
var l6  = "  SQL (0.1ms)   SET NAMES 'utf8'";
var l7  = "  SQL (0.1ms)   SET SQL_AUTO_IS_NULL=0";
var l8  = '  Parameters: {"action"=>"new", "controller"=>"reviews"}';
var l8a = '  Parameters: {"action"=>"index", "region_id"=>"1", "controller"=>"topics"}'
var l8b = '  Parameters: {"action"=>"new", "controller"=>"admin/reviews"}'; // nested route
var l9  = '  User Load (7.1ms)   SELECT * FROM "users" WHERE ("users"."id" = E\'1\') LIMIT 1';
var l9a = '  Review Load (2.9ms)	SELECT * FROM "reviews" WHERE ("reviews"."status" = E\'published\') ORDER BY reviews.created_at DESC LIMIT 6 OFFSET 0'
var l9b = '  Region Load (1.1ms)	SELECT `regions`.* FROM `regions` INNER JOIN `slugs` ON `slugs`.sluggable_id = `regions`.id AND `slugs`.sluggable_type = \'Region\' WHERE (`slugs`.`scope` IS NULL AND `slugs`.`sequence` = \'1\' AND `slugs`.`name` = \'1\') ORDER BY regions.name asc LIMIT 1'
var l10 = "Redirected to http://localhost:3000/login";
var l11 = "Filter chain halted as [:login_required] rendered_or_redirected.";
var l12 = "Completed in 93ms (DB: 8) | 302 Found [http://localhost/reviews/new]";
var l13 = "  SQL (0.3ms)   SET client_min_messages TO 'panic'";
var l14 = "  SQL (0.1ms)   SET client_min_messages TO 'notice'";
var l15 = 'ActionController::RoutingError (No route matches "/patients" with {:method=>:get}):';
var l16 = "  vendor/bundler_gems/ruby/1.8/gems/actionpack-2.3.5/lib/action_controller/routing/recognition_optimisation.rb:66:in `recognize_path'";
var l17 = "  vendor/bundler_gems/ruby/1.8/gems/actionpack-2.3.5/lib/action_controller/routing/route_set.rb:441:in `recognize'";
var l18 = "  vendor/bundler_gems/ruby/1.8/gems/rails-2.3.5/lib/rails/rack/static.rb:31:in `call'";
var l19 = "  vendor/bundler_gems/ruby/1.8/gems/rails-2.3.5/lib/rails/rack/log_tailer.rb:17:in `call'";
var l20 = "  /Users/jch/.rvm/rubies/ree-1.8.7-2010.02/lib/ruby/1.8/webrick/httpserver.rb:104:in `service'";
var l21 = "  vendor/bundler_gems/ruby/1.8/gems/rails-2.3.5/lib/commands/server.rb:111";
var l22 = "app/views/home/index.html.haml:21:in `_app_views_home_index_html_haml___218630815_2198145100_0'"
var l23  = "    18:             %td design";
var l23a = "    19:             %td *****";
var l23b = "    20:       %div.description.left";


function setup() {
  Lumberjack.setup({
    prependTo: '#qunit-fixture',
    projectRoot: "file:///Users/jch/projects/beerpad/"
  })
  Lumberjack.setType('rails2');
  Lumberjack.prependEntry();
}

function teardown() {
  Lumberjack.entries().remove();
}

test("Processing lines should start add a new entry and add the line", function() {
  setup();
  Lumberjack.process(l1);
  equal(Lumberjack.entries().length, 1, "should add an entry");
  e = Lumberjack.currentEntry();
  equal(e.find('.controller_action').text(), "ApplicationController#index");
  equal(e.find('.host').text(), "127.0.0.1");
  equal(e.find('.timestamp').text(), "2010-01-21 03:21:21");
  equal(e.find('.method').text(), "GET");
  teardown();
});

test("Error should have class .error", function() {
  setup();
  count = Lumberjack.entries().length;
  Lumberjack.process(l3);
  equal(Lumberjack.entries().length, count, "no new entry should've been added");
  e = Lumberjack.currentEntry();
  equal(e.find('.body > .error').length, 1, "should be an error line");
  teardown();
});

test("Ignore SQL noise", function() {
  setup();
  Lumberjack.process(l6);
  Lumberjack.process(l7);
  Lumberjack.process(l13);
  Lumberjack.process(l14);
  equal(Lumberjack.currentEntry().find('.body').html(), "");
  teardown();
});

test("Render messages should have class .render", function() {
  setup();
  Lumberjack.process(l4);
  Lumberjack.process(l5);
  e = Lumberjack.currentEntry();
  equal(e.find('.body > .render').length, 2, "should be render lines");
  teardown();
});

test("Redirect messages should have class .redirect", function() {
  setup();
  Lumberjack.process(l10);
  e = Lumberjack.currentEntry();
  equal(e.find('.body > .redirect').length, 1, "should be redirect lines");
  teardown();
});

test("Params should have class .params and no controller and action", function() {
  setup();
  Lumberjack.process(l8);
  e = Lumberjack.currentEntry();
  equal(e.find('.body > .params').length, 1, "should be params lines");
  equal(e.find('.body > .params:last').text(), '  Parameters: {}');

  Lumberjack.process(l8a);
  e = Lumberjack.currentEntry();
  equal(e.find('.body > .params').length, 2, "should be params lines");
  equal(e.find('.body > .params:last').text(), '  Parameters: {"region_id"=>"1"}');
  
  Lumberjack.appendLineToCurrentEntry(".controller_action", "FOOBAR"); // to href
  Lumberjack.process(l8b);
  e = Lumberjack.currentEntry();
  equal(e.find('.controller_action > a').attr('href'), "file:///Users/jch/projects/beerpad/app/controllers/admin/reviews_controller.rb");
  teardown();
});

test("Stacktrace lines should have class .stacktrace", function() {
  setup();
  Lumberjack.process(l16);
  Lumberjack.process(l17);
  Lumberjack.process(l18);
  Lumberjack.process(l19);
  Lumberjack.process(l20);
  Lumberjack.process(l21);
  e = Lumberjack.currentEntry();
  equal(e.find('.body > .stacktrace').length, 6, "should be stacktrace lines");
  teardown();
});

test("SQL should have class .sql", function() {
  setup();
  Lumberjack.process(l9);
  Lumberjack.process(l9a);
  Lumberjack.process(l9b);
  e = Lumberjack.currentEntry();
  equal(e.find('.body > .sql').length, 3, "should be sql lines");
  teardown();
});

test("HTTP urls should be linked", function() {
  setup();
  Lumberjack.process(l10);
  e = Lumberjack.currentEntry();
  equal(e.find('.body a[href="http://localhost:3000/login"]').length, 1);
  teardown();
});

test("Files urls should be linked", function() {
  setup();
  Lumberjack.process(l19); // relative
  e = Lumberjack.currentEntry();
  var href = Lumberjack.config.projectRoot + "vendor/bundler_gems/ruby/1.8/gems/rails-2.3.5/lib/rails/rack/log_tailer.rb";
  equal(e.find('.body a[href="' + href + '"]').length, 1);

  Lumberjack.process(l20); // absolute
  var href = "/Users/jch/.rvm/rubies/ree-1.8.7-2010.02/lib/ruby/1.8/webrick/httpserver.rb"
  equal(e.find('.body a[href="' + href + '"]').length, 1);
  teardown();
});
