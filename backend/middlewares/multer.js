const express = require("express")
const path = require("path")
const multer = require("multer");

var storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, "uploads");
    },
    filename: function (req, file, cb) {
        cb(null,file.originalname)
    }
})

// const maxSize=1*1000*1000; //1MB

var upload=multer({
    storage:storage,
    // fileFilter:function(req,file,cb){
    //     // var fileTypes=/
    //     var mimetype=fileTypes.test(file.mimetype);
    //     var extname=fileTypes.test(path.extname(file.originalname).toLowerCase());
    //     if(mimetype&&extname){
    //         return cb(null,true);
    //     }
    //     cb("Error: File Upload only supports"+fileTypes);
    // }
    // limits:{fileSize:maxSize}
})

module.exports={upload};