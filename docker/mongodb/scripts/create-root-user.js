use admin
db.createUser(
  {
     user: "root",
     pwd: passwordPrompt(),
     roles:["root"]
  }
);


use admin
db.createUser(
  {
    user: "root",
    pwd: passwordPrompt(), // or cleartext password
    roles: [ { role: "userAdminAnyDatabase", db: "admin" }, "readWriteAnyDatabase", "root" ]
  }
)


use admin
db.createUser(
  {
    user: "admin",
    pwd: "peekab00",
    roles: [ { role: "userAdminAnyDatabase", db: "admin" }, "readWriteAnyDatabase", "root" ]
  }
)


use admin
db.changeUserPassword("admin", passwordPrompt())