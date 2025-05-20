import UserRepository from "../repository/firebaseUserRepository";
import {User} from "../entity/User";
import admin from "../../firebase";

const repo = new UserRepository();

export const googleLogin = async (token: string) =>{
  try {
    const decoded = await admin.auth().verifyIdToken(token);
    const {uid, name, email, picture} = decoded;

    const user = new User(uid, name, email, picture);
    let userFound = await repo.getUser(user.getUid);
    if (!userFound) {
      await repo.addUser(user);
      userFound = user;
    }
    return {
      uid: userFound.getUid,
      name: userFound.getUsername,
      email: userFound.getEmail,
      picture: userFound.getProfilePicture,
    };
  } catch (error) {
    if (error instanceof Error) {
      console.error(error.message);
      throw new Error("Error during login: " + error.message);
    } else {
      console.error("An unexpected error occurred");
      throw new Error("Error during login: An unexpected error occurred");
    }
  }
};
