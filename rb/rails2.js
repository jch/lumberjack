// processing rules for rails2
Lumberjack.rails2 = {
  rules: [
    Lumberjack.rails.cleanup,
    Lumberjack.rails.url,
    Lumberjack.rails.file,

    [/Processing (\w+#\w+)/, function(line, matches) {
      var extras = line.match(/\(for (.*?) at (.*?)\) \[(.*?)\]/);
      Lumberjack.appendLineToCurrentEntry('.controller_action', matches[1]);
      Lumberjack.appendLineToCurrentEntry('.host', extras[1]);
      Lumberjack.appendLineToCurrentEntry('.timestamp', extras[2]);
      Lumberjack.appendLineToCurrentEntry('.method', extras[3]);
      return ["", false];
    }],

    // set controller_action link
    [/.*?Param/, function(line, matches) {
      var reAction = /,? ?"action"=>"(.*?)",? ?/;
      var reController = /,? ?"controller"=>"(.*?)",? ?/;
      var action = line.match(reAction)[1];
      var controller = line.match(reController)[1];

      e = Lumberjack.currentEntry();
      var text = e.find('.controller_action').text();
      var href = Lumberjack.config.projectRoot + 'app/controllers/' + controller + "_controller.rb";
      var link = $("<a>").attr('href', href).text(text);
      e.find('.controller_action').html(link);
      return [line, true];
    }],

    Lumberjack.rails.ignoreSQLNoise,
    Lumberjack.rails.wrapInParagraph,
    Lumberjack.rails.exception,
    Lumberjack.rails.render,
    Lumberjack.rails.redirect,
    Lumberjack.rails.params,
    Lumberjack.rails.stacktrace,
    Lumberjack.rails.sql,
    Lumberjack.rails.fallthrough
  ]
}