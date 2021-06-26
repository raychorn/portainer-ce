use demo
db.CreateUser(
   {
      user: "demo",
      pwd: "demo12345",
      roles:[
         {
            role:"readwrite",
            db:"demo"
         }
      ]

   }
);
