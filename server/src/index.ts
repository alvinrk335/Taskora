import express from "express";
import router from "./Auth/routes/userRoute";
import taskRouter from "./Task/route/taskRoute";
import scheduleRouter from "./Schedule/routes/scheduleRoute";
import idRoute from "./Id/route/idRoute";
<<<<<<< HEAD
<<<<<<< HEAD
=======
import workHoursRouter from "./WorkHour/routes/workHourRoute";
>>>>>>> 19e03416083a52dbc55c65818d121799ce284671
=======
import workHoursRouter from "./WorkHour/routes/workHourRoute";
>>>>>>> master

const app = express();

app.use(express.json());

app.use("/auth", router);
app.use("/task", taskRouter);
app.use("/schedule", scheduleRouter);
app.use("/id", idRoute)
<<<<<<< HEAD
<<<<<<< HEAD
=======
app.use("/workHours", workHoursRouter);
>>>>>>> 19e03416083a52dbc55c65818d121799ce284671
=======
app.use("/workHours", workHoursRouter);
>>>>>>> master

export default app;
