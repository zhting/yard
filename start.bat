@echo off
chcp 65001 >nul
rem 小院时光 · Windows 一键启动：本地起服务 + 用显卡加速打开
rem 双击 index.html 时浏览器不让页面读取本地模型文件，所以要走本地服务
cd /d "%~dp0"
set PORT=8080
where python >nul 2>nul && (start "" /min python -m http.server %PORT%) || (start "" /min py -m http.server %PORT%)
timeout /t 1 >nul
set URL=http://localhost:%PORT%/
rem 优先 Chrome，其次 Edge；参数强制启用 GPU（忽略显卡黑名单）并优先独立显卡
set CHROME="%ProgramFiles%\Google\Chrome\Application\chrome.exe"
if not exist %CHROME% set CHROME="%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe"
if not exist %CHROME% set CHROME="%LocalAppData%\Google\Chrome\Application\chrome.exe"
if exist %CHROME% (
  start "" %CHROME% --ignore-gpu-blocklist --enable-gpu-rasterization --force_high_performance_gpu --new-window %URL%
) else (
  start "" msedge --ignore-gpu-blocklist --enable-gpu-rasterization --force_high_performance_gpu --new-window %URL%
)
