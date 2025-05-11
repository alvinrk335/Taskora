import * as admin from "firebase-admin";
import * as serviceAccount from "../taskora-2b338-7764b9759d98.json";

if (!admin.apps.length) {
  admin.initializeApp({credential: admin.credential.cert(serviceAccount as admin.ServiceAccount)});
}


export default admin;
