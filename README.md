# Scripts For Domoticz

my personnal script collection.

## dzVents Scripts
  
  *Various Scripts to use inside Domoticz.*

### Featured dzVents scripts
- **soif_thermostat** : handle heaters and/or air conditionners  using a temperature sensor, a (mode) selector and a (relay) switch, with differents temperature per room/hours, or when absent.
- **soif_pirs** : handle PIRs sensors, to trigger one of mutiple devices, with optionnal notifications (using PMD), durations times, debounce time, period, master switches,....


### Requirements

- Domoticz
- phpMyDomo (needed for some scripts using pmd actions)

### Installation

- copy the desired scripts into `/domoticz_dir/dzVents/scripts/` 
- for most scripts, also copy the `modules/`  directory into the same location
- from `/domoticz_dir/dzVents/scripts/modules/`   rename `soif_conf.sample/`  to  `soif_conf/`  
- Cutomize the `soif_conf/` files according to your own needs


---------

## Bash Scripts

  *Generic bash scripts that can be used directly, or called from Domoticz.*

### Featured Bash scripts

- **soif_hg612_XXX** : (Huawei HG612 Modem) Various scripts to reboot, resync ADSL, or get JSON statistics
- **soif_livebox_XXX** : (Orange Livebox Modem) Various scripts to reboot, renew Public IP, or get JSON statistics
- **soif_pfsense_ppoe_reload** : (pfSense Firewall) restart the PPoE conection to renew the public IP
- **soif_pbx_asterisk_restart** : (Asterisk) remotely restart the asterisk server


### Requirements

- bash


### Installation

- rename `bash/soif_conf.conf.sample/`  to  `bash/soif_conf.conf`  
- Cutomize the `bash/soif_conf.conf` files according to your own needs


---------

## Licence

This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
