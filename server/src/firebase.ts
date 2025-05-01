import * as admin from "firebase-admin";
const serviceAccount = require("../../taskora-2b338-7764b9759d98.json");

if (!admin.apps.length) {
  admin.initializeApp({credential: admin.credential.cert(serviceAccount)});
}


export default admin;
