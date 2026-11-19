{{flutter_js}}
{{flutter_build_config}}

// Sketchoo web bootstrap.
//
// Flutter normally takes over the whole page and measures the browser viewport.
// Here the app is mounted into a fixed-size host element instead, so on desktop
// browsers it always lays out at the reference phone size (412 x 917 logical
// pixels) inside a phone-shaped frame.
//
// On real mobile browsers the host element is stretched to the whole viewport by
// CSS in index.html, so the app stays edge-to-edge as usual.
(function () {
  var host = document.getElementById('flutter_host');

  _flutter.loader.load({
    config: {
      hostElement: host || undefined,
    },
  });
})();
