import {Router} from "express";
import {googleLogin} from "../services/googleLogin";
import { User } from "../entity/User";
import { UserHandler } from "../entity/user_handler";
import UserRepository from "../repository/firebaseUserRepository";

const logHelper = "[USER ROUTE]"
const router = Router();
const repo = new UserRepository();
router.post("/login", async (req, res) => {
  try {
    const token = req.body.token;
    if (!token) {
      throw new Error("Token is required");
    }
    const login = await googleLogin(token);

    res.json(login);
  } catch (error) {
    console.error(error);
    res.status(500).json({error: error instanceof Error ? error.message : "An unexpected error occurred"});
  }
});

router.post("/add", async (req, res) => {
  try {
    console.log(`${logHelper} user route is reached`);
    const userJson = req.body.user;
    const user = User.fromJson(userJson);
    await repo.addUser(user);
    res.status(200).json({message: `successfully added user ${user.getUid} into database`});
  } catch (error) {
    console.error(error);
    return res.status(500).json({error: "error adding user to database"});
  }
})
export default router;
