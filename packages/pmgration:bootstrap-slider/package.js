Package.describe({
  summary: "Bootstrap slider",
  version: "1.0.0"
});

Package.onUse(function(api) {
  api.versionsFrom('METEOR@1.0');
  api.addFiles('js/bootstrap-slider.js', 'client');
  api.addFiles('dist/css/bootstrap-slider.css', 'client');
});
