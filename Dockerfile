FROM python:3.8-slim-buster
WORKDIR /app
COPY requirements.txt .
COPY . .
RUN pip install Flask 
RUN pip install -r requirements.txt
EXPOSE 5000
ENTRYPOINT ["python", "app.py"]
