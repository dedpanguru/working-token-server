FROM python:3.10-slim

RUN mkdir "app"

COPY /backend /app

WORKDIR /app

RUN pip install -r requirements.txt

RUN pip install psycopg2-binary

EXPOSE 8080

CMD ["uvicorn", "backend.main:app", "--port=8080", "--host=0.0.0.0"]