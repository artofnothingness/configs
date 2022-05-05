curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
export PATH=$PATH:~/.local/bin:~/.cargo/bin

rustup update

cargo install --locked --git https://github.com/sxyazi/yazi.git yazi-fm yazi-cli
