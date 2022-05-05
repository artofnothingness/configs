curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
export PATH=$PATH:~/.local/bin:~/.cargo/bin

rustup update

cargo install --locked yazi-fm yazi-cli
