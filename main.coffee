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
    ctx.drawPoint = (x, y, in_the_circle, radius = 2) ->
        @beginPath()
        if(in_the_circle)
            @fillStyle = 'rgba(192, 80, 77, 0.7)' # 赤
        else
            @fillStyle = 'rgba(155, 187, 89, 0.7)' # 緑
        @arc(x, y, radius, 0, Math.PI * 2, false)
        @fill()

    # 線の描画
    ctx.drawLine = (a, b) ->
        @beginPath()
        @moveTo(a.x, a.y)
        @lineTo(b.x, b.y)
        @stroke()

    # 点
    class Point
        constructor: (@x = 0, @y = 0) ->

    # ループ
    update = ->
        ctx.clearRect(0, 0, width, height)

    draw = ->

    cycle = ->
        update()
        draw()
        setTimeout(cycle, 10)

    cycle()
