<h1 align="left" id="title">ip-watchdog </h1>

<p id="description">
<strong>ip-watchdog</strong> continuously monitors your machine's <strong>public IP address</strong> and sends an <strong>email alert</strong> whenever it changes.
This version includes redundancy by checking multiple public IP sources and allows easy configuration through a separate <code>config.sh</code> file.
</p>

<hr>

<h2>🧐 Features</h2>

<ul>
<li>Automatically monitors public IP changes.</li>
<li>Sends professional email alerts including:
    <ul>
        <li>Hostname</li>
        <li>Local IP</li>
        <li>Old and new public IP</li>
        <li>Timestamp</li>
    </ul>
</li>
<li>Checks multiple public IP sources for redundancy to avoid false alerts:
    <ul>
        <li>https://checkip.amazonaws.com</li>
        <li>https://icanhazip.com</li>
        <li>https://ip.me</li>
    </ul>
</li>
<li>Systemd service for automatic startup and logging.</li>
<li>Configurable check interval and email recipient via <code>config.sh</code>.</li>
<li>Scripts and configuration reside together in <code>/usr/local/bin/</code> for simplicity.</li>
</ul>

<hr>

<h2>🛠️ Installation Steps</h2>

<ol>
<li><strong>Clone the Repository</strong>
<pre><code>git clone https://gitlab.iiit.ac.in/netadmins/ip-watchdog.git
cd ip-watchdog
</code></pre>
</li>

<li><strong>Copy the Script and Config</strong>
<p>Copy both <code>ip_monitor.sh</code> and <code>config.sh</code> to <code>/usr/local/bin/</code> and make them executable:</p>
<pre><code>sudo cp scripts/ip_monitor.sh /usr/local/bin/ip_monitor.sh
sudo cp scripts/config.sh /usr/local/bin/config.sh
sudo chmod +x /usr/local/bin/ip_monitor.sh
sudo chmod +x /usr/local/bin/config.sh
</code></pre>
</li>

<li><strong>Copy the Systemd Service</strong>
<pre><code>sudo cp systemd/ip-monitor.service /etc/systemd/system/ip-monitor.service
</code></pre>
</li>

<li><strong>Enable and Start the Service</strong>
<pre><code>sudo systemctl daemon-reload
sudo systemctl enable ip-monitor.service
sudo systemctl start ip-monitor.service
</code></pre>
</li>

<li><strong>Check Service Status and Logs</strong>
<pre><code>sudo systemctl status ip-monitor.service
sudo journalctl -u ip-monitor.service -f
</code></pre>
</li>
</ol>

<hr>

<h2>⚙️ Configuration via <code>config.sh</code></h2>

<p>The <code>config.sh</code> file allows you to modify settings without touching the main script. Both scripts reside in <code>/usr/local/bin/</code>, and <code>ip_monitor.sh</code> automatically sources it:</p>

<pre><code>source "$(dirname "${BASH_SOURCE[0]}")/config.sh"
</code></pre>

<p>Available settings in <code>config.sh</code>:</p>

<ul>
<li><strong>EMAIL_TO</strong>: recipient of the IP alert emails.</li>
<li><strong>CHECK_INTERVAL</strong>: how often to check for IP changes (in seconds).</li>
<li><strong>IP_SOURCES</strong>: array of public IP sources for redundancy.</li>
</ul>

<p>Example <code>config.sh</code>:</p>
<pre><code># Recipient email
EMAIL_TO="ankit.singh@iiit.ac.in"

# Time interval in seconds
CHECK_INTERVAL=60

# Multiple public IP sources
IP_SOURCES=(
    "https://checkip.amazonaws.com"
    "https://icanhazip.com"
    "https://ip.me"
)
</code></pre>

<hr>

<h2>💻 Built with</h2>

<ul>
<li>Bash scripting</li>
<li>Systemd</li>
<li>Sendmail</li>
</ul>

<hr>

<h2>📌 Notes</h2>

<ul>
<li>Ensure <code>sendmail</code> is installed and running on your system.</li>
<li>The script checks multiple public IP sources to reduce false alerts.</li>
<li>Systemd service automatically runs the script continuously according to the <code>CHECK_INTERVAL</code> in <code>config.sh</code>.</li>
<li>Both <code>ip_monitor.sh</code> and <code>config.sh</code> should reside in <code>/usr/local/bin/</code> for proper operation.</li>
</ul>

<hr>
