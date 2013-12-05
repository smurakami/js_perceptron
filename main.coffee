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

    # 範囲関連
    min_x = 0
    max_x = 0
    min_y = 0
    max_y = 0
    scale_x = width / (max_x - min_x)
    scale_y = height/ (max_y - min_y)

    # 描画速度
    fps = 0

    # その他変数群
    ans = null
    boundary = null
    points = null
    ans_w = null
    counter = 0
    finish = false
    points_num = 100
    to_get_params = false


    convert_x = (x) ->
        (x - min_x) * scale_x
    convert_y = (y) ->
        height - (y - min_y) * scale_y

    # 点の描画
    CanvasRenderingContext2D.prototype.drawPoint = (x, y, sign = 1, radius = 2) ->
        x = convert_x(x)
        y = convert_y(y)
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
        @moveTo(convert_x(a.x), convert_y(a.y))
        @lineTo(convert_x(b.x), convert_y(b.y))
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
            if b == 0 # y軸に平行な直線
                if a == 0 then return # 直線でない
                p0 = {x: -c/a, y: min_y}
                p1 = {x: -c/a, y: max_y}
            else
                p0 = {x: min_x, y: -(min_x * a + c)/b}
                p1 = {x: max_x, y: -(max_x * a + c)/b}
            if static_draw
                ctx_static.drawLine(p0, p1)
            else
                ctx.drawLine(p0, p1)

    # ボタンのクリックイベントの受け取り
    $("input:button").click ->
        if finish
            get_params()
            init()
            cycle()
        else
            finish = true
            to_get_params = true

    # フォームの値の取得
    get_params = ->
        w_x = Number($('#form [name=w_x]').val())
        w_y = Number($('#form [name=w_y]').val())
        w_z = Number($('#form [name=w_z]').val())
        ans_w = [w_x, w_y, w_z]
        points_num = Number($('#form [name=points_num]').val())
        min_x = Number($('#form [name=min_x]').val())
        max_x = Number($('#form [name=max_x]').val())
        min_y = Number($('#form [name=min_y]').val())
        max_y = Number($('#form [name=max_y]').val())
        scale_x = width / (max_x - min_x)
        scale_y = height/ (max_y - min_y)
        fps = Number($('#form [name=fps]').val())

    # 初期化
    init = ->
        ans = new Classifier(ans_w)
        boundary = new Classifier() # 学習するパラメータ

        # 点の生成
        points = (new Point(min_x + (max_x - min_x) * m.random(), min_y + (max_y - min_y) * m.random()) for i in [0...points_num])

        for p in points
            p.set_val(ans.calc(p))

        counter = 0
        finish  = false
        to_get_params = false

        # 静的画像の描画
        ctx_static.clearRect(0, 0, width, height)
        # 点の描画
        for p in points
            p.draw(true)

        # 軸の描画
        x0 = {x: min_x, y: 0}
        x1 = {x: max_x, y: 0}
        ctx_static.drawLine(x0, x1)
        y0 = {x: 0, y: min_y}
        y1 = {x: 0, y: max_y}
        ctx_static.drawLine(y0, y1)

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
        $('#w_param').text("w = (#{boundary.w[0]}, #{boundary.w[1]}, #{boundary.w[2]})").val()

    cycle = ->
        update()
        draw()
        if finish
            if(to_get_params)
                get_params()
                init()
                cycle()
            return
        setTimeout(cycle, 1/fps)

    get_params()
    init()
    cycle()
