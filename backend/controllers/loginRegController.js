const jwt = require('jsonwebtoken');
const moment = require('moment/moment');
const sendemail = require('../middlewares/emailer');
const { base64Decode, base64Encode, sha256, hashPw, verifyPw } = require('../middlewares/encDecScript');
const path = require('path');
const { UserModel, ChildModel, ResetPwEmailModel, validateResetInfo, validateUserInfo } = require("../models/userModel");

async function signUpController(req, res) {
    try {
        var fname = req.body.fname;
        var lname = req.body.lname;
        var email = req.body.email;
        var password = req.body.password;
        var access_lvl = req.params.role || 0;
        // console.log(req.body);
        // const user=new UserModel;
        const { validate } = validateUserInfo({ fname, lname, email, password, access_lvl });
        if (validate) {
            res.json({
                success: false,
                data: { message: validate, signup: false }
            })
        }
        else {
            const { passwordHash } = await hashPw(password);
            password = passwordHash;
            const user = await UserModel.create({ fname, lname, email, password, access_lvl });
            user.save();
            res.json({
                success: true,
                data: { user: req.body, signup: true }
            });
        }
    }
    catch (err) {
        res.json({
            success: false,
            data: { error: "SignUp Controller Error" + err }
        });
    }
}

async function loginController(req, res) {
    try {
        var email = req.body.email;
        var password = req.body.password;
        const user = await UserModel.findOne({ email });

        if (!user) {
            res.json({
                success: true,
                data: { message: "Email Not Found!", login: false }
            });
        }
        else {
            const validate = await user.isValidPassword(password);
            if (!validate) {
                res.json({
                    success: true,
                    data: { message: "Wrong Password! Please Try Again!", login: false }
                })
            }
            else {
                var access_lvl = user.access_lvl;
                const body = { _id: user._id, email: email };
                const token = jwt.sign({ user: body }, process.env.JSON_KEY);
                var isVerified = user.isVerified;
                if (isVerified == false) {
                    user.isVerified = true;
                    user.save();
                }
                //CHECK FOR ISVERIFIED IN FRONTEND ALSO IF NEEDED
                // if (isVerified==="true") {
                res.json({
                    success: true,
                    data: {
                        token,
                        access_lvl,
                        isVerified,
                        login: true
                    }
                })
                // }
                // else {
                //     var emailOutput=await emailVerificationController(email);
                //     console.log(emailOutput);
                //     return res.json({ redirectLink: `${req.headers.hostname}/email-verification-status` });//CHANGE LINK AS PER FRONTEND ROUTER
                // }
            }
        }
    }
    catch (err) {
        res.json({
            success: false,
            data: { error: "Login Controller Error" + err }
        });
    }
}

async function createChildModel(req, res) {
    try {
        console.log(req.file);
        var name = req.body.name;
        var audioFile = req.file.path;
        // audioFile = audioFile+".wav";
        var completePath = path.join('/home/ubuntu/Codeshastra_TechTitans/backend/',audioFile);
        const token = req.body.token;
        const decodedToken = jwt.verify(token, process.env.JSON_KEY);
        const userId = decodedToken.user._id;
        // const user = await UserModel.findById(userId);
        const child = await ChildModel.create({ name, audioFile: completePath, parent: userId });
        child.save();
        res.json({
            success: true,
            data: { child }
        });
    }
    catch (err) {
        res.json({
            success: false,
            data: { error: "Child Creation Error" + err }
        });
    }
}

async function identifyChild(req, res) {
    try {
        var token = req.body.token;
        const audioFile = req.file['path'];
        var completePath = path.join('/home/ubuntu/Codeshastra_TechTitans/backend/', audioFile);
        const decodedToken = jwt.verify(token, process.env.JSON_KEY);
        const userId = decodedToken.user._id;
        // console.log(userId)
        const formdata = new FormData();
        formdata.append("parent_token", userId);
        formdata.append("audioFile", completePath);
        const requestOptions = {
            method: "POST",
            body: formdata,
            redirect: "follow"
        };
        const response = await fetch('http://127.0.0.1:8090/voice-compare', requestOptions);

        const data = await response.json(); // Parse JSON response

        if (data.success === true) {
            res.send({ success: true, name: data.recognized_speaker });
        } else {
            res.send({ success: false, message: "Could not Identify" });
        }
    }
    catch (err) {
        res.json({
            success: false,
            data: { error: "Child Identification Error: " + err }
        });
    }
}


async function getChildren(req, res) {
    try {
        var token = req.params.token;
        const decodedToken = jwt.verify(token, process.env.JSON_KEY);
        const userId = decodedToken.user._id;
        const children = await ChildModel.find({ parent: userId });
        res.json({
            success: true,
            data: { children }
        });
    }
    catch (err) {
        res.json({
            success: false,
            data: { error: "Child Getting Error " + err }
        })
    }
}

async function pwResetEmailController(req, res) {
    try {
        var email = req.body.email;
        const user = await UserModel.findOne({ email });

        if (!user) {
            res.json({
                message: "Email Not Found!"
            });
        }
        else {
            const today = base64Encode(new Date().toISOString());
            const ident = base64Encode(user._id.toString());
            const data = {
                today: today,
                userId: user._id,
                password: user.password,
                email: user.email
            };
            const hash = sha256(JSON.stringify(data), process.env.EMAIL_HASH);

            const validateReset = validateResetInfo(email);
            if (validateReset) {
                const resetPw = await ResetPwEmailModel.create({ email });
                resetPw.save();

                //Send Email
                sendemail(email, { email, title: "HackNiche", link: `http://localhost:8080/password-change/${ident}/${today}-${hash}` }, '../middlewares/requestResetPassword.handlebars');

                res.json({
                    message: "Password Reset Link Sent to Your Email"
                });
            }
        }
    }
    catch (err) {
        res.json({
            error: "Reset Password Email Error" + err
        })
    }
}

async function pwLinkVerifier(req, res) {
    try {
        const today = base64Decode(req.params.today);
        const then = moment(today);
        const now = moment().utc();
        const timeSince = now.diff(then, 'hours');
        if (timeSince > 2) {
            return res.json({
                message: "Password Link is Invalid!"
            });
        }
        const userId = base64Decode(req.params.ident);

        const user = await UserModel.findOne({ _id: userId });
        if (!user | user === undefined) {
            return res.json({
                message: "User Not Found"
            });
        }

        const data = {
            today: req.params.today,
            userId: user._id,
            password: user.password,
            email: user.email
        };
        const hash = sha256(JSON.stringify(data), process.env.EMAIL_HASH);

        if (hash !== req.params.hash) {
            return res.json({
                message: "Password Link is Invalid!"
            });
        }

        return res.json({ redirectLink: `${req.headers.hostname}/reset-password` });
        // return res.redirect(`${req.headers.hostname}/reset-password`);

    }
    catch (err) {
        res.json({
            error: "Password Link Check Error" + err
        })
    }
}

async function pwResetController(req, res) {
    try {
        const resetEmail = await ResetPwEmailModel.findOne({ email: req.body.email });
        if (!resetEmail | resetEmail === undefined) {
            return res.json({
                message: "Email Not Found!"
            })
        }
        else {
            const user = await UserModel.findOne({ email: resetEmail.email });
            user.password = req.body.password;
            user.save();

            resetEmail.deleteOne({ email: req.body.email });

            //FRONTEND PE CHECK IF SUCCESS AND THEN REDIRECT TO LOGIN PAGE ELSE STAY ON THE PAGE UPON SUBMIT BUTTON CLICK
            res.json({
                message: "Password Has Been Reset",
                success: true
            })
        }
    }
    catch (err) {
        res.json({
            error: "Password Reset Controller Error" + err
        })
    }
}

async function emailVerificationController(email) {
    try {
        const user = await UserModel.findOne({ email });
        if (!user) {
            return {
                message: "Email Not Found!"
            };
        }
        else {
            const ident = base64Encode(user._id.toString());
            const data = {
                userId: user._id,
                email: user.email
            };
            const hash = sha256(JSON.stringify(data), process.env.EMAIL_HASH);

            //SEND EMAIL
            sendemail(email, { email, title: "HackNiche", link: `http://localhost:8080/email-verification/${ident}/${hash}` }, '../middlewares/emailVerification.handlebars');

            return {
                message: "Verification Mail Sent Successfully"
            }
        }
    }
    catch (err) {
        console.log("Email Verification Controller Error" + err)
        return {
            error: "Email Verification Controller Error" + err
        }
    }
}

async function emailLinkVerifier(req, res) {
    try {
        const userId = base64Decode(req.params.ident);

        const user = await UserModel.findOne({ _id: userId });
        if (!user | user === undefined) {
            return res.json({
                message: "User Not Found"
            });
        }

        const data = {
            userId: user._id,
            email: user.email
        };
        const hash = sha256(JSON.stringify(data), process.env.EMAIL_HASH);

        if (hash !== req.params.hash) {
            return res.json({
                message: "Password Link is Invalid!"
            });
        }

        user.isVerified = true;
        user.save();

        return res.json({ redirectLink: `${req.headers.hostname}/login` }); //CHANGE ROUTING LATER
        // return res.redirect(`${req.headers.hostname}/reset-password`);

    }
    catch (err) {
        res.json({
            error: "Email Link Check Error" + err
        })
    }
}


module.exports = { signUpController, loginController, createChildModel, getChildren, identifyChild, pwResetEmailController, pwLinkVerifier, pwResetController, emailVerificationController, emailLinkVerifier }