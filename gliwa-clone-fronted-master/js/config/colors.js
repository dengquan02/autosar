const GATT_COLORS = {
    // 全局背景色
    background_color: "#f3f3f3",
    // 刻度线颜色
    line_color: "#b8b8b8",
    // 时间线，不同状态的颜色
    status_color_dict: {
        RUNNING: "#888600",
        WAITING: "#bf8040",
        READY: "#c8db00",
    },
    // 标识鼠标位置所在的聚焦线颜色
    focus_line_color: "#24c4fa",
    // gatt 标题背景颜色（每个 core 的名称）
    title_background_color: "rgba(223, 225, 83, 0.5)",
};

export default GATT_COLORS;
