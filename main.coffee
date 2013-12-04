$ ->
    # ライブラリをつかいやすく
    m = Math

    # canvasの取得
    canvas = document.getElementById('canvas')
    ctx = canvas.getContext('2d')
    width = $('#canvas').width()
    height = $('#canvas').height()
    radius = width / 2
    center =
        x: width / 2,
        y: height / 2

    # 描画速度
    fps = 30

    # 点の描画
    ctx.drawPoint = (x, y, val = 1, radius = 2) ->
        @beginPath()
        if val >= 0
            @fillStyle = 'rgb(255, 0, 0)' # 赤
        else
            @fillStyle = 'rgb(0, 0, 255)' # 青
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
        draw: -> ctx.drawPoint(@x, @y, @val)

    class Line
        constructor: (@w) ->
        draw: ->
            a = @w[0]
            b = @w[1]
            c = @w[2]
            if b == 0 # x軸に平行な直線
                p0 = {x:     0, y:-c/a}
                p1 = {x: width, y:-c/a}
            else
                p0 = {x:      0, y: -c/b}
                p1 = {x:  width, y: -width * a/b + -c/b}
            ctx.drawLine(p0, p1)

    # 分類関数。y(x)にあたる
    class Classifier
        constructor: (@w) ->
        calc: (p) ->
            val = p.x * @w[0] + p.y * @w[1] + @w[2]
            if val >= 0 then return 1
            else return -1

    w = [-1, 2, 1]
    y = new Classifier(w)
    line = new Line(w)

    # 点の生成
    points_num = 100
    points = (new Point(width * m.random(), height * m.random()) for i in [0...points_num])

    for p in points
        p.val = y.calc(p)

    # ループ
    update = ->
    draw = ->
        ctx.clearRect(0, 0, width, height)
        for p in points
            p.draw()
        line.draw()

    cycle = ->
        update()
        draw()
        setTimeout(cycle, 1/fps)

    cycle()
