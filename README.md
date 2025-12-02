# 🏎️ Motorsport IT Operations Toolkit

![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue?logo=powershell&logoColor=white)
![Python](https://img.shields.io/badge/Python-3.10%2B-yellow?logo=python&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Windows-0078D6?logo=windows&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green)

## 📋 Overview
A suite of automation tools engineered for high-performance **Driver-in-the-Loop (DiL)** simulation environments. 

In motorsports, downtime is not an option. This toolkit was designed to address three critical operational challenges:
1.  **Proactive Health Monitoring:** Ensuring simulators are "Race Ready" before a driver sits down.
2.  **Data Integrity:** Securing high-value telemetry data with cryptographic verification.
3.  **Disaster Recovery:** Reducing system reset times from minutes to seconds during live sessions.

## 🛠️ The Toolkit

### 1. 🟢 "Race Ready" Health Monitor (`RaceReadyCheck.ps1`)
**The Problem:** Simulators rely on specific background services (Print Spooler, Audio, Network) that occasionally fail silently, causing delays.
**The Solution:** A self-healing PowerShell script that runs a pre-flight check on system resources.
* **Features:**
    * Verifies critical Windows Services status.
    * **Auto-Healing:** Detects stopped services and forces a restart automatically.
    * Checks network latency to the telemetry server (Green/Yellow/Red thresholds).
    * **Integration:** Triggers a Python alert if a self-healing event occurs.

### 2. 🔒 Telemetry Data Archiver (`DataArchiver.ps1`)
**The Problem:** Moving gigabytes of telemetry logs manually risks data corruption or loss.
**The Solution:** A secure archival pipeline that verifies data before deletion.
* **Features:**
    * Calculates **SHA256 Cryptographic Hashes** of the source file.
    * Transfers data to the networked storage.
    * Calculates the hash of the *destination* file.
    * **Zero-Loss Guarantee:** Only deletes the local copy if the hashes match 100%.

### 3. 🚨 Disaster Recovery "Panic Button" (`PanicButton.ps1`)
**The Problem:** When simulation software freezes, manual troubleshooting via Task Manager is too slow for a live race session.
**The Solution:** A "One-Click" executable that instantly resets the environment.
* **Features:**
    * Force-terminates frozen simulation processes.
    * Clears corrupt temporary cache files that cause hangs.
    * Relaunches the application in a clean state in **<3 seconds**.

### 4. 🐍 Real-Time Alert Bridge (`alert.py`)
**The Function:** Connects the local PowerShell automation to the engineering team.
* **Usage:** Called by `RaceReadyCheck.ps1` when a critical fix is applied.
* **Output:** Sends a JSON payload to a Discord/Teams Webhook to notify engineers of the incident.

---

## 🚀 Usage

### Prerequisites
* Windows 10/11
* PowerShell 5.1 or Core
* Python 3.x (for alerting)

### Quick Start
1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/YOUR_USERNAME/Motorsport-IT-Ops-Toolkit.git](https://github.com/YOUR_USERNAME/Motorsport-IT-Ops-Toolkit.git)
    ```
2.  **Run the Health Check:**
    ```powershell
    .\RaceReadyCheck.ps1
    ```
3.  **Test the Panic Button:**
    * Right-click `PanicButton.ps1` -> Run with PowerShell.

---

## 👨‍💻 About Me
**Christian Fabbri** | IT Support Specialist
* **Focus:** Automation, Reliability Engineering, Motorsports Tech
* **Contact:** [LinkedIn](https://www.linkedin.com/in/christianfabbri)

*"In racing, to finish first, you must first finish."*
