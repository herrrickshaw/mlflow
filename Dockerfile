FROM python:3.11-slim

RUN pip install --no-cache-dir mlflow>=2.14.0

RUN mkdir -p /mlflow-data/artifacts
VOLUME ["/mlflow-data"]

EXPOSE 5000

CMD ["mlflow", "server", \
     "--backend-store-uri", "sqlite:////mlflow-data/mlflow.db", \
     "--default-artifact-root", "/mlflow-data/artifacts", \
     "--host", "0.0.0.0", \
     "--port", "5000"]
