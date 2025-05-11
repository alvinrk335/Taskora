// src/Task/service/translateTasks.ts
import axios from "axios";
import initialTask from "../../Task/entity/initialTask";

function sanitizeLLMResponse(raw: string): string {
  return raw
    .trim()
    .replace(/^```json\s*/, "") // hapus pembuka blok
    .replace(/```$/, "")        // hapus penutup blok
    .trim();
}
export default async function translateTasks(listOfTask: initialTask[]) {
  if (!Array.isArray(listOfTask)) {
    throw new Error("listOfTask must be an array");
  }

  return await Promise.all(
    listOfTask.map(async (task) => {
      const prompt = `
        You are a strict JSON translator.
        ONLY return a valid JSON object based on the input below, without any explanation or Markdown.

        I am making an optimized schedule using linear programming with some constraints.
        Please translate this natural language input, with you filling the field missing:
        - taskId: ${task.getTaskId()}
        - taskName: ${task.getTaskName().toString()}
        - description: ${task.getDescription().toString()}
        - priority: ${task.getPriority()}
        - taskType: ${task.getType().toString()}
        - deadline: ${task.getDeadline() ? task.getDeadline()?.toString() : ''}

        Into this JSON format:
        {
          "taskId": same as input,
          "taskName": same as input,
          "estimatedDuration": <estimated duration as number in minutes based on the combination of description, task type, and task name>,
          "weight":  <importance as a decimal between 0 and 1 based on the combination of description, task type and task name>,
          "deadline": same as input
        }
      `;

      const response = await axios.post("http://llm:8008/ask-gemini", {
        prompt,
      });

      let raw = response.data.translatedTasks;
      if (typeof raw !== "string") {
        throw new Error("Expected translatedTask to be a JSON string");
      }
      raw = sanitizeLLMResponse(raw);
      console.log(`response After sanitizing: ${JSON.parse(sanitizeLLMResponse(raw))}`);

      return JSON.parse(raw);
    })
  );
}
