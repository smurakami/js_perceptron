$(function(){
    // 点の描画
    var drawPoint = function(ctx, x, y, in_the_circle, radius){
        if (typeof(radius) === "undefined") radius = 2;
        ctx.beginPath();
        if(in_the_circle)ctx.fillStyle = 'rgba(192, 80, 77, 0.7)'; // 赤
        else ctx.fillStyle = 'rgba(155, 187, 89, 0.7)'; // 緑
        ctx.arc(x, y, radius, 0, Math.PI * 2, false);
        ctx.fill();
    };

    var width = $('#canvas').width();
    var height = $('#canvas').height();
    var radius = width / 2;
    var center = {
        x: width / 2,
        y: height / 2
    };
    var all_point = 0;
    var point_in_the_circle = 0;
    var canvas = document.getElementById('canvas');
    var context = canvas.getContext('2d');
    var pi;
    context.beginPath();
    context.arc(center.x, center.y, radius, 0, Math.PI*2, false);
    context.stroke();
    var loop = function(){
        // for(var i = 0; i < 100000; i++){
        var x = Math.random() * width;
        var y = Math.random() * height;
        var in_the_circle = ((x - center.x)*(x - center.x)
                          + (y - center.y) * (y - center.y) < radius * radius);

        if(in_the_circle) point_in_the_circle++;
        all_point++;
        pi = point_in_the_circle / all_point * 4;
        drawPoint(context, x, y, in_the_circle);
        $('#all_point').text('all_point: ' + all_point);
        $('#point_in_the_circle').text('point_in_the_circle: ' + point_in_the_circle);
        $('#pi').text('pi: ' + pi);
    // }
        setTimeout(loop, 10);
    };
    loop();
});