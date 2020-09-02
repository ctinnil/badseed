# BaD SeeD

BaD SeeD is a macOS **framework** for **digital forensics** and **penetration testing**.

![BaD SeeD](https://github.com/ctinnil/badseed/blob/master/res/logo.001.png?raw=true)

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
  <a href="https://www.apple.com/macos/catalina/https://github.com/ctinnil/badseed/pulls">
      <img src="https://img.shields.io/badge/OS-macOS-brightgreen" alt="OS">
  </a>
  <a href="https://twitter.com/intent/tweet?text=BaD+SeeD+-+macOS+framework+to+improve+your+purple+teaming&amp;url=https%3A%2F%2Fgithub.com%2Fctinnil%2Fbadseed.gite&amp;via=ctinnil">
      <img src="https://img.shields.io/twitter/url?url=https%3A%2F%2Fgithub.com%2Fctinnil%2Fbadseed.git" alt="Tweet">
  </a>
</p>

---

The project relies on open-source and commercial tools used in the industry that are maintained by their authors. To summarise, BadSeed offers a full portable laboratory for all kinds of cybersecurity operations, ranging from pentesting to digital forensics and reverse engineering. Still, it also includes everything needed to develop your software or keep your data secure.

It organizes the tools following the [Cyber Kill Chain®](https://www.lockheedmartin.com/en-us/capabilities/cyber/cyber-kill-chain.html) framework developed by Lockheed Martin. The model highlights the main action taken by an attacker (whitehat or otherwise), to compromise an IT infrastructure. The seven steps of CKC can enhance understanding of the adversary’s tactics, techniques, and procedures, enriching the capabilities of both blue and red teams.

![CKC](https://github.com/ctinnil/badseed/blob/master/res/ckc.png?raw=true)

This project is a work-in-progress, so feel free to contribute and suggest new tools that can be added. 

Requirements 
-----
These requirements are for the computer running the core framework:
* macOS 10.15+ 
* [Docker](https://docs.docker.com/docker-for-mac/install/)
* recommended hardware to run on is 4GB+ RAM, 100GB+ HDD and 2+ CPUs
* if in virtual machine, enables running modern virtualization applications by providing support for Intel VT-x/EPT

Installation 
-----

``` sh
git clone https://github.com/ctinnil/badseed.git
cd badseed
sudo chmod +x badseed_conf.sh
sudo ./badseed_conf.sh # and follow the instructions 
sudo reboot
```

Tested on
-----

platform | manager | version  
---------|---------|---------------
macOS | [Homebrew](https://docs.brew.sh/Installation) 2.4.13| `10.15.6`

### Disclaimer 

***All the tools included may only be used with proper authorization backed-up by a Rules of Engagement (RoE) agreement or for educational purposes in laboratories and virtual environments. Performing hack attempts on computers that you do not own, without written permission from owners, is illegal. The information contained in this repository should only be used to enhance the security of your IT infrastructure and not to conduct malicious or damaging attacks. You should not misuse this information to gain unauthorized access to computer systems. I will not be responsible for any direct or indirect damage caused due to the misusage of the provided framework.***

### Thanks to Homebrew developers and contributors !!!
@https://github.com/Homebrew/brew.git
