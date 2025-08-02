FROM python:3.10-slim

RUN apt-get update && apt-get install -y \
    gdal-bin \
    libgdal-dev \
    gcc \
    g++ \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

ENV CPLUS_INCLUDE_PATH=/usr/include/gdal
ENV C_INCLUDE_PATH=/usr/include/gdal

WORKDIR /app
COPY requirements.txt .

RUN pip install --upgrade pip setuptools wheel && \
    pip install numpy && \
    pip install --no-cache-dir -r requirements.txt
    
COPY app/ ./app/
CMD ["python", "app/handler.py"]
