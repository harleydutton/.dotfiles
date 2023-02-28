#this is for GNOME environments, specifically sway.

export QT_AUTO_SCREEN_SET_FACTOR=0
export QT_SCALE_FACTOR=2
export QT_FONT_DPI=96

gsettings set org.gnome.desktop.interface text-scaling-factor 2.0
chromium --high-dpi-support --force-device-scale-factor=1.5

# _xrandr
