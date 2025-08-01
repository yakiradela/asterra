FROM python:3.10-slim

# התקנות מערכת
RUN apt-get update && apt-get install -y \
    gdal-bin \
    libgdal-dev \
    gcc \
    g++ \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# הגדרות עבור gdal
ENV CPLUS_INCLUDE_PATH=/usr/include/gdal
ENV C_INCLUDE_PATH=/usr/include/gdal

# עותק קבצים
WORKDIR /app
COPY requirements.txt .

# שלב חשוב - התקן numpy קודם!
RUN pip install --upgrade pip && \
    pip install numpy && \
    pip install --no-cache-dir -r requirements.txt

COPY app/ ./app/
CMD ["python", "app/handler.py"]
