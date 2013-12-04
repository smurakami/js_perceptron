$ ->
    # 点の描画
    drawPoint = (ctx, x, y, in_the_circle, radius=2) ->
        ctx.beginPath()
        if(in_the_circle)
            ctx.fillStyle = 'rgba(192, 80, 77, 0.7)' # 赤
        else
            ctx.fillStyle = 'rgba(155, 187, 89, 0.7)' # 緑
        ctx.arc(x, y, radius, 0, Math.PI * 2, false)
        ctx.fill()

    width = $('#canvas').width()
    height = $('#canvas').height()
    radius = width / 2
    center =
        x: width / 2,
        y: height / 2

    all_point = 0
    point_in_the_circle = 0
    canvas = document.getElementById('canvas')
    context = canvas.getContext('2d')
    pi = 0
    context.beginPath()
    context.arc(center.x, center.y, radius, 0, Math.PI*2, false)
    context.stroke()
    update = ->
        x = Math.random() * width
        y = Math.random() * height
        in_the_circle = ((x - center.x)*(x - center.x) \
                          + (y - center.y) * (y - center.y) < radius * radius)

        if(in_the_circle)
            point_in_the_circle++
        all_point++
        pi = point_in_the_circle / all_point * 4
        drawPoint(context, x, y, in_the_circle)
        $('#all_point').text('all_point: ' + all_point)
        $('#point_in_the_circle').text('point_in_the_circle: ' + point_in_the_circle)
        $('#pi').text('pi: ' + pi)
        setTimeout(update, 10)
    update()
