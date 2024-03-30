const express = require('express');
const { signUpController, loginController, createChildModel, getChildren, identifyChild, pwResetEmailController, pwLinkVerifier, pwResetController, emailLinkVerifier } = require('../controllers/loginRegController');
const router = express.Router();
const { upload } = require('../middlewares/multer');

router.post('/signup/:role',signUpController);
router.post('/login',loginController);
router.post('/child',upload.single('file'),createChildModel);
router.get('/get-child/:token',getChildren);
router.post('/voice-match/',upload.single('file'),identifyChild);
router.post('/password-reset',pwResetEmailController);
router.get('/password-change/:ident/:today-:hash',pwLinkVerifier);
router.post('/reset-password',pwResetController);
router.get('/email-verification/:ident/:hash',emailLinkVerifier);
// router.get('/email-verification/:ident/:today-:hash',emailVerificationController);

module.exports=router;