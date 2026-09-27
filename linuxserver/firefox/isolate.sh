# 1. Automatically grab the bridge interface name
BRIDGE="br-$(sudo docker network inspect firefox_isolated_firefox -f '{{.Id}}' | cut -c 1-12)"

# 2. Allow established connections
sudo iptables -I DOCKER-USER -i "$BRIDGE" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# 3. Block private LAN subnets
for subnet in 192.168.0.0/16 10.0.0.0/8 172.16.0.0/12; do
    sudo iptables -I DOCKER-USER -i "$BRIDGE" -d "$subnet" -j DROP
done
