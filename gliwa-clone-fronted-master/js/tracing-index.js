import GATT_COLORS from "./config/colors.js";

Math.concat_value = function (value, min, max) {
    return Math.min(Math.max(min, value), max);
};

var canvas = document.getElementById("canvas-root"),
    global_ctx = canvas.getContext("2d");

const GATT_TEXT_X_OFFSET = 20;
window.HOST_PREFIX = window.HOST_PREFIX ? window.HOST_PREFIX : "/";

function sec_to_text(sec_now) {
    const ms_sec_now = Math.floor(sec_now / 1e5),
        us_sec_resident = Math.floor(sec_now / 1e2) - ms_sec_now * 1e3;

    return `${ms_sec_now}ms` + (us_sec_resident ? `${us_sec_resident}us` : "");
}

function draw_x_line(ctx, pos_x, pos_y, x_len, line_width = 0.5, line_dash = []) {
    ctx.strokeStyle = GATT_COLORS.line_color;
    ctx.lineWidth = line_width;
    ctx.setLineDash(line_dash);
    ctx.beginPath();
    ctx.moveTo(pos_x, pos_y);
    ctx.lineTo(pos_x + x_len, pos_y);
    ctx.stroke();
}

function draw_y_line(ctx, pos_x, pos_y, y_len, line_width = 0.5, line_dash = [], color = null) {
    ctx.strokeStyle = color ? color : GATT_COLORS.line_color;
    ctx.lineWidth = line_width;
    ctx.setLineDash(line_dash);
    ctx.beginPath();
    ctx.moveTo(pos_x, pos_y);
    ctx.lineTo(pos_x, pos_y + y_len);
    ctx.stroke();
}

function draw_gatt_line(ctx, title, pos_x, pos_y, x_len, y_len, bar_list, bar_sec_range) {
    // 绘制横轴线。pos_y 就是中轴线的纵向坐标
    draw_x_line(ctx, pos_x, pos_y, x_len);
    // 时间色块
    const sec_x_ratio = x_len / (bar_sec_range[1] - bar_sec_range[0]);
    bar_list.forEach((bar) => {
        let [status, start, end] = bar;
        if (start >= bar_sec_range[1] || end <= bar_sec_range[0]) {
            return null;
        }
        start = Math.max(start, bar_sec_range[0]);
        end = Math.min(end, bar_sec_range[1]);
        ctx.fillStyle = GATT_COLORS.status_color_dict[status];
        ctx.fillRect(
            pos_x + sec_x_ratio * (start - bar_sec_range[0]),
            pos_y - y_len / 2,
            sec_x_ratio * (end - start),
            y_len
        );
    });
    // 名称
    ctx.fillStyle = "black";
    ctx.font = "12px bold serif";
    ctx.textBaseline = "bottom";
    ctx.fillText(title, pos_x + GATT_TEXT_X_OFFSET, pos_y - 3);
}

function draw_gatt_title(ctx, text, pos_x, pos_y, x_len, y_len) {
    // 背景色
    ctx.fillStyle = GATT_COLORS.title_background_color;
    ctx.fillRect(pos_x, pos_y, x_len, y_len);
    // 标题
    ctx.fillStyle = "black";
    ctx.font = "12px bold serif";
    ctx.textBaseline = "top";
    ctx.fillText(text, pos_x + GATT_TEXT_X_OFFSET, pos_y + 2);
    // 返回文字右侧边线中点的坐标
    return [pos_x + GATT_TEXT_X_OFFSET + ctx.measureText(text).width, pos_y + y_len / 2];
}

function draw_x_axis(ctx, pos_x, pos_y, x_len, y_len, sec_range) {
    // 顶部边线
    draw_x_line(ctx, pos_x, pos_y, x_len, 1);
    // 底边线
    draw_x_line(ctx, pos_x, pos_y + y_len, x_len, 1);
    // 10 个刻度（sec_range 的单位是 10ns）
    const sec_step = Math.floor((sec_range[1] - sec_range[0]) / 10),
        sec_x_ratio = x_len / (sec_range[1] - sec_range[0]);
    // 横轴刻度
    let sec_now = Math.ceil(sec_range[0] / sec_step) * sec_step,
        x_now = pos_x + (sec_now - sec_range[0]) * sec_x_ratio,
        x_max = Math.min(canvas.width, pos_x + (sec_range[1] - sec_range[0] - 0.5 * sec_step) * sec_x_ratio);
    while (x_now <= x_max) {
        // 竖向时间刻度
        draw_y_line(ctx, x_now, pos_y, y_len + 8, 0.5, [1, 1]);
        // 绘制刻度值，最小单位 us
        ctx.fillStyle = "black";
        ctx.font = "12px bold serif";
        ctx.textBaseline = "top";
        ctx.fillText(sec_to_text(sec_now), x_now + 5, pos_y + y_len + 5);
        //
        sec_now += sec_step;
        x_now += sec_step * sec_x_ratio;
    }
}

// gatt 图
class GattGraph {
    static LINE_INNER_HEIGHT = 10;
    static LINE_OUTER_HEIGHT = 25;

    constructor(ctx, core_id, bar_lists, pos_x, x_len, init_collapsed = false) {
        // params: data
        this.ctx = ctx;
        this.core_id = core_id;
        this.bar_lists = bar_lists;
        // params: position 信息
        this.pos_x = pos_x;
        this.x_len = x_len;
        // params: 折叠初始状态
        this.is_collapsed = init_collapsed;
        //
        this.collapse_button = this.__init_collapse_button();
    }

    /**
     * private
     */

    __init_collapse_button() {
        const that = this;
        // 创建按钮
        const button = document.createElement("button");
        button.classList.add("collapse-button");
        canvas.parentNode.appendChild(button);
        // 事件
        button.addEventListener("click", function () {
            that.is_collapsed = !that.is_collapsed;
            canvas.dispatchEvent(new Event("gatt_collapse_changed"));
        });
        return button;
    }

    /**
     * protected
     */

    _collapse_draw(pos_y) {
        // 绘制标题
        draw_gatt_title(
            this.ctx,
            `Core${this.core_id}`,
            this.pos_x,
            pos_y,
            this.x_len,
            GattGraph.LINE_INNER_HEIGHT + 4
        );
        // 重置按钮
        this.collapse_button.style.left = `${GATT_TEXT_X_OFFSET - 16}px`;
        this.collapse_button.style.top = `${pos_y + GattGraph.LINE_INNER_HEIGHT / 2 - 5}px`;
        this.collapse_button.innerText = this.is_collapsed ? "+" : "-";
        // 总高度
        return 4 + 2 * GattGraph.LINE_INNER_HEIGHT;
    }

    _expand_draw(pos_y, start_sec, end_sec) {
        const that = this;
        // 绘制标题
        this._collapse_draw(pos_y);
        // 绘制 gatt 时间条
        let line_count = 0,
            sum_height = 4 + GattGraph.LINE_INNER_HEIGHT + 0.5 * GattGraph.LINE_OUTER_HEIGHT;
        Object.keys(that.bar_lists).forEach((thread_id) => {
            const bar_list = that.bar_lists[thread_id];
            draw_gatt_line(
                that.ctx,
                CONFIG["threads"][thread_id]["threadname"],
                that.pos_x,
                pos_y + sum_height + (0.5 + line_count) * GattGraph.LINE_OUTER_HEIGHT,
                that.x_len,
                GattGraph.LINE_INNER_HEIGHT,
                bar_list,
                [start_sec, end_sec]
            );
            line_count += 1;
        });
        // 总高度
        sum_height += (1 + line_count) * GattGraph.LINE_OUTER_HEIGHT;
        return sum_height;
    }

    /**
     * public: 重新绘制
     */

    draw(pos_y, start_sec, end_sec) {
        return this.is_collapsed ? this._collapse_draw(pos_y) : this._expand_draw(pos_y, start_sec, end_sec);
    }

    destroy() {
        this.collapse_button.parentNode.removeChild(this.collapse_button);
    }

    /**
     * public: 计算
     */

    calc_height() {
        return this.is_collapsed
            ? 4 + 2 * GattGraph.LINE_INNER_HEIGHT
            : 4 +
                  GattGraph.LINE_INNER_HEIGHT +
                  (1.5 + Object.keys(this.bar_lists).length) * GattGraph.LINE_OUTER_HEIGHT;
    }
}

// 缩放等级: [100us ~ 30s]
const SEC_WINDOW_RANGE = [100 * 1e2, 1 * 1e8],
    SEC_BOUNDS = [0, 5 * 1e8],
    MAX_RATIO_LEVELS = 50,
    RATIO_BASE = Math.pow(SEC_WINDOW_RANGE[1] / SEC_WINDOW_RANGE[0], 1 / MAX_RATIO_LEVELS);

const CANVAS_INNER_TOP = 30,
    CANVAS_INNER_LEFT = 0,
    CANVAS_INNER_WIDTH = canvas.width;

const MAX_EXPAND_COUNT = -1;

class GattPositionScaleController {
    constructor(data) {
        this.data = data;
        // offscreen canvas, 用于缓存绘制结果，降低高频 mousemove 事件重绘造成的开销
        this.offscreen_canvas = this.__init_offscreen_canvas();
        this.offscreen_ctx = this.offscreen_canvas.getContext("2d");
        // 多个 Gatt 时间图绘制器
        this.gatt_graphs = this.__init_gatt_graphs();
        // [start_sec, end_sec], 单位 10ns
        this.sec_window = [0, 0];
        // 缩放倍率，直接决定了当前显示的时间窗口长度。0 <= int(this.scale_level) <= MAX_RATIO_LEVELS
        this.scale_level = 0;
        // 记录鼠标位置: (x, y); 缩放时，以其为中心点重新计算时间窗口
        this.focus_pos = [0, 0];
        //
        this.position_controller = this.__init_position_controller();
        this.__bind_events();
    }

    __init_gatt_graphs() {
        const result = [],
            that = this;
        Object.keys(this.data).forEach((core_id, i) => {
            result.push(
                new GattGraph(
                    that.offscreen_ctx,
                    core_id,
                    that.data[core_id],
                    CANVAS_INNER_LEFT,
                    CANVAS_INNER_WIDTH,
                    MAX_EXPAND_COUNT >= 0 && i >= MAX_EXPAND_COUNT
                )
            );
        });
        return result;
    }

    __init_offscreen_canvas() {
        const result = document.createElement("canvas");
        result.width = canvas.width;
        result.height = canvas.height;
        return result;
    }

    __init_position_controller() {
        const that = this,
            result = document.querySelector("#canvas-position-controller");
        // DOM 初始化
        let last_position = null;
        rangeSlider.create(result, {
            min: 0,
            max: 100,
            step: 0.1,
            onSlide: function (_position, value) {
                const position = Math.round(value * 10000) / 100;
                if (position == last_position) {
                    return null;
                }
                last_position = position;
                that.position_to(position);
            },
        });
        return result;
    }

    __bind_events() {
        let last_focus_sec_text = null;
        const that = this;
        // 滚轮控制缩放等级
        canvas.addEventListener("mousewheel", function (event) {
            event.preventDefault();
            that.scale_to_level(that.scale_level + (event.wheelDelta < 0 ? +1 : -1) * 0.5);
        });
        // 鼠标当前位置，表示缩放中心
        canvas.addEventListener("mousemove", function (event) {
            const x = event.clientX - canvas.getBoundingClientRect().left,
                y = event.clientY - canvas.getBoundingClientRect().top;
            that.focus_pos = [x, y];
            // 如果鼠标位置描述信息不变，则不重绘
            const sec_text = sec_to_text(that.__x_to_sec(x));
            if (sec_text !== last_focus_sec_text) {
                that.draw(...that.sec_window, true);
            }
            last_focus_sec_text = sec_text;
        });
        // 鼠标离开画布
        canvas.addEventListener("mouseout", function (event) {
            if (that.focus_pos[0] === 0) {
                return null;
            }
            that.focus_pos = [0, 0];
            that.draw(...that.sec_window, true);
        });
        // 单个 core 的甘特图展开/收起，触发重绘
        canvas.addEventListener("gatt_collapse_changed", function () {
            that.draw(...that.sec_window);
        });
    }

    __x_to_sec(x) {
        const ratio = (this.sec_window[1] - this.sec_window[0]) / CANVAS_INNER_WIDTH;
        return (x - CANVAS_INNER_LEFT) * ratio + this.sec_window[0];
    }

    _reset_position_controller() {
        const window_len = this.sec_window[1] - this.sec_window[0],
            window_mid = (this.sec_window[1] + this.sec_window[0]) / 2,
            sec_bound_len = SEC_BOUNDS[1] - SEC_BOUNDS[0];
        // 窗口越长，中心点越接近 window_mid（越接近 this.sec_window[0/1]）；
        // 窗口越短，中心点越接近 window_mid；
        const x_center =
            window_mid <= (SEC_BOUNDS[0] + SEC_BOUNDS[1]) / 2
                ? window_mid - (window_len / 2) * (window_len / sec_bound_len)
                : window_mid + (window_len / 2) * (window_len / sec_bound_len);
        this.position_controller.rangeSlider.update({
            value: ((x_center - SEC_BOUNDS[0]) / sec_bound_len) * 100,
        });
    }

    _draw_focus_line(y_len) {
        // 是否超出范围
        if (this.focus_pos[0] <= CANVAS_INNER_LEFT || this.focus_pos[0] >= CANVAS_INNER_LEFT + CANVAS_INNER_WIDTH) {
            return null;
        }
        if (this.focus_pos[1] <= CANVAS_INNER_TOP || this.focus_pos[1] >= CANVAS_INNER_TOP + y_len) {
            return null;
        }
        // 绘制 focus 竖线
        draw_y_line(global_ctx, this.focus_pos[0], CANVAS_INNER_TOP, y_len, 1, [], GATT_COLORS.focus_line_color);
        // 标注鼠标当前位置
        const sec_now = this.__x_to_sec(this.focus_pos[0]),
            text_box_size = [60, 15];
        let pos_x = 0,
            pos_y = 0;
        if (
            CANVAS_INNER_LEFT + CANVAS_INNER_WIDTH - this.focus_pos[0] > text_box_size[0] &&
            this.focus_pos[1] - CANVAS_INNER_TOP > text_box_size[1]
        ) {
            // 在鼠标的右上角显示刻度值
            [pos_x, pos_y] = [this.focus_pos[0] + 5, this.focus_pos[1] - text_box_size[1]];
        } else {
            // 在鼠标的左侧显示刻度值
            [pos_x, pos_y] = [this.focus_pos[0] - text_box_size[0], this.focus_pos[1]];
        }
        global_ctx.fillStyle = "gray";
        global_ctx.font = "12px bold serif";
        global_ctx.textBaseline = "top";
        global_ctx.fillText(sec_to_text(sec_now), pos_x, pos_y);
    }

    _sync_position_button_width() {
        // 重设 position 控件宽度
        const handle_width =
            (this.position_controller.rangeSlider.range.offsetWidth * (this.sec_window[1] - this.sec_window[0])) /
            (SEC_BOUNDS[1] - SEC_BOUNDS[0]);
        if (handle_width > 20) {
            this.position_controller.rangeSlider.handle.style.width = `${handle_width}px`;
            this.position_controller.rangeSlider.update();
        }
    }

    /**
     * public
     */

    destroy() {
        this.gatt_graphs.forEach((x) => x.destroy());
        // 移除水平控制条
        this.position_controller.rangeSlider.destroy();
        // 重建 canvas 元素
        const new_canvas = canvas.cloneNode(true);
        canvas.parentNode.replaceChild(new_canvas, canvas);
        canvas = new_canvas;
        global_ctx = canvas.getContext("2d");
    }

    draw(start_sec, end_sec, use_cache = false) {
        this.sec_window = [start_sec, end_sec];
        let height = CANVAS_INNER_TOP;
        if (use_cache) {
            this.gatt_graphs.forEach((graph) => {
                height += graph.calc_height();
            });
        } else {
            // 绘制背景
            this.offscreen_ctx.fillStyle = GATT_COLORS.background_color;
            this.offscreen_ctx.fillRect(0, 0, canvas.width, canvas.height);
            // 绘制 gatt 图
            this.gatt_graphs.forEach((graph) => {
                height += graph.draw(height, ...this.sec_window);
            });
            // 绘制横轴坐标
            draw_x_axis(this.offscreen_ctx, CANVAS_INNER_LEFT, CANVAS_INNER_TOP, CANVAS_INNER_WIDTH, height, [
                start_sec,
                end_sec,
            ]);
        }
        // 复制 offscreen_canvas 的内容
        global_ctx.drawImage(this.offscreen_canvas, 0, 0);
        // 绘制缩放聚焦线
        this._draw_focus_line(height);
        // 重置水平控制按钮的垂直位置
        this.position_controller.rangeSlider.range.style.top = `${height + 70}px`;
    }

    draw_by_ms(start_ms, len_ms) {
        // 可视窗口
        let start_sec = start_ms * 1e-3 * 1e8,
            end_sec = start_sec + len_ms * 1e-3 * 1e8;
        this.sec_window = [start_sec, end_sec];
        // 计算水平滚动条位置
        this._reset_position_controller();
        // 计算当前放大倍率
        this.scale_level =
            Math.log((this.sec_window[1] - this.sec_window[0]) / SEC_WINDOW_RANGE[0]) / Math.log(RATIO_BASE);
        // 取消聚焦
        this.focus_pos = [0, 0];
        return this.draw(start_sec, end_sec);
    }

    scale_to_level(ratio_level) {
        // 0 <= int(ratio) <= MAX_RATIO_LEVELS
        this.scale_level = Math.concat_value(ratio_level, 0, MAX_RATIO_LEVELS);
        // 计算窗口边界
        const new_win_len = SEC_WINDOW_RANGE[0] * Math.pow(RATIO_BASE, this.scale_level),
            mid_sec = this.__x_to_sec(this.focus_pos[0]),
            mid_offset_ratio = (mid_sec - this.sec_window[0]) / (this.sec_window[1] - this.sec_window[0]);
        let start_sec = mid_sec - new_win_len * mid_offset_ratio,
            end_sec = mid_sec + new_win_len * (1 - mid_offset_ratio);
        // 窗口截断
        const concat_ratio = 0.5;
        if (start_sec < SEC_BOUNDS[0]) {
            end_sec = Math.min(SEC_BOUNDS[1], end_sec + (SEC_BOUNDS[0] - start_sec) * concat_ratio);
            start_sec = SEC_BOUNDS[0];
        }
        if (end_sec > SEC_BOUNDS[1]) {
            start_sec = Math.max(SEC_BOUNDS[0], start_sec - (end_sec - SEC_BOUNDS[1]) * concat_ratio);
            end_sec = SEC_BOUNDS[1];
        }
        // 重绘
        this.draw(start_sec, end_sec);
        this._sync_position_button_width();
    }

    position_to(position) {
        const window_len = this.sec_window[1] - this.sec_window[0],
            sec_bound_len = SEC_BOUNDS[1] - SEC_BOUNDS[0];
        // 0 <= position <= 100
        position = Math.concat_value(position, 0, 100);
        // position 可以看作被修正后的值，基于此反推中心点位置
        // 窗口越短，需要的修正越多
        let x_center = SEC_BOUNDS[0] + (position / 100) * sec_bound_len;
        x_center =
            position <= 50
                ? x_center + ((1 - window_len / sec_bound_len) * window_len) / 2
                : x_center - ((1 - window_len / sec_bound_len) * window_len) / 2;
        x_center = Math.concat_value(x_center, ...SEC_BOUNDS);
        // 窗口截断
        let start_sec = x_center - window_len / 2,
            end_sec = x_center + window_len / 2;
        if (start_sec < SEC_BOUNDS[0]) {
            start_sec = SEC_BOUNDS[0];
            end_sec = SEC_BOUNDS[0] + window_len;
        }
        if (end_sec > SEC_BOUNDS[1]) {
            start_sec = SEC_BOUNDS[1] - window_len;
            end_sec = SEC_BOUNDS[1];
        }
        // 重绘
        this.draw(start_sec, end_sec);
        this._sync_position_button_width();
    }
}


// ========== 初始化 ==========

new Switchery(document.querySelector(".js-switch"), {
    color: "#c9c614",
    secondaryColor: "#a3a4a5",
    jackColor: "#fffffe",
});

const GPSC = new GattPositionScaleController(GATT_EXPORT_DATA);
GPSC.draw_by_ms(0, 10);

window.GPSC = GPSC;


// ========== 事件绑定 ==========

document.querySelector(".tracing-container input[type='checkbox']").addEventListener("change", function () {
    const animation_div = document.querySelector(".tracing-container .loading-animation"),
        download_button = document.querySelector(".download-container button");
    if (this.checked) {
        console.log("tracing start");
        axios.get(`${window.HOST_PREFIX}tracing/start`).then(function (data) {
            console.log(data);
            // cycle 动画
            animation_div.classList.add("active");
            // 下载按钮
            download_button.classList.remove("disabled");
            download_button.classList.remove("twinkle");
        });
    } else {
        console.log("tracing end");
        axios.get(`${window.HOST_PREFIX}tracing/stop`).then(function (data) {
            console.log(data);
            // cycle 动画
            animation_div.classList.remove("active");
            // 下载按钮
            download_button.classList.add("twinkle");
        });
    }
});

document.querySelector(".download-container button").addEventListener("click", function () {
    const button = this,
        animation_div = document.querySelector(".download-container .loading-animation");
    if (button.classList.contains("disabled")) {
        return null;
    }
    console.log("-----download-----");
    // 加载动画
    button.classList.remove("twinkle");
    button.classList.add("disabled");
    button.classList.add("active");
    animation_div.classList.add("active"); //cycle 动画
    // 发送请求
    axios.get(`${window.HOST_PREFIX}tracing/download`).then(function (data) {
        console.log("destroy");
        window.GPSC.destroy();
        console.log("build");
        const GPSC = new GattPositionScaleController(data.data);
        console.log("draw");
        GPSC.draw_by_ms(0, 5);
        window.GPSC = GPSC;
        // 移除动画
        button.classList.remove("disabled");
        button.classList.remove("active");
        animation_div.classList.remove("active");
    });
});

export default GPSC;
