## iPhone couchDB Catalog

To push to cloudant:

	couchapp push http://USERNAME:PASSWORD@USERNAME.cloudant.com/iphonecouchsync

Now view your app at: 

	http://USERNAME.cloudant.com/iphonecouchsync/_design/iphonecouchsync/index.html
	
The view that the phone uses to get json file:

	https://USERNAME.cloudant.com/iphonecouchsync/_design/iphonecouchsync/_view/syncView

