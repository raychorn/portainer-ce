set dynurl=%cd%
SchTasks /Create /SC ONSTART /TN "ClouDNS-Aggressive" /TR "C:/Python39/python %dynurl%/dynamic-url-python.py"
SchTasks /Run /TN "ClouDNS-Aggressive"