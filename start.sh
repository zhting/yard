#!/usr/bin/env bash
# 小院时光 · macOS / Linux 一键启动：本地起服务 + 用显卡加速打开
# 双击 index.html 时浏览器不让页面读取本地模型文件，所以要走本地服务
cd "$(dirname "$0")"
PORT="${PORT:-8080}"
URL="http://localhost:$PORT/"
python3 -m http.server "$PORT" >/dev/null 2>&1 &
SERVER=$!
trap 'kill $SERVER 2>/dev/null' EXIT
sleep 1
FLAGS=(--ignore-gpu-blocklist --enable-gpu-rasterization --force_high_performance_gpu --new-window)
if [[ "$OSTYPE" == darwin* ]]; then
  if [ -d "/Applications/Google Chrome.app" ]; then
    open -na "Google Chrome" --args "${FLAGS[@]}" "$URL"
  else
    open "$URL"
  fi
else
  for b in google-chrome google-chrome-stable chromium chromium-browser microsoft-edge; do
    if command -v "$b" >/dev/null; then "$b" "${FLAGS[@]}" "$URL" >/dev/null 2>&1 & break; fi
  done
fi
echo "小院已在 $URL 打开（按 Ctrl+C 结束）"
wait $SERVER
