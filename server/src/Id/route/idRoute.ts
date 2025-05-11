import getNewId from "../service/generateId";
import express from "express"

const idRoute = express();

idRoute.get("/get",async (req, res) => {
    try {
        const { type } = req.query;
        if (!type || (type !== 'task' && type !== 'schedule')) {
            return res.status(400).json({ error: 'Invalid or missing "type" parameter' });
        }
        const newId = await getNewId(type);
        return res.status(200).json({ Id: newId });
    } catch (error) {
        console.error(error);
        return res.status(500).json(error);
    }
})

export default idRoute;