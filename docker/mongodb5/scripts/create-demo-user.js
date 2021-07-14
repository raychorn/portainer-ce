use demo
db.CreateUser(
   {
      user: "demo",
      pwd: passwordPrompt(),
      roles:[
         {
            role:"readwrite",
            db:"demo"
         }
      ]

   }
);
