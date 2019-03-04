# Domoticz Scripts

Various Scripts to use in Domoticz


## dzVents

### Featured scripts
- **soif_thermostat** : handle heaters  using a temperaure sensor, a (mode) selector and a (relay) switch, with differents temperature per room/hours, or when absent.
- **soif_pirs** : handle PIRs sensors, to trigger one of mutiple devices, with optionnal notifications (using PMD), durations times, debounce time, period, master switches,....


### Requirements
- Domoticz
- phpMyDomo (needed for some scripts using pmd actions)

### Installation
- copy the desired scripts into `/domoticz_dir/dzVents/scripts/` 
- for most scripts, also copy the `modules/`  directory into the same location
- from `/domoticz_dir/dzVents/scripts/modules/`   rename `soif_conf.sample/`  to  `soif_conf/`  
- Cutomize the `soif_conf/` files according to your own needs



## Licence

This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
