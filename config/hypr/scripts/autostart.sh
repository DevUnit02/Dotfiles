#!/bin/bash

# --- Entorno Wayland / Portal ---
export WAYLAND_DISPLAY 
export XDG_CURRENT_DESKTOP=Hyprland

# --- Authentication Agent ---
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

# --- Notifications ---
mako &

# --- Status bar --- 
waybar &

# --- Wallpaper ---
~/.config/hypr/scripts/wallpaper.sh &

# --- Clipboard ---
wl-paste --type text --watch cliphist store &

# --- Quickshell ---
quickshell &
