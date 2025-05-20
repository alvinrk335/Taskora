import express from "express";
import router from "./Auth/routes/userRoute";
import taskRouter from "./Task/route/taskRoute";
import scheduleRouter from "./Schedule/routes/scheduleRoute";
import idRoute from "./Id/route/idRoute";
<<<<<<< HEAD
=======
import workHoursRouter from "./WorkHour/routes/workHourRoute";
>>>>>>> 19e03416083a52dbc55c65818d121799ce284671

const app = express();

app.use(express.json());

app.use("/auth", router);
app.use("/task", taskRouter);
app.use("/schedule", scheduleRouter);
app.use("/id", idRoute)
<<<<<<< HEAD
=======
app.use("/workHours", workHoursRouter);
>>>>>>> 19e03416083a52dbc55c65818d121799ce284671

export default app;
