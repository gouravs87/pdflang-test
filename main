from fastapi import FastAPI, HTTPException, Form
from fastapi.responses import HTMLResponse
import uvicorn
from pypdf import PdfReader
import io
import requests
import pycld2 as cld2

app = FastAPI()

def url_to_pdf(url: str) -> PdfReader:
    try:
        response = requests.get(url)
        response.raise_for_status()
        on_fly_mem_obj = io.BytesIO(response.content)
        pdf = PdfReader(on_fly_mem_obj)
        return pdf
    except requests.exceptions.RequestException as e:
        raise HTTPException(status_code=400, detail=f"Error fetching PDF: {e}")

def pdf_to_text(pdf: PdfReader) -> list:
    if pdf is None:
        return []
    
    return [page.extract_text() for page in pdf.pages]

def detect_lang(text: str) -> dict:
    try:
        isReliable, textBytesFound, details = cld2.detect(text, hintLanguage='fr')
    except Exception as e:
        text=''.join(x for x in text if x.isprintable())
        isReliable, textBytesFound, details = cld2.detect(text, hintLanguage='fr')
    #return {language.language_name: language.percent/100 for language in details}
    return {language[0]: language[2]/100 for language in details}

@app.get("/", response_class=HTMLResponse)
def read_root():
    return """
    <html>
        <head>
            <title>PDF Language Detector</title>
        </head>
        <body>
            <h1>PDF Text Extractor</h1>
            <form action="/extract-text/" method="post">
                <label for="url">PDF URL:</label>
                <input type="text" id="url" name="url">
                <button type="submit">Extract Text</button>
            </form>
            <form action="/detect-language/" method="post">
                <label for="url">PDF URL:</label>
                <input type="text" id="url" name="url">
                <button type="submit">Detect Language</button>
            </form>
        </body>
    </html>
    """

@app.post("/extract-text/")
def extract_text(url: str = Form(...)):
    pdf = url_to_pdf(url)
    pages = pdf_to_text(pdf)
    text = {f'page{i+1}': text for i, text in enumerate(pages)}
    return {"text": text}

@app.post("/detect-language/")
def detect_language(url: str = Form(...)):
    pdf = url_to_pdf(url)
    pages = pdf_to_text(pdf)
    lang_details = {f'page{i+1}': detect_lang(text) for i, text in enumerate(pages)}
    return {"language_details": lang_details}

if __name__ == '__main__':
    uvicorn.run('main:app', host='0.0.0.0', port=80, reload=True)
