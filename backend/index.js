require('dotenv').config()
const express = require('express');
const cors = require('cors');
const mongoose = require('mongoose');

// const adminRoutes = require('./routes/adminRoutes');
const loginRoutes = require('./routes/loginRegRoutes');
const fileUploadRoutes=require('./routes/fileUploadRoutes');
// const chatRoutes=require('./routes/chatRoutes');
const bodyParser = require('body-parser');


mongoose.set("strictQuery", true);
mongoose.connect(process.env.DB, { useUnifiedTopology: true, useNewUrlParser: true, });
mongoose.connection.on('error', err => console.log(err));
mongoose.connection.on('connected', con => console.log("connected to DB"));
mongoose.connection.on('disconnected', con => console.log("disconnected from DB"));

const app = express();
app.use(cors());
// app.use(express.json());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.use('/', loginRoutes);
app.get('/home', function (req, res) {
    res.send("Welcome to the home page");
});
// app.use('/admin', adminRoutes);
app.use('/file',fileUploadRoutes);
// app.use('/chat',chatRoutes);

app.use(function (err, req, res, next) {
    res.status(err.status || 500);
    res.json({ error: err });
});

// app.use(express.urlencoded({ extended: true }));

app.listen(8080, () => {
    console.log('Server started at 8080');
});