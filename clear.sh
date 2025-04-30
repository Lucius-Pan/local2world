read -p "[Warning]该操作有丢失服务器及隧道ID的风险是否继续操作？[y/n]: " choice
case "$choice" in
  y|Y )
    echo "正在执行..."
   # 删除 serve缓存（如果 PID 文件存在且不为空）
    if [ -f /tmp/serve.pid ] && [ -s /tmp/serve.pid ]; then
    rm /tmp/serve.pid
    else
    echo "[INFO] 找不到 serve PID 文件"
    fi

    if [ -f /tmp/cloudflared.pid ] && [ -s /tmp/cloudflared.pid ]; then
    rm /tmp/cloudflared.pid
    else
    echo "[INFO] 找不到 cloudflared PID 文件"
    fi

    echo "[INFO] 尝试清除缓存完成。"
    ;;
  n|N )
    echo "操作已取消。"
    exit 0
    ;;
  * )
    echo "无效输入，请输入 y 或 n。"
    exit 1
    ;;
esac

