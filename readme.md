# 📦 local2world

一个用于本地开发静态资源远程访问的工具集脚本，结合 `serve` 启动本地服务器，并通过 Cloudflare Tunnel 暴露公网地址，支持启动、停止、清理操作。

---

## 🚀 功能说明

- `start.sh`: 启动静态资源服务器并自动开启 Cloudflare Tunnel，打印公网访问地址，并自动复制到剪贴板。
- `stop.sh`: 停止所有已启动的本地服务（包括 serve 和 cloudflared）。
- `clear.sh`: 清理缓存 PID 文件，避免下次启动失败（含用户确认步骤）。

---

## 📦 安装依赖

确保已安装以下依赖工具：

- `node` 和 `npm`
- `npx`（随 npm 安装）
- [`serve`](https://github.com/vercel/serve)
- [`cloudflared`](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install/)

可使用如下命令安装：

```bash
npm install -g serve
brew install cloudflared
```

---

## 🛠 使用说明

### 启动服务

```bash
./start.sh --port 8080 --static /path/to/dist
```

- `--port` 或 `-p`：指定本地静态服务器端口，默认 `2222`
- `--static` 或 `-s`：指定静态资源文件夹路径，默认 `~/dist`

启动后将自动输出 Cloudflare 公网地址，并复制到剪贴板。

### 停止服务

```bash
./stop.sh
```

将自动根据 PID 文件停止 `serve` 和 `cloudflared`。

### 清除缓存

```bash
./clear.sh
```

⚠️ 该操作会清除 PID 文件，适用于异常关闭或服务无法重启的情况。包含用户确认提示。

---

## 📁 项目结构

```bash
.
├── start.sh      # 启动本地服务器 + Cloudflare Tunnel
├── stop.sh       # 停止所有后台服务
├── clear.sh      # 清理缓存 PID 文件
```

---

## 💡 注意事项

- 脚本使用 `lsof` 检查端口是否被占用。
- 日志文件默认输出至 `/tmp` 目录。
- 启动失败通常是因为已有服务未正确关闭或依赖未安装，可先执行 `stop.sh` 或 `clear.sh`。

# 📦 local2world

A toolkit script for remote access to locally developed static resources, combined with `serve` to start a local server and expose a public address via Cloudflare Tunnel, supporting start, stop, and clear operations.

---

## 🚀 Function Description

-  `start.sh`: Starts the static resource server and automatically opens the Cloudflare Tunnel, prints the public access address, and automatically copies it to the clipboard.
-  `stop.sh`: Stops all started local services (including serve and cloudflared).
-  `clear.sh`: Clears cached PID files to avoid startup failures next time (includes user confirmation steps).

---

## 📦 Install Dependencies

Ensure the following dependency tools are installed:

-  `node` and `npm`
-  `npx` (installed with npm)
-  [`serve`](https://github.com/vercel/serve)
-  [`cloudflared`](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install/)

You can install them using the following commands:

```bash
npm install -g serve
brew install cloudflared
```

---

## 🛠 Usage Instructions

### Start Service

```bash
./start.sh --port 8080 --static /path/to/dist
```

-  `--port` or `-p`: Specify the local static server port, default is `2222`
-  `--static` or `-s`: Specify the path to the static resource folder, default is `~/dist`

After starting, the Cloudflare public address will be automatically output and copied to the clipboard.

### Stop Service

```bash
./stop.sh
```

Will automatically stop `serve` and `cloudflared` based on the PID file.

### Clear Cache

```bash
./clear.sh
```

⚠️ This operation will clear PID files, suitable for situations where services cannot restart due to abnormal shutdowns. Includes user confirmation prompt.

---

## 📁 Project Structure

```bash
.
├── start.sh      # Start local server + Cloudflare Tunnel
├── stop.sh       # Stop all background services
├── clear.sh      # Clear cached PID files
```

---

## 💡 Notes

-  The script uses `lsof` to check if the port is occupied.
-  Log files are output to the `/tmp` directory by default.
-  Startup failures are usually due to services not being properly closed or dependencies not being installed. You can first execute `stop.sh` or `clear.sh`.
