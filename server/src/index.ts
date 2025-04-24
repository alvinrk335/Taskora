import express from "express";
import router from "./Auth/routes/userRoute";
import taskRouter from "./Task/route/taskRoute";
import scheduleRouter from "./Schedule/routes/scheduleRoute";

const app = express();

app.use(express.json());

app.use("/auth", router);
app.use("/task", taskRouter);
app.use("/schedule", scheduleRouter);

const PORT = process.env.PORT || 3000;  // default ke 3000 jika environment variable PORT tidak ada

// Menjalankan server pada port yang ditentukan
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
