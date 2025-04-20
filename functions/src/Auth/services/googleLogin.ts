import * as admin from "firebase-admin"
import UserRepository from "../repository/firebaseUserRepository"
import { User } from "../entity/User";

admin.initializeApp()
const repo = new UserRepository();

export const googleLogin = async (token: string) =>{
   try {

        const decoded = await admin.auth().verifyIdToken(token);
        const {uid, name, email, picture} = decoded;

        let user = new User(uid, name, email, picture);
        const userFound = await repo.findUser(user.getUid);
        if(!userFound){
            throw new Error("user not found");
        }
        return { uid, name, email, picture };;
   } catch (error) {
     if (error instanceof Error) {
          console.error(error.message);
          throw new Error('Error during login: ' + error.message);
        } 
        else {
          console.error("An unexpected error occurred");
          throw new Error('Error during login: An unexpected error occurred');
        }
   } 
}