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
    ctx.drawPoint = (x, y, sign = 1, radius = 2) ->
        @beginPath()
        if sign >= 0
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
        draw: -> ctx.drawPoint(@x, @y, @sign)
        set_val: (@val) ->
            @sign = if @val >= 0 then 1 else -1

    # 分類関数。y(x)にあたる
    class Classifier
        constructor: (@w = [0, 0, 0]) ->
        calc: (p) ->
            val = p.x * @w[0] + p.y * @w[1] + @w[2]
        draw: ->
            a = @w[0]
            b = @w[1]
            c = @w[2]
            if b == 0 # x軸に平行な直線
                if a == 0 then return # 直線でない
                p0 = {x:     0, y:-c/a}
                p1 = {x: width, y:-c/a}
            else
                p0 = {x:      0, y: -c/b}
                p1 = {x:  width, y: -width * a/b + -c/b}
            ctx.drawLine(p0, p1)

    # パラメータの初期化
    boundary = [0, 1, -width / 2]
    ans      = new Classifier(boundary)

    p = new Point(1, 0)
    p.set_val(ans.calc(p))
    console.log(p.val)
    console.log(p.sign)

    param    = new Classifier() # 学習するパラメータ

    # 点の生成
    points_num = 100
    points = (new Point(width * m.random(), height * m.random()) for i in [0...points_num])

    for p in points
        p.set_val(ans.calc(p))

    counter = 0
    finish  = false

    # ループ
    update = ->
        if counter == 0
            # 配列をシャッフルする
            next_points = []
            while points.length > 0
                index = m.floor(m.random() * points.length)
                next_points.push(points[index])
                points.splice(index, 1)
            points = next_points
            misses = 0

        # 無作為に選ばれた点について、その点の分類先を予想
        p = points[counter]
        val = param.calc(p)
        sign = if val >= 0 then 1 else -1
        if sign != p.sign
            # 予測が間違っていた場合、値を更新(逐次学習)
            param.w[0] += p.sign * p.x
            param.w[1] += p.sign * p.y
            param.w[2] += p.sign * 1
            misses++

        counter++
        if counter == points_num
            if misses == 0
                # 間違いが無ければ学習終了
                finish = true
            counter = 0
    draw = ->
        ctx.clearRect(0, 0, width, height)
        for p in points
            p.draw()
        param.draw()
        $('#w_param').text("w = (#{param.w[0]}, #{param.w[1]}, #{param.w[2]})")

    cycle = ->
        update()
        if finish then return
        draw()
        setTimeout(cycle, 1/fps)

    cycle()
