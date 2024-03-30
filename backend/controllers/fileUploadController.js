const singleFileUpload=(req,res,next)=>{
    const file=req.file;
    if(!file || file===undefined){
        const error=new Error('Please upload a file');
        error.httpStatusCode=400;
        return next(error)
    }
    res.send(file);
}

const multipleFileUpload=(req,res,next)=>{
    const files=req.files;
    if(!files || files===undefined){
        const error=new Error('Please upload a file');
        error.httpStatusCode=400;
        return next(error)
    }
    res.send(files);
}

module.exports={singleFileUpload,multipleFileUpload};