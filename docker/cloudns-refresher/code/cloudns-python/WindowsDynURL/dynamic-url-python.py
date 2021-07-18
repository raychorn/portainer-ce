#!/usr/bin/python
import os
import sys
import json

import time

if (0):
    _external_host = None
    try:
        from dotenv import load_dotenv, find_dotenv
        load_dotenv(find_dotenv())

        _external_host = os.environ.get('EXTERNAL_HOST')
    except ImportError:
        pass

__cache__ = {}
 
from urllib.request import Request, urlopen
from urllib.error import URLError, HTTPError

'''
import os
externalIp = os.popen("ipconfig").read().split(":")[15][1:14]
'''
DYNAMIC_DNS_URLS = []

DYNAMIC_DNS_URLS.append('https://ipv4.cloudns.net/api/dynamicURL/?q=MzM1MTk3OToyMzkyMTM0MDE6ZjY3MjQ4NmFlYjBjZTE5YTM5YWI3MTYzYjZlN2QxMDk1Yzg4ZmJjOTM1NzA4ZDQxZjExOTViM2ZkMTc4ZTFjYw')

while(1):
    req = Request("http://httpbin.org/ip")
    try:
        response = urlopen(req)
    except HTTPError as e:
        print('Error code: ', e.code)
    except URLError as e:
        print('Reason: ', e.reason)
    else:
        data = json.loads(response.read())
        _origin = data.get("origin")
        assert isinstance(_origin, str) and (len(_origin) > 0), 'Something went wrong. Please fix.'
        print("The public IP is : %s" % _origin)
        __cache__[_origin] = __cache__.get(_origin, 0) + 1
        num_found = len(list(__cache__.keys()))
        detections = [(v > 2) for v in list(__cache__.values())]
        test1 = (num_found > 1)
        test2 = all(detections)
        prediction = (test1) and (test2)
        print('DEBUG: Number of IPs found: {} ({}) --> {} ({}) -> [{}]'.format(num_found, test1, detections, test2, prediction))
        print('DEBUG: {}'.format(json.dumps(__cache__)))
        if (prediction):
            print('The ip address has changed.')
            for DYNAMIC_DNS_URL in DYNAMIC_DNS_URLS:
                if sys.version_info[0] < 3:
                    import urllib
                    page = urllib.urlopen(DYNAMIC_DNS_URL);
                    page.close();
                else:
                    import urllib.request
                    page = urllib.request.urlopen(DYNAMIC_DNS_URL);
                    page.close();    
            __cache__ = {}
        the_sum = sum(v for v in list(__cache__.values()))
        fname = os.sep.join([os.path.dirname(__file__), 'results.json'])
        with open(fname, 'w') as fOut:
            the_results = {}
            the_results['__cache__'] = __cache__
            the_results_diagnostics = the_results.get('diagnostics', {})
            the_results_diagnostics['num_found'] = num_found
            the_results_diagnostics['detections'] = detections
            the_results_diagnostics['test1'] = test1
            the_results_diagnostics['test2'] = test2
            the_results_diagnostics['prediction'] = prediction
            the_results_diagnostics['the_sum'] = the_sum
            the_results['diagnostics'] = the_results_diagnostics
            print(json.dumps(the_results, indent=3), file=fOut)
        print('Completed {} check{}.'.format(the_sum, 's' if (the_sum > 1) else ''))
        time.sleep(10)
