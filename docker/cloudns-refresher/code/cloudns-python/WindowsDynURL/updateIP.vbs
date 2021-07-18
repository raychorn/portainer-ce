Set xmlhttp = WScript.CreateObject("Microsoft.XMLHttp")
url = "https://ipv4.cloudns.net/api/dynamicURL/?q=MzM1MTk3OToyMzYzMjgzNDI6ZWQwMGM2N2NmYWMyNWE5MzU5ZDI3MGRjODA5OTcwZTk4OTI5YTQwZjhkZWU5YmZiN2IxMWE5OGY0ZjIwMTBmNw"
xmlhttp.open "POST", url , False
xmlhttp.send "<?xml version='1.0'?><message><priority>0</priority></message>"