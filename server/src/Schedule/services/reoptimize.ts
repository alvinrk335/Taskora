import axios from "axios"

function sanitizeLLMResponse(raw: string): string {
  return raw
    .trim()
    .replace(/^```json\s*/, "") // hapus pembuka blok
    .replace(/```$/, "")        // hapus penutup blok
    .trim();
}

const logHelper = "[REOPTIMIZER]"
export default async function reOptimize(scheduleJson: any, request: string, workhours: any){
    const formattedSchedule = typeof scheduleJson === "string" 
    ? scheduleJson 
    : JSON.stringify(scheduleJson, null, 2);
    const prompt = `
    you are a strict JSON translator, 
    only response with a JSON object without any additional explanation or markdown.

    with this schedule data:
    ${formattedSchedule}
    
    and this work hours data:
    ${workhours}


    please change it based on this request:
    ${request}
    ⚠️ Important:
    - DO NOT remove any existing tasks unless explicitly stated in the request.
    - DO NOT change any scheduleId and taskId
    - Preserve all fields that is not expliclitly or implicitly stated in the request.
    - Add the new task(s) if required, and integrate them into the workload accordingly.
    - Keep the JSON format and structure exactly the same as the input.
    - make sure sum of all workload each day does not exceed that of the work hours in that certain day
    - please make sure that break day still exist based on the break day pattern you see in the workloads

    with the format still the same as the initial schedule data
    `
    console.log(`${logHelper} input to reoptimizer : ${prompt}`)
    const response = await axios.post("http://llm:8008/ask-gemini",{
        prompt
    })

    let raw = response.data.response
    if (typeof raw !== "string") {
        throw new Error("Expected translatedTask to be a JSON string");
    }
    const sanitized = sanitizeLLMResponse(raw)
    console.log(`response After sanitizing: ${JSON.stringify(sanitized)}`);

    return JSON.parse(sanitized);
}