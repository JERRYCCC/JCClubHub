###
###  need "requests" and "beautifulSoup" to collect data
###  and build events on the database


import requests
from bs4 import BeautifulSoup
import json, httplib
import dateutil.parser
import datetime

url = "http://go.activecalendar.com/austincollege/"
r  =requests.get(url)
soup = BeautifulSoup(r.content)
g_data = soup.find("section", {"id": "main-content"})

connection = httplib.HTTPSConnection('api.parse.com', 443)
connection.connect()

for item in g_data:

	try:

		x = dateutil.parser.parse(item.find("time", {"itemprop": "startDate"}).get("datetime"))
		print x.isoformat()

		connection.request('POST', '/1/classes/Event/', json.dumps(
	    {
	      	"name": item.find("h2", {"itemprop": "name"}).text.encode("utf-8"),
	     	 "location": item.find("p", {"itemprop": "location"}).text.encode("utf-8"),
	     	 "description": item.find("p", {"itemprop": "description"}).text.encode("utf-8"),
	     	 "club": {
	            "__type": "Pointer",
	            "className": "Club",
	            "objectId": "4wQuK2kyHF"
	        },
		    "school": {
		        "__type": "Pointer",
		        "className": "School",
		        "objectId": "mKdE86PKiM"
		    },
		    "date": {
	            "__type": "Date",
	            "iso": x.isoformat()
	        },
	        "available": True
		}), {
	       "X-Parse-Application-Id": "bESrf541rF2jJWbw9z0ZObIrTbAVm4N9rwZEQvgS",
	       "X-Parse-REST-API-Key": "MVg8EOlZu8zVpaeL09kta3bRLfVZqaCTNe1vNvTd",
	       "Content-Type": "application/json"
     	})	

		result = json.loads(connection.getresponse().read())
		print result

		#print item.find("h2", {"itemprop": "name"}).text.encode("utf-8")  # the name
		#print item.find("p", {"itemprop": "description"}).text.encode("utf-8")
		#print item.find("time", {"itemprop": "startDate"}).get("datetime").encode("utf-8")
		#print item.find("time", {"itemprop": "endDate"}).get("datetime").encode("utf-8")
		#print item.find("p", {"itemprop": "location"}).text.encode("utf-8")
		#print "  "

	except:
		continue
		
		
		
		
