# Scripts For Domoticz

My personnal scripts collection.

## dzVents Scripts
  
  *Various scripts to use inside Domoticz.*

### Featured dzVents scripts

- **soif_absent** : Simulates presence by randomly switch On some devices (ie lights) when the master "absent" switch is turned ON.
- **soif_alexa** : Plays sounds, or say sentences to Alexa devices, when switches change their states.
- **soif_thermostat** : handles heaters and/or air conditionners  using a temperature sensor, a (mode) selector and a (relay) switch, with differents temperature per room/hours, or when absent.
- **soif_pirs** : handles PIRs sensors, to trigger one of mutiple devices, with optionnal notifications (using PMD), durations times, debounce time, period, master switches,....


### Requirements

- Domoticz
- phpMyDomo (needed for some scripts only when using pmd actions)

### Installation

- copy the desired scripts into `/domoticz_dir/dzVents/scripts/` 
- for most scripts, also copy the `modules/`  directory into the same location
- from `/domoticz_dir/dzVents/scripts/modules/`   rename `soif_conf.sample/`  to  `soif_conf/`  
- Cutomize the `soif_conf/` files according to your own needs


---------

## Bash Scripts

  *Generic bash scripts that can be used directly, or called from Domoticz.*

### Featured Bash scripts

- **soif_alexa_XXX** : (alexa-remote-control wrapper). Easily make your Amazon Alexa device to play a sound, or speak a text
- **soif_hg612_XXX** : (Huawei HG612 Modem) Various scripts to reboot, resync ADSL, or get JSON statistics
- **soif_livebox_XXX** : (Orange Livebox Modem) Various scripts to reboot, renew Public IP, or get JSON statistics
- **soif_pfsense_ppoe_reload** : (pfSense Firewall) restart the PPoE conection to renew the public IP
- **soif_pbx_asterisk_restart** : (Asterisk) remotely restart the asterisk server


### Requirements

- bash
- For Alexa scripts, install *oathtool*, *jq* and *curl*. ie (for debian ): `apt-get install oathtool jq curl`


### Installation

- rename `bash/soif_conf.conf.sample/`  to  `bash/soif_conf.conf`  
- Cutomize the `bash/soif_conf.conf` files according to your own needs


---------

## Licence

This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
