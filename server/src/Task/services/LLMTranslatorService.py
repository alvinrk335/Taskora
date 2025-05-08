from dotenv import load_dotenv
from fastapi import FastAPI
import os
from pydantic import BaseModel
import google.generativeai as genai

load_dotenv()
api_key = os.getenv('GEMINI_API_KEY')

app = FastAPI()

genai.configure(api_key=api_key)

model = genai.GenerativeModel('gemini_pro')

class Prompt(BaseModel):
    prompt: str

@app.post('/ask-gemini')
def generateResponse(req: Prompt):
    response = model.generate_content(req.prompt)
    return {"translatedTasks": response.text}
