from dotenv import load_dotenv
from fastapi import FastAPI
import os
from pydantic import BaseModel
from google import genai

load_dotenv()
api_key = os.getenv('GEMINI_API_KEY')

app = FastAPI()

client = genai.Client(api_key=api_key)

class Prompt(BaseModel):
    prompt: str


@app.post('/ask-gemini')
def generateResponse(req: Prompt):
    try:
        print(f"llm service received : {req.prompt}")
        response = client.models.generate_content(
            model="gemini-2.0-flash", contents=req.prompt
        )
        print(f"response from model : {response.text}")
        return {"response": response.text}
    except Exception as e:
        print("🔥 Gemini API error:", e)
        return {"error": "Failed to translate tasks"}, 500
