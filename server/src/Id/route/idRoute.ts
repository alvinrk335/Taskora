import getNewId from "../service/generateId";
import express from "express"

const idRoute = express();

idRoute.get("/Id/Get",async (req, res) => {
    try {
        const { type } = req.query;
        if (!type || (type !== 'task' && type !== 'schedule')) {
            return res.status(400).json({ error: 'Invalid or missing "type" parameter' });
        }
        const newId = await getNewId(type);
        res.json({ Id: newId });
    } catch (error) {
        console.error(error);
    }
})

export default idRoute;