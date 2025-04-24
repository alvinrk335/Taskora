import {User} from "../entity/User";
import UserRepo from "./userRepo";
import admin from "../../firebase";
import {UserHandler} from "../entity/user_handler";

const db = admin.firestore();
export default class UserRepository implements UserRepo {
  private userCollection = db.collection("users");
  async getUser(uid: string): Promise<User> {
    try {
      const doc = await this.userCollection.doc(uid).get();
      if (!doc.exists) {
        throw new Error("user not found");
      }
      const userHandler = UserHandler.fromFirestore(doc.data()!);
      return userHandler.toModel();
    } catch (error) {
      console.error(error);
      throw error;
    }
  }
  async setUser(uid: string, data: Partial<User>): Promise<void> {
    try {
      await this.userCollection.doc(uid).update(data);
    } catch (error) {
      console.error(error);
      throw error;
    }
  }
  async deleteUser(uid: string): Promise<void> {
    try {
      await this.userCollection.doc(uid).delete;
    } catch (error) {
      console.error(error);
      throw error;
    }
  }
  async addUser(user: User): Promise<void> {
    try {
      const handler = user.toHandler();
      const data = handler.toFirestore();
      await this.userCollection.doc(user.getUid).set(data);
    } catch (error) {
      console.error(error);
      throw error;
    }
  }
  async findUser(uid: string): Promise<boolean> {
    try {
      const doc = await this.userCollection.doc(uid).get();
      return doc.exists;
    } catch (error) {
      console.error(error);
      throw error;
    }
  }
}
