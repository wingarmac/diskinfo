# Netinfo - Network Reporting Tool

`netinfo` is a simple Bash script designed to quickly generate a detailed report on a Linux system's network configuration. It gathers essential information for troubleshooting or simply checking your setup.

## Features

- **IP Addresses:** Displays IPv4 and IPv6 addresses for all network interfaces.
- **Routing Tables:** Presents both IPv4 and IPv6 routing tables.
- **DNS Servers:** Extracts configured DNS servers using `systemd-resolved`.
- **Firewall Status:** Detects and displays firewall rules, whether using **iptables** or **nftables**.
- **Exporting:** Allows you to export the report to a local text file or share it via a temporary link using `termbin.com`.

## Installation

To install the script and make it available as a system-wide command, follow these steps:

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/wingarmac/netinfo](https://github.com/wingarmac/netinfo)
    ```
    This will download the project files into a new directory named `netinfo`.

2.  **Move the script to a system directory:**
    ```bash
    sudo mv netinfo/netinfo.sh /usr/local/bin/netinfo
    ```
    *Note: The `.sh` extension is removed to allow for a cleaner command name.*

3.  **Make the script executable:**
    ```bash
    sudo chmod +x /usr/local/bin/netinfo
    ```

4.  **(Optional) Change the owner to root to prevent unauthorized modifications:**
    ```bash
    sudo chown root:root /usr/local/bin/netinfo
    ```
    *After installation, you can safely delete the `netinfo` directory you cloned.*

## Usage

Once installed, you can use the `netinfo` command directly from any directory.

-   **Standard Report:**
    ```bash
    netinfo
    ```
    Generates and displays the report directly in your terminal.

-   **Export to Text File:**
    ```bash
    netinfo txt
    ```
    Creates a file named `netinfo-[DATE]_[TIME].txt` in the current directory.

-   **Share via a Temporary Link:**
    ```bash
    netinfo nc
    ```
    This command uses `netcat` to send the report to `termbin.com`, which returns a shareable URL. This option requires the `netcat-openbsd` package.

## Dependencies

-   `iproute2` (usually pre-installed on most distributions)
-   `journalctl` (for DNS information)
-   `iptables` or `nftables` (depending on your system)
-   `netcat-openbsd`: This package is required only for the `netinfo nc` command. The script will attempt to install it automatically if you use this option.
