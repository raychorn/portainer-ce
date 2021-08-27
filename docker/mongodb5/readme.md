
## server1.web-service.org

```
_mongodb._tcp.mongodb-cluster1.web-service.org	SRV	
0 0 65117 127.0.0.1	10m
```

## tp01-2066.web-service.org

```
_mongodb._tcp.mongodb-cluster1.web-service.org	SRV	
0 0 65217 127.0.0.1	10m
```

## docker1.web-service.org

```
_mongodb._tcp.mongodb-cluster1.web-service.org	SRV	
0 0 65317 127.0.0.1	10m
```

## docker2.web-service.org

```
_mongodb._tcp.mongodb-cluster1.web-service.org	SRV	
0 0 65317 127.0.0.1	10m
```


```
server1

rs.initiate( {
   _id : "rs0",
   members: [
      { _id: 0, host: "server1.web-service.org:27017" },
      { _id: 1, host: "server-jj95enl.web-service.org:27017" },
      { _id: 2, host: "tp01-2066.web-service.org:27017" }
   ]
})
```

```
rs.conf()

```

Use the following to find the primary:

```
 rs.status()
```

```
mongodb://server1.web-service.org:27017,server-jj95enl.web-service.org:27017,tp01-2066.web-service.org:27017/admin?replicaSet=rs0
```

[tutorial-x.509certificates-mongo](https://github.com/shauryashaurya/tutorial-x.509certificates-mongo)

```
openssl req -newkey rsa:4096 -x509 -sha256 -days 365000 -nodes -out mongodb.crt -keyout mongodb.key
```

```
subject= CN=<myhostname1>,OU=Dept1,O=MongoDB,ST=NY,C=US
subject= CN=<myhostname2>,OU=Dept1,O=MongoDB,ST=NY,C=US
subject= CN=<myhostname3>,OU=Dept1,O=MongoDB,ST=NY,C=US
```

```
curl --request POST \
 --user "{publicApiKey}:{privateApiKey}" \
 --header "Content-Type: application/json" \
 --digest "https://cloud.mongodb.com/api/atlas/v1.0/groups/{groupId}/databaseUsers/{username}/certs?pretty=true" \
 --data '{"monthsUntilExpiration":12}'
```

```
subject=emailAddress=raychorn@gmail.com,CN=server1.web-service.org,OU=Unit,O=COrp,L=Denver,ST=CO,C=AU
```

```
db.getSiblingDB("$external").runCommand(
  {
    createUser: "emailAddress=raychorn@gmail.com,CN=server1.web-service.org,OU=Unit,O=COrp,L=Denver,ST=CO,C=AU",
    roles: [{role:'root',db:'admin'}],
    writeConcern: { w: "majority" , wtimeout: 30000 }
  }
)

emailAddress=raychorn@gmail.com,CN=server1.web-service.org,OU=Unit,O=COrp,L=Denver,ST=CO,C=AU

#10.0.0.179
#10.0.0.139
#10.0.0.239
```