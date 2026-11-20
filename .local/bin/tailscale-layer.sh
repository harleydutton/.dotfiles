sudo curl -o /etc/yum.repos.d/tailscale.repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo
sudo rpm-ostree install tailscale
echo "reboot for changes to take effect then run tailscale-enable.sh"
