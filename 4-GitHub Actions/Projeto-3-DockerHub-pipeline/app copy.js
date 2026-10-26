const express = require('express');

const app = express();

app.get('/', (req,res)=>{
    res.send("Docker CI/CD Project with docker hub and github actions");
});

app.listen(3000, ()=>{
    console.log("Server running on port 3000");
});