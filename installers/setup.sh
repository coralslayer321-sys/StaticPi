#!/bin/bash

# --- CORAL HACKER THEME HEADER ---
clear
echo -e "\e[1;32m"
echo "  ██████╗ ██████╗ ██████╗  █████╗ ██╗      ██████╗ ██╗   ██╗██╗██████╗ ███████╗"
echo " ██╔════╝██╔═══██╗██╔══██╗██╔══██╗██║     ██╔════╝ ██║   ██║██║██╔══██╗██╔════╝"
echo " ██║     ██║   ██║██████╔╝███████║██║     ██║  ███╗██║   ██║██║██║  ██║█████╗  "
echo " ██║     ██║   ██║██╔══██╗██╔══██║██║     ██║   ██║██║   ██║██║██║  ██║██╔══╝  "
echo " ╚██████╗╚██████╔╝██║  ██║██║  ██║███████╗╚██████╔╝╚██████╔╝██║██████╔╝███████╗"
echo "  ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝ ╚═════╝  ╚═════╝ ╚═╝╚═════╝ ╚══════╝"
echo -e "\e[1;34m              >>> INFRASTRUCTURE STATUS DEPLOYER V1.1 <<< \e[0m"
echo -e "\e[1;30m                    [ Coded for @CoralGuides ] \e[0m"
echo -e "\e[1;30m                    [ FIx: Over-Allocation Bar ] \e[0m"
echo ""

# 1. Environment Preparation
echo -e "\e[1;33m[+]\e[0m Creating Project Directory: \e[1;32mstaticpi\e[0m"
mkdir -p staticpi
cd staticpi

# 2. Dependency Installation
echo -e "\e[1;33m[+]\e[0m Initializing Node.js Environment..."
npm init -y > /dev/null
npm install express axios dotenv > /dev/null

echo -e "\e[1;33m[+]\e[0m Installing \e[1;36mPM2\e[0m Globally..."
sudo npm install pm2 -g > /dev/null

# 3. Cloudflare Tunnel Installation
echo -e "\e[1;33m[+]\e[0m Installing \e[1;38;5;208mCloudflare Tunnel\e[0m..."
if ! command -v cloudflared &> /dev/null; then
    curl -L --output cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb > /dev/null
    sudo dpkg -i cloudflared.deb > /dev/null
    rm cloudflared.deb
    echo -e "\e[1;32m    Done! Run 'cloudflared tunnel login' after setup.\e[0m"
else
    echo -e "\e[1;32m    Cloudflared already installed.\e[0m"
fi

# 4. Config Generation
echo -e "\e[1;33m[+]\e[0m Generating \e[1;32m.env\e[0m Template..."
cat <<EOF > .env
PORT=3000
PANEL_URL=https://your-panel-link.com
API_KEY=ptla_your_application_api_key_here
SITE_NAME=StaticPi
EOF

# 5. Core Application Logic (With Capped Progress Bars)
echo -e "\e[1;33m[+]\e[0m Generating UI with \e[1;35mFixed Allocation Bars\e[0m into \e[1;32mapp.js\e[0m..."
cat <<EOF > app.js
require('dotenv').config();
const express = require('express');
const axios = require('axios');
const app = express();

const PORT = process.env.PORT || 3000;
const PANEL_URL = process.env.PANEL_URL;
const API_KEY = process.env.API_KEY;
const SITE_NAME = process.env.SITE_NAME || "StaticPi";

// Fetch data from Pterodactyl API
async function getNodes() {
    try {
        const response = await axios.get(\`\${PANEL_URL}/api/application/nodes\`, {
            headers: {
                'Authorization': \`Bearer \${API_KEY}\`,
                'Accept': 'application/json'
            },
            timeout: 5000
        });
        return response.data.data;
    } catch (error) {
        return [];
    }
}

app.get('/', async (req, res) => {
    const nodes = await getNodes();

    // The entire HTML Template
    const html = \`
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>\${SITE_NAME} | Status</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            @import url('https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@300;500;700&display=swap');
            body { 
                background-color: #050505; 
                color: #e2e8f0; 
                font-family: 'Space Grotesk', sans-serif;
                background-image: radial-gradient(circle at 50% -20%, #1e293b 0%, #050505 80%);
            }
            .glass { 
                background: rgba(255, 255, 255, 0.03); 
                backdrop-filter: blur(12px); 
                border: 1px solid rgba(255, 255, 255, 0.05);
                opacity: 0; transform: translateY(20px);
            }
            .status-glow { box-shadow: 0 0 15px rgba(34, 197, 94, 0.4); }
            .progress-bg { background: rgba(255, 255, 255, 0.1); }
            .bar-glow { box-shadow: 0 0 10px rgba(59, 130, 246, 0.5); }
        </style>
    </head>
    <body class="min-h-screen p-4 md:p-12 text-gray-200">
        <div class="max-w-5xl mx-auto">
            <header class="flex flex-col md:flex-row justify-between items-center mb-16 gap-6">
                <div>
                    <h1 class="text-4xl font-bold bg-gradient-to-r from-white to-gray-500 bg-clip-text text-transparent tracking-tighter">
                        \${SITE_NAME}
                    </h1>
                    <p class="text-gray-500 text-sm mt-1">Infrastructure Real-time Monitoring</p>
                </div>
                <div class="glass px-6 py-3 rounded-2xl flex items-center gap-3 opacity-100 transform-none">
                    <div class="h-2 w-2 rounded-full bg-green-500 animate-pulse status-glow"></div>
                    <span class="text-sm font-medium">All Systems Operational</span>
                </div>
            </header>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6" id="nodes-grid">
                \${nodes.map((node, index) => {
                    const realMemPercent = Math.round((node.attributes.allocated_resources.memory / node.attributes.memory) * 100);
                    // FIX: Visual bar cannot exceed 100% and break alignment
                    const visualMemPercent = Math.min(realMemPercent, 100);
                    
                    return \`
                    <div class="glass p-8 rounded-3xl relative overflow-hidden group hover:bg-white/[0.05] transition-all duration-500">
                        <div class="flex justify-between items-start mb-8">
                            <div>
                                <h2 class="text-2xl font-bold text-white">\${node.attributes.name}</h2>
                                <p class="text-blue-400 font-mono text-xs uppercase tracking-widest mt-1">\${node.attributes.fqdn}</p>
                            </div>
                        </div>

                        <div class="space-y-6">
                            <div>
                                <div class="flex justify-between text-xs mb-2 text-gray-400 uppercase tracking-tighter">
                                    <span>Allocated Memory</span>
                                    <span>\${realMemPercent}%</span> </div>
                                <div class="w-full progress-bg rounded-full h-2">
                                    <div class="bg-gradient-to-r from-blue-600 to-blue-400 h-2 rounded-full bar-glow" style="width: \${visualMemPercent}%"></div>
                                </div>
                            </div>
                        </div>

                        <div class="mt-8 pt-6 border-t border-white/5 flex justify-between items-center text-[10px]">
                            <span class="text-gray-500 italic uppercase tracking-widest">Node ID: \${node.attributes.id}</span>
                            <span class="text-green-400 font-bold uppercase">Active</span>
                        </div>
                    </div>
                    \`;
                }).join('')}
            </div>

            <footer class="mt-20 flex flex-col items-center gap-4">
                <div class="h-px w-24 bg-gradient-to-r from-transparent via-gray-700 to-transparent"></div>
                <p class="text-gray-600 text-xs tracking-widest uppercase italic">
                    &copy; 2026 \${SITE_NAME} &bull; Infrastructure Monitoring
                </p>
            </footer>
        </div>

        <script>
            // Simple animation for cards on load
            const cards = document.querySelectorAll('.glass');
            cards.forEach((card, i) => {
                setTimeout(() => {
                    card.style.transition = 'all 0.6s cubic-bezier(0.22, 1, 0.36, 1)';
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, i * 150);
            });
        </script>
    </body>
    </html>
    \`;
    res.send(html);
});

app.listen(PORT, () => {
    console.log("StaticPi is running on port " + PORT);
});
EOF

# Final Instructions
echo -e "\e[1;32m"
echo "-------------------------------------------------------"
echo "🛠️  CORAL SYSTEM ACCESS GRANTED"
echo "🛠️  V1.1 DEPLOYED (Allocation Fix)"
echo "-------------------------------------------------------"
echo -e "\e[0m"
echo "1. \e[1;36mcd staticpi\e[0m"
echo "2. \e[1;36mnano .env\e[0m (Paste your Panel URL & ptla_ key)"
echo "3. \e[1;36mpm2 start app.js --name StaticPi\e[0m"
echo "4. \e[1;36mcloudflared tunnel login\e[0m (Go Public)"
echo ""
echo -e "\e[1;35mStay Coding, Coral.\e[0m"
