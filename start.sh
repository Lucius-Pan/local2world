#!/bin/bash

set -euo pipefail


# ─────────────── 参数解析 ───────────────
PORT=2222   # 默认值
DIST_DIR="$HOME/dist" # 默认静态资源目录
show_help() {
  cat <<EOF
Usage: $0 [--port|-p <PORT>] [--static|-s <STATIC_DIR>] 

Options:
  -p, --port   指定静态文件服务器监听端口（默认 2222）
  -s, --static 指定静态资源目录（默认 ~/dist）
  -h, --help   查看帮助
EOF
  exit 0
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -p|--port)
      [[ $# -lt 2 ]] && { echo "❌ 缺少端口号！"; exit 1; }
      PORT="$2"
      shift 2
      ;;
    -s|--static)
      [[ $# -lt 2 ]] && { echo "❌ 缺少静态目录路径！"; exit 1; }
      DIST_DIR="$2"
      shift 2
      ;;
    -h|--help) show_help ;;
    *) echo "❌ 未知参数: $1"; show_help ;;
  esac
done
# ─────────────── 参数解析结束 ───────────────
# === 前置依赖检查 ===
check_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "[缺失依赖] 未检测到命令: $1"
    echo "请先安装 $1 再运行本脚本。"
    missing_deps=true
  fi
}

missing_deps=false

# 在这里列出你所有需要检查的命令
check_command cloudflared
check_command node
check_command npm

if [ "$missing_deps" = true ]; then
  echo
  echo "[ERROR] 依赖检查未通过。请根据上方提示安装缺失的依赖。"
  exit 1
else
  echo "[INFO] 所有依赖项已安装，继续执行脚本..."
fi

if [ -f /tmp/serve.pid ] && [ -s /tmp/serve.pid ]; then
  echo "[Warning] 文件服务器已经打开，请关闭后再试" 
  exit 1
fi

if [ -f /tmp/cloudflared.pid ] && [ -s /tmp/cloudflared.pid ]; then
  echo "[Warning] Cloudflare Tunnel 已经打开，请关闭后再试" 
  exit 1
fi

echo "[INFO] 静态资源目录: $DIST_DIR"
echo "[INFO] 使用端口: $PORT"

# 检查端口是否被占用
if lsof -iTCP:$PORT -sTCP:LISTEN -t >/dev/null ; then
  echo "❌ 端口 $PORT 已被占用，请换一个端口号"
  exit 1
fi

# 启动 serve（后台）
npx serve "$DIST_DIR" -l $PORT > /tmp/serve.log 2>&1 &
echo $! > /tmp/serve.pid   # ✅ 记录 serve 的 PID


# 保存 serve 的进程 ID
SERVE_PID=$!

# 等待 2 秒，确保 serve 启动
sleep 2

# 临时保存 cloudflared 日志
TMP_LOG="/tmp/cloudflared.log"
rm -f "$TMP_LOG"

# 启动 cloudflared（后台）
cloudflared tunnel --url http://127.0.0.1:$PORT --protocol http2 > /tmp/cloudflared.log 2>&1 &
echo $! > /tmp/cloudflared.pid   # ✅ 记录 cloudflared 的 PID

# 保存 cloudflared 的进程 ID
CLOUDFLARED_PID=$!

# 等待 cloudflared 启动
sleep 5

# 提取公网地址
CLOUDFLARE_URL=$(grep -oE "https://[a-zA-Z0-9.-]+\.trycloudflare\.com" "$TMP_LOG" | head -n 1)

# 输出公网地址
if [ -n "$CLOUDFLARE_URL" ]; then
  echo ""
  echo "[INFO] 你的公网访问地址是："
  echo "[INFO] $CLOUDFLARE_URL"
  echo ""
  echo -n "$CLOUDFLARE_URL" | pbcopy
  echo "[INFO] 已自动复制到剪贴板！"
else
  echo "[ERROR] 未能获取 Cloudflare 分配的公网地址，请检查 cloudflared 是否正常运行。"
fi

# 显示运行中的进程信息
echo ""
echo "[INFO] 正在后台运行的服务："
echo "- serve PID: $SERVE_PID"
echo "- cloudflared PID: $CLOUDFLARED_PID"
echo ""
echo "（若要停止服务，可以使用stop_tonow.sh 或者 手动使用kill 命令终止进程）"

# 脚本正常结束，不锁死终端
exit 0