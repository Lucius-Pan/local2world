# 停止 serve（如果 PID 文件存在且不为空）
if [ -f /tmp/serve.pid ] && [ -s /tmp/serve.pid ]; then
  SERVE_PID=$(cat /tmp/serve.pid | tr -cd '[:digit:]')
  if [ -n "$SERVE_PID" ]; then
    echo "[INFO] 正在停止 serve (PID: $SERVE_PID)"
    kill "$SERVE_PID" && rm /tmp/serve.pid
  else
    echo "[INFO]  serve PID 文件存在但无效（内容为空或非数字）"
  fi
else
  echo "[INFO] 找不到 serve PID 文件或文件为空，可能已停止。"
fi

# 停止 cloudflared（如果 PID 文件存在且不为空）
if [ -f /tmp/cloudflared.pid ] && [ -s /tmp/cloudflared.pid ]; then
  CLOUDFLARED_PID=$(cat /tmp/cloudflared.pid | tr -cd '[:digit:]')
  if [ -n "$CLOUDFLARED_PID" ]; then
    echo "[INFO] 正在停止 cloudflared (PID: $CLOUDFLARED_PID)"
    kill "$CLOUDFLARED_PID" && rm /tmp/cloudflared.pid
  else
    echo "[INFO]  cloudflared PID 文件存在但无效（内容为空或非数字）"
  fi
else
  echo "[INFO] 找不到 cloudflared PID 文件或文件为空，可能已停止。"
fi

echo "[INFO] 所有后台服务已尝试停止完毕。"