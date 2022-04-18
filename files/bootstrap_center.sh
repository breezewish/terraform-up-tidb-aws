# This script is executed on the center server

# install tiup
curl --proto '=https' --tlsv1.2 -sSf https://tiup-mirrors.pingcap.com/install.sh | sh

# install haproxy
sudo apt install -y haproxy mysql-client
sudo cp ~/haproxy.cfg /etc/haproxy/haproxy.cfg
sudo systemctl restart haproxy

# prepare go-tpc
sudo snap install go --classic
git clone https://github.com/pingcap/go-tpc
cd go-tpc
make build
cd ..
