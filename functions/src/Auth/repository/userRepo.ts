import { User } from "../entity/User";

export default abstract class UserRepo{
    abstract getUser(uid: string): Promise<User>;
    abstract setUser(uid: string, data:Partial<User>): Promise<void>;
    abstract deleteUser(uid:string):Promise<void>;
    abstract addUser(user: User): Promise<void>;
    abstract findUser(uid: string): Promise<boolean>;
}

