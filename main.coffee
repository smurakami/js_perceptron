$ ->
    # ライブラリをつかいやすく
    m = Math
    # canvasの取得
    canvas = document.getElementById('canvas')
    ctx = canvas.getContext('2d')
    # 更新する必要の無い描画は静的キャンバスに分けてパフォーマンス向上
    canvas_static = document.getElementById('canvas_static')
    ctx_static = canvas_static.getContext('2d')
    # 各種パラメータの設定
    width = $('#canvas').width()
    height = $('#canvas').height()
    scale = width
    radius = width / 2
    center =
        x: width / 2,
        y: height / 2

    # 描画速度
    fps = 30

    # 点の描画
    CanvasRenderingContext2D.prototype.drawPoint = (x, y, sign = 1, radius = 2) ->
        x *= scale
        y *= scale
        @beginPath()
        if sign >= 0
            @fillStyle = 'rgb(255, 0, 0)' # 赤
        else
            @fillStyle = 'rgb(0, 0, 255)' # 青
        @arc(x, y, radius, 0, Math.PI * 2, false)
        @fill()

    # 線の描画
    CanvasRenderingContext2D.prototype.drawLine = (a, b) ->
        @beginPath()
        @moveTo(a.x * scale, a.y * scale)
        @lineTo(b.x * scale, b.y * scale)
        @stroke()

    # 点
    class Point
        constructor: (@x = 0, @y = 0) ->
        draw: (static_draw = false) ->
            if static_draw
                ctx_static.drawPoint(@x, @y, @sign)
            else
                ctx.drawPoint(@x, @y, @sign)
        set_val: (@val) ->
            @sign = if @val >= 0 then 1 else -1

    # 分類関数。y(x)にあたる
    class Classifier
        constructor: (@w = [0, 0, 0]) ->
        calc: (p) ->
            val = p.x * @w[0] + p.y * @w[1] + @w[2]
        draw: (static_draw = false) ->
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
            if static_draw
                ctx_static.drawLine(p0, p1)
            else
                ctx.drawLine(p0, p1)


    ans = null
    boundary = null
    points = null
    ans_w = [-1, 1, 0.1]
    counter = 0
    finish = false
    points_num = 100

    # パラメータの初期化
    init = ->
        ans = new Classifier(ans_w)
        boundary = new Classifier() # 学習するパラメータ

        # 点の生成
        points = (new Point(m.random(), m.random()) for i in [0...points_num])

        for p in points
            p.set_val(ans.calc(p))

        counter = 0
        finish  = false

        for p in points
            p.draw(true)

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
        val = boundary.calc(p)
        sign = if val >= 0 then 1 else -1
        if sign != p.sign
            # 予測が間違っていた場合、値を更新(逐次学習)
            boundary.w[0] += p.sign * p.x
            boundary.w[1] += p.sign * p.y
            boundary.w[2] += p.sign * 1
            misses++

        counter++
        if counter == points_num
            if misses == 0
                # 間違いが無ければ学習終了
                finish = true
            counter = 0

    draw = ->
        ctx.clearRect(0, 0, width, height)
        boundary.draw()
        $('#w_param').text("w = (#{boundary.w[0]}, #{boundary.w[1]}, #{boundary.w[2]})")

    cycle = ->
        update()
        if finish then return
        draw()
        setTimeout(cycle, 1/fps)

    init()
    cycle()
