$ ->
    # canvasの取得
    canvas = document.getElementById('canvas')
    ctx = canvas.getContext('2d')
    width = $('#canvas').width()
    height = $('#canvas').height()
    radius = width / 2
    center =
        x: width / 2,
        y: height / 2

    # 点の描画
    ctx.drawPoint = (x, y, in_the_circle, radius=2) ->
        @beginPath()
        if(in_the_circle)
            @fillStyle = 'rgba(192, 80, 77, 0.7)' # 赤
        else
            @fillStyle = 'rgba(155, 187, 89, 0.7)' # 緑
        @arc(x, y, radius, 0, Math.PI * 2, false)
        @fill()

    # 線の描画
    ctx.drawLine = (a, b) ->


    all_point = 0
    point_in_the_circle = 0
    pi = 0
    ctx.beginPath()
    ctx.arc(center.x, center.y, radius, 0, Math.PI*2, false)
    ctx.stroke()

    # ループ
    update = ->
        x = Math.random() * width
        y = Math.random() * height
        in_the_circle = ((x - center.x)*(x - center.x) \
                          + (y - center.y) * (y - center.y) < radius * radius)

        if(in_the_circle)
            point_in_the_circle++
        all_point++
        pi = point_in_the_circle / all_point * 4
        ctx.drawPoint(x, y, in_the_circle)
        $('#all_point').text('all_point: ' + all_point)
        $('#point_in_the_circle').text('point_in_the_circle: ' + point_in_the_circle)
        $('#pi').text('pi: ' + pi)
        setTimeout(cycle, 10)

    draw = ->

    cycle = ->
        update()
        draw()

    cycle()
