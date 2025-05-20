import express from "express";
import router from "./Auth/routes/userRoute";
import taskRouter from "./Task/route/taskRoute";
import scheduleRouter from "./Schedule/routes/scheduleRoute";
import idRoute from "./Id/route/idRoute";

const app = express();

app.use(express.json());

app.use("/auth", router);
app.use("/task", taskRouter);
app.use("/schedule", scheduleRouter);
app.use("/id", idRoute)

export default app;
