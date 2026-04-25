# 📊 StaticPi
**A Sleek, High-Performance Infrastructure Monitoring Dashboard for Pterodactyl Nodes.**

StaticPi is a lightweight, real-time status page designed for hosting providers. It connects directly to the Pterodactyl Application API to display node health, memory allocation, and disk usage with a modern, glassmorphism aesthetic.

---

## ✨ Features
* **Real-time Monitoring:** Fetches live data from the Pterodactyl Panel API.
* **Modern UI:** Built with Tailwind CSS and Framer Motion for smooth entrance animations.
* **Glassmorphism Design:** Dark-mode optimized with frosted glass effects and status glows.
* **Resource Visualization:** Dynamic progress bars for Memory and Disk allocation.
* **Mobile Responsive:** Fully optimized for viewing on phones, tablets, and desktops.

---

## 🛠️ Installation

### 1. Fast Setup (Recommended)
Use the automated setup script to build the environment:
\`\`\`bash
chmod +x setup.sh
./setup.sh
\`\`\`

### 2. Manual Installation
If you prefer to set it up manually:
\`\`\`bash
# Create directory
mkdir staticpi && cd staticpi

# Install dependencies
npm install express axios dotenv

# Create app.js and .env files
# (Copy code from your project files)
\`\`\`

---

## ⚙️ Configuration
Edit the \`.env\` file in the root directory to connect your panel:

\`\`\`env
PORT=3000
PANEL_URL=https://your-panel-link.com
API_KEY=ptla_your_application_api_key_here
SITE_NAME=StaticPi
\`\`\`

> **Note:** Ensure your API Key has **Read** permissions for **Nodes**.

---

## 🚀 Deployment
To keep StaticPi running 24/7 on your VPS, it is recommended to use **PM2**:

\`\`\`bash
# Install PM2
npm install pm2 -g

# Start StaticPi
pm2 start app.js --name "StaticPi"

# Ensure it starts on reboot
pm2 save
pm2 startup
\`\`\`

---

## 🎨 Credits
* **Developer:** Coral (@CoralGuides)
* **Infrastructure:** ShardHost / Eaglix
* **Powered by:** Pterodactyl Panel API
