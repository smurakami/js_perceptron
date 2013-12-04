// Generated by CoffeeScript 1.6.3
(function() {
  $(function() {
    var all_point, canvas, center, context, cycle, draw, drawPoint, height, pi, point_in_the_circle, radius, update, width;
    canvas = document.getElementById('canvas');
    context = canvas.getContext('2d');
    width = $('#canvas').width();
    height = $('#canvas').height();
    radius = width / 2;
    center = {
      x: width / 2,
      y: height / 2
    };
    drawPoint = function(ctx, x, y, in_the_circle, radius) {
      if (radius == null) {
        radius = 2;
      }
      ctx.beginPath();
      if (in_the_circle) {
        ctx.fillStyle = 'rgba(192, 80, 77, 0.7)';
      } else {
        ctx.fillStyle = 'rgba(155, 187, 89, 0.7)';
      }
      ctx.arc(x, y, radius, 0, Math.PI * 2, false);
      return ctx.fill();
    };
    all_point = 0;
    point_in_the_circle = 0;
    pi = 0;
    context.beginPath();
    context.arc(center.x, center.y, radius, 0, Math.PI * 2, false);
    context.stroke();
    update = function() {
      var in_the_circle, x, y;
      x = Math.random() * width;
      y = Math.random() * height;
      in_the_circle = (x - center.x) * (x - center.x) + (y - center.y) * (y - center.y) < radius * radius;
      if (in_the_circle) {
        point_in_the_circle++;
      }
      all_point++;
      pi = point_in_the_circle / all_point * 4;
      drawPoint(context, x, y, in_the_circle);
      $('#all_point').text('all_point: ' + all_point);
      $('#point_in_the_circle').text('point_in_the_circle: ' + point_in_the_circle);
      $('#pi').text('pi: ' + pi);
      return setTimeout(cycle, 10);
    };
    draw = function() {};
    cycle = function() {
      update();
      return draw();
    };
    return cycle();
  });

}).call(this);
