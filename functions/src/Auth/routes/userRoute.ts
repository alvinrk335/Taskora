import { Router } from "express"
import { googleLogin } from "../services/googleLogin"

const router = Router()

router.post("/login", async (req, res) => {
    try {
        const token = req.body.token
        if (!token) {
            throw new Error("Token is required");
        }
        const login = await googleLogin(token)

        res.json(login)
    } catch (error) {
        console.error(error)
        res.status(500).json({ error: error instanceof Error ? error.message : 'An unexpected error occurred' });
    }
})
export default router;