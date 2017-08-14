#!/usr/bin/python
# -*- coding: UTF-8 -*-# enable debugging

import os
import urlparse
import cgitb
cgitb.enable()


print("Content-Type: text/html;charset=utf-8")
print

def endday():
	# Constant Variables
	orders = []
	fails = ''
	passes = ''
	noshows = ''
	
	with open('CommandersOrders.csv','r') as f:
		for row in f:
			orders.append(row.strip().split(','))
	del orders[0]
	for row in orders:
		if row[1] == '0':
			passes += '<div class="w3-card-8 w3-green"><p>' + row[0] + '</p></div>\n'
		elif row[1] == '1':
			fails += '<div class="w3-card-8 w3-red"><p>' + row[0] + '</p></div>\n'
		else:
			noshows += '<div class="w3-card-8 w3-yellow"><p>' + row[0] + '</p></div>\n'
	
	
	
	with open('templates/head.html', 'r') as header:
		print header.read()
	
	with open('templates/body.html', 'r') as body:
		print body.read()
	print '<li><a' + bardict['end'] + 'href="?action=endday">Endday</a></li>\n' + '<li><a' + bardict['up'] + 'href="?action=upgrade">Upgrade</a></li>\n' + '<li><a' + bardict['sql'] + 'href="?action=sqlbackup">SqlBackup</a></li>\n' + '<li><a' + bardict['arc'] + 'href="?action=archiving">Archiving</a></li>\n' + '<li><a' + bardict['map'] + 'href="?action=ddsmap">DDS Map</a></li>\n' + "</ul>" + '\n<h2><class="w3-container"> ' + bardict['title'] + ' </h2>\n'
	print fails
	print noshows
	print passes
	with open('templates/footer.html', 'r') as footer:
		print footer.read()


def upgrade():
	# Constant Variables
	orders = []
	fails = ''
	passes = ''
	noupgrades = ''
	
	with open('CommandersOrders.csv','r') as f:
		for row in f:
			orders.append(row.strip().split(','))
	del orders[0]
	for row in orders:
		if row[2] == '0':
			passes += '<div class="w3-card-8 w3-green"><p>' + row[0] + '</p></div>\n'
		elif row[2] == '1':
			fails += '<div class="w3-card-8 w3-red"><p>' + row[0] + '</p></div>\n'
	
	if passes == '' and fails == '':
		noupgrades = '<div class="w3-card-8 w3-grey" style="width: 680px;position: static;"><p>No upgrades reported today!</p></div>';
	
	with open('templates/head.html', 'r') as header:
		print header.read()
	
	with open('templates/body.html', 'r') as body:
		print body.read()
	print '<li><a' + bardict['end'] + 'href="?action=endday">Endday</a></li>\n' + '<li><a' + bardict['up'] + 'href="?action=upgrade">Upgrade</a></li>\n' + '<li><a' + bardict['sql'] + 'href="?action=sqlbackup">SqlBackup</a></li>\n' + '<li><a' + bardict['arc'] + 'href="?action=archiving">Archiving</a></li>\n' + '<li><a' + bardict['map'] + 'href="?action=ddsmap">DDS Map</a></li>\n' + "</ul>" + '\n<h2><class="w3-container"> ' + bardict['title'] + ' </h2>\n'
	print fails
	print passes
	print noupgrades
	with open('templates/footer.html', 'r') as footer:
		print footer.read()


def sqlbackup():
	# Constant Variables
	orders = []
	fails = ''
	passes = ''
	
	with open('CommandersOrders.csv','r') as f:
		for row in f:
			orders.append(row.strip().split(','))
	del orders[0]
	for row in orders:
		if row[3] == '0':
			passes += '<div class="w3-card-8 w3-green"><p>' + row[0] + '</p></div>\n'
		elif row[3] == '1':
			fails += '<div class="w3-card-8 w3-red"><p>' + row[0] + '</p></div>\n'
	
	with open('templates/head.html', 'r') as header:
		print header.read()
	
	with open('templates/body.html', 'r') as body:
		print body.read()
	print '<li><a' + bardict['end'] + 'href="?action=endday">Endday</a></li>\n' + '<li><a' + bardict['up'] + 'href="?action=upgrade">Upgrade</a></li>\n' + '<li><a' + bardict['sql'] + 'href="?action=sqlbackup">SqlBackup</a></li>\n' + '<li><a' + bardict['arc'] + 'href="?action=archiving">Archiving</a></li>\n' + '<li><a' + bardict['map'] + 'href="?action=ddsmap">DDS Map</a></li>\n' + "</ul>" + '\n<h2><class="w3-container"> ' + bardict['title'] + ' </h2>\n'
	print fails
	print passes
	with open('templates/footer.html', 'r') as footer:
		print footer.read()

def archiving():
	# Constant Variables
	orders = []
	fails = ''
	passes = ''
	
	with open('CommandersOrders.csv','r') as f:
		for row in f:
			orders.append(row.strip().split(','))
	del orders[0]
	for row in orders:
		if row[4] == '0':
			passes += '<div class="w3-card-8 w3-green"><p>' + row[0] + '</p></div>\n'
		elif row[4] == '1':
			fails += '<div class="w3-card-8 w3-red"><p>' + row[0] + '</p></div>\n'
	
	with open('templates/head.html', 'r') as header:
		print header.read()
	
	with open('templates/body.html', 'r') as body:
		print body.read()
	print '<li><a' + bardict['end'] + 'href="?action=endday">Endday</a></li>\n' + '<li><a' + bardict['up'] + 'href="?action=upgrade">Upgrade</a></li>\n' + '<li><a' + bardict['sql'] + 'href="?action=sqlbackup">SqlBackup</a></li>\n' + '<li><a' + bardict['arc'] + 'href="?action=archiving">Archiving</a></li>\n' + '<li><a' + bardict['map'] + 'href="?action=ddsmap">DDS Map</a></li>\n' + "</ul>" + '\n<h2><class="w3-container"> ' + bardict['title'] + ' </h2>\n'
	print fails
	print passes
	with open('templates/footer.html', 'r') as footer:
		print footer.read()


def ddsmap():
	if 'view' in urlparse.parse_qs(parsed.query) and urlparse.parse_qs(parsed.query)['view'] == ['full']:
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
		
	else:
		with open('templates/mapheadsite.html', 'r') as header:
			print header.read()
		
		with open('templates/body.html', 'r') as body:
			print body.read()
		print '<li><a' + bardict['end'] + 'href="?action=endday">Endday</a></li>\n' + '<li><a' + bardict['up'] + 'href="?action=upgrade">Upgrade</a></li>\n' + '<li><a' + bardict['sql'] + 'href="?action=sqlbackup">SqlBackup</a></li>\n' + '<li><a' + bardict['arc'] + 'href="?action=archiving">Archiving</a></li>\n' + '<li><a' + bardict['map'] + 'href="?action=ddsmap">DDS Map</a></li>\n' + "</ul>" + '\n<h2><class="w3-container"> ' + bardict['title'] + ' </h2>\n'
		print '<div class="center-div"><iframe src="?action=ddsmap&view=full" width="1000" height="500" ></iframe></div>\n'
		print '<div class="center-div"><a href="?action=ddsmap&view=full" target="_parent"><button class="button button1">View Fullscreen</button></a></div>\n'
		
		with open('templates/footer.html', 'r') as footer:
			print footer.read()


def dashboard():
	import json
	# Constant Variables
	dashdealers = json.load(open('dashbin/dashdealers.json','r'))

	if 'dealer' in urlparse.parse_qs(parsed.query) and urlparse.parse_qs(parsed.query)['dealer'][0] in dashdealers:
		curd = urlparse.parse_qs(parsed.query)['dealer'][0]
		
		with open('templates/head.html','r') as header:
			print header.read()
		
		with open('templates/body.html','r') as body:
			print body.read()
		
		print '<ul>' + '<li><a' + bardict['end'] + 'href="?action=endday">Endday</a></li>\n' + '<li><a' + bardict['up'] + 'href="?action=upgrade">Upgrade</a></li>\n' + '<li><a' + bardict['sql'] + 'href="?action=sqlbackup">SqlBackup</a></li>\n' + '<li><a' + bardict['arc'] + 'href="?action=archiving">Archiving</a></li>\n' + '<li><a' + bardict['map'] + 'href="?action=ddsmap">DDS Map</a></li>\n' + '<li><a' + bardict['dash'] + 'href="?action=dashboard">Dashboard</a></li>\n' + "</ul>" + '\n<h2><class="w3-container"> ' + dashdealers[curd][0] + ' </h2>\n'
		
		with open('templates/footer.html','r') as footer:
			print footer.read()
			
	else:
		AcuDataStr = "\t\tvar acudata = [['Dealership', 'Users'],\n"
		VBDataStr = "\t\tvar vbdata = [['Dealership', 'Users'],\n"
		updatetime = dashdealers['630'][-1][0] # I <3 Crowe
		TotalAcu = 0
		TotalVB = 0
		
		with open('templates/headdash.html','r') as header:
			print header.read()
		
		for dealer, data in dashdealers.iteritems():
			if data[-1][1] != 'null' and data[-1][1] != '0':
				TotalAcu += int(data[-1][1])
				AcuDataStr += "\t\t['" + data[0] + "', " + data[-1][1] + "],\n"
			if data[-1][2] != 'null' and data[-1][2] != '0':
				TotalVB += int(data[-1][2])
				VBDataStr += "\t\t['" + data[0] + "', " + data[-1][2] + "],\n"
		
		AcuDataStr += '\t\t];\n\n'
		VBDataStr += '\t\t];\n\n'
	
		print AcuDataStr
		print VBDataStr
		
		with open('templates/headdash2.html','r') as header2:
			print header2.read()
		
		print '<ul>' + '<li><a' + bardict['end'] + 'href="?action=endday">Endday</a></li>\n' + '<li><a' + bardict['up'] + 'href="?action=upgrade">Upgrade</a></li>\n' + '<li><a' + bardict['sql'] + 'href="?action=sqlbackup">SqlBackup</a></li>\n' + '<li><a' + bardict['arc'] + 'href="?action=archiving">Archiving</a></li>\n' + '<li><a' + bardict['map'] + 'href="?action=ddsmap">DDS Map</a></li>\n' + '<li><a' + bardict['dash'] + 'href="?action=dashboard">Dashboard</a></li>\n' + "</ul>" + '\n<h2><class="w3-container"> ' + bardict['title'] + ' </h2>\n'
		
		with open('templates/bodydash.html','r') as body:
			print body.read()
			
		print '<div id="chart_div" style="width: 1500px; height: 800px;"></div>';
		print '<button id="b1" class="button button1">Switch ADV/VB</button>\n'
		print 'Total Acu Users: ' + str(TotalAcu)
		print 'Total VB Users: ' + str(TotalVB)
		print 'Last Updated: ' + updatetime
		
	#	print '<span style="display: block !important; width: 180px; text-align: center; font-family: sans-serif; font-size: 12px;"><img src="http://weathersticker.wunderground.com/weathersticker/cgi-bin/banner/ban/wxBanner?bannertype=wu_macwhite&zip=52001&language=EN"</span>'
		
		with open('templates/footer.html','r') as footer:
			print footer.read()
	

	

# Dynamic return from get action
bardict = {
	'end': ' ',
	'up': ' ',
	'sql': ' ',
	'arc': ' ',
	'map': ' ',
	'dash': ' ',
	'title': ' ',
	}

url = os.environ["REQUEST_URI"]
parsed = urlparse.urlparse(url)
if 'action' in urlparse.parse_qs(parsed.query):
	action = urlparse.parse_qs(parsed.query)['action']
	if action == ['endday']:
		bardict['end'] = ' class="active" '
		bardict['title'] = 'Endday'
		endday()
	elif action == ['upgrade']:
		bardict['up'] = ' class="active" '
		bardict['title'] = 'Upgrade'
		upgrade()
	elif action == ['sqlbackup']:
		bardict['sql'] = ' class="active" '
		bardict['title'] = 'Sqlbackup'
		sqlbackup()
	elif action == ['archiving']:
		bardict['arc'] = ' class="active" '
		bardict['title'] = 'Archiving'
		archiving()
	elif action == ['ddsmap']:
		bardict['map'] = ' class="active" '
		bardict['title'] = 'Linux Customer Status'
		ddsmap()
	elif action == ['dashboard']:
		bardict['dash'] = ' class="active" '
		bardict['title'] = 'Linux Active Users'
		dashboard()
else:
	bardict['end'] = ' class="active" '
	bardict['title'] = 'Endday'
	endday()

