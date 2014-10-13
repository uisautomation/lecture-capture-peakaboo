Package.describe({
  summary: "Ladda bootstrap spinner buttons",
  version: "1.0.0"
});

Package.onUse(function(api) {
  api.versionsFrom('METEOR@0.9.3.1');
  api.addFiles('lib/ladda-themeless.css', 'client');
  api.addFiles('lib/spin.js', 'client');
  api.addFiles('lib/ladda.js', 'client');
});
