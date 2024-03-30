const crypto = require('crypto');
const base64Encode = (data) => {
    let buff = new Buffer.from(data);
    return buff.toString('base64');
}

const base64Decode = (data) => {
    let buff = new Buffer.from(data, 'base64');
    return buff.toString('ascii');
}

const sha256 = (salt, password) => {
    var hash = crypto.createHash('sha512', password);
    hash.update(salt);
    var value = hash.digest('hex');
    return value;
}

const hashPw = (password) => {
    const hash = crypto.createHash('sha512',
        process.env.PASSWORD_HASH
    );
    hash.update(password);
    const value = hash.digest('hex');
    // console.log("Hashed Password is " + value);
    return {
        passwordHash: value
    };
}

const verifyPw = (password, hashedPassword) => {
    const hash = crypto.createHash('sha512', process.env.PASSWORD_HASH);
    hash.update(password);
    const value = hash.digest('hex');
    // console.log("Hashed Password is " + hashedPassword);
    // console.log("Value is " + value);
    return value === hashedPassword;
}

module.exports={base64Decode,base64Encode,sha256, hashPw, verifyPw};