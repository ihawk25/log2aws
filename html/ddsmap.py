#!/usr/bin/python
# -*- coding: UTF-8 -*-# enable debugging

import os
import cgitb
cgitb.enable()


print("Content-Type: text/html;charset=utf-8")
print

# Constant Variables
mapsites = []
activeports = []
iwindows = ''
markers = ''

with open('mapbin/mapsites.csv','r') as f:
	for row in f:
		mapsites.append(row.strip().split(','))
del mapsites[0]

with open('mapbin/hub1-ports.txt','r') as f:
	for row in f:
		activeports.append(row.strip())

for site in mapsites:
	iwindows += 'var site' + site[0] + ' = new google.maps.InfoWindow({content: \'<div id="content"><div id="siteNotice"></div><h1 id="firstHeading">' + site[1] + '</h1></div>\'});' + '\n'
	if site[0] in activeports:
		markers += 'var marker' + site[0] + ' = new google.maps.Marker({position: new google.maps.LatLng(' + site[2] + ',' + site[3] + '),icon: icons.green.icon,map: map}); marker' + site[0] + '.addListener(\'click\', function() { site' + site[0] + '.open(map, marker' + site[0] + '); });' + '\n'
	else:
		markers += 'var marker' + site[0] + ' = new google.maps.Marker({position: new google.maps.LatLng(' + site[2] + ',' + site[3] + '),icon: icons.red.icon,map: map}); marker' + site[0] + '.addListener(\'click\', function() { site' + site[0] + '.open(map, marker' + site[0] + '); });' + '\n'
		
with open('templates/maphead.html','r') as header:
	print header.read()

print iwindows
print markers

with open('templates/mapfoot.html','r') as footer:
	print footer.read()

