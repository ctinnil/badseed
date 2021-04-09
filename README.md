# BaDSeeD

BaD SeeD is a macOS **framework** for **digital forensics** and **penetration testing**.

![logo_v1](https://user-images.githubusercontent.com/69745175/114140343-ce0aa100-9918-11eb-8767-b0e97e68b5a0.jpg)

<p align="center">
  <a href="https://github.com/ctinnil/badseed/blob/master/LICENSE">
      <img src="https://img.shields.io/github/license/ctinnil/badseed" alt="License">
  </a>
  <a href="https://github.com/ctinnil/badseed/issues">
    <img src="https://img.shields.io/github/issues/ctinnil/badseed" alt="Issues">
  </a>
  <a href="https://github.com/ctinnil/badseed/pulls">
      <img src="https://img.shields.io/badge/contributions-welcome-brightgreen" alt="Contributing">
  </a>
  <a href="https://www.apple.com/macos/big-sur/">
      <img src="https://img.shields.io/badge/OS-macOS-brightgreen" alt="OS">
  </a>
  <a href="https://twitter.com/intent/tweet?text=BaD+SeeD+-+macOS+framework+to+improve+your+purple+teaming&amp;url=https%3A%2F%2Fgithub.com%2Fctinnil%2Fbadseed.git&amp;via=ctinnil">
      <img src="https://img.shields.io/twitter/url?url=https%3A%2F%2Fgithub.com%2Fctinnil%2Fbadseed.git" alt="Tweet">
  </a>
</p>

---

The project relies on open-source and commercial tools used in the industry that are maintained by their authors. To summarise, BadSeed offers a full portable laboratory for all kinds of cybersecurity operations, ranging from pentesting to digital forensics and reverse engineering. Still, it also includes everything needed to develop your software or keep your data secure.

It organizes the tools following the [Cyber Kill Chain®](https://www.lockheedmartin.com/en-us/capabilities/cyber/cyber-kill-chain.html) framework developed by Lockheed Martin. The model highlights the main action taken by an attacker (whitehat or otherwise), to compromise an IT infrastructure. The seven steps of CKC can enhance understanding of the adversary’s tactics, techniques, and procedures, enriching the capabilities of both blue and red teams.

![ckc](https://user-images.githubusercontent.com/69745175/114143730-2cd21980-991d-11eb-9875-9d8b1e1f4cec.jpg)

This project is a work-in-progress, so feel free to contribute and suggest new tools that can be added. 

Requirements 
-----
To diminish the time of run and the probability of failure, we recommend updating your macOS and tools before running the installation. 

**Comment or delete any configurations that you consider unnecessary or just run the bootstrapping script.**

These requirements are for the computer running the core framework:
* macOS Catalina `10.15` or higher
* Support for hypervisor applications (like [Docker](https://docs.docker.com/docker-for-mac/install/))
* Recommended hardware to run on is 4GB+ RAM, 150GB+ HDD and 2+ CPUs
* Some installs require that you are signed in with your AppleID

Installation 
-----
Simply copy and paste the following in a terminal:
```
zsh <(curl -s https://raw.githubusercontent.com/ctinnil/badseed/master/badseed_conf.sh)
```

To import few useful bookmarks 
----
1. Open **Safari**
2. Select **File**
3. Select **Import From** (or **Import Bookmarks...** )
4. Choose to import **Useful Bookmarks.html**

<img width="606" alt="how to import bookmarks" src="https://user-images.githubusercontent.com/69745175/114000179-6e05f300-9863-11eb-9064-a4b426daf862.png">

### Disclaimer 

***All the tools included may only be used with proper authorization backed-up by a Rules of Engagement (RoE) agreement or for educational purposes in laboratories and virtual environments. Performing hack attempts on computers that you do not own, without written permission from owners, is illegal. The information contained in this repository should only be used to enhance the security of your IT infrastructure and not to conduct malicious or damaging attacks. You should not misuse this information to gain unauthorized access to computer systems. I will not be responsible for any direct or indirect damage caused due to the misusage of the provided framework.***

### Thanks to Homebrew developers and contributors !!!
@https://github.com/Homebrew/brew.git

Some configurations have been inspired from various places on the web, as:
- https://gist.github.com/brandonb927/3195465
- https://gist.github.com/codeinthehole/26b37efa67041e1307db

Check them out yourself!
