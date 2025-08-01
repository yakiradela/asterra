FROM python:3.10-slim

# התקנת GDAL וספריות מערכת
RUN apt-get update && apt-get install -y \
    gdal-bin \
    libgdal-dev \
    && rm -rf /var/lib/apt/lists/*

# משתני סביבה למיקום ההידורים של GDAL
ENV CPLUS_INCLUDE_PATH=/usr/include/gdal
ENV C_INCLUDE_PATH=/usr/include/gdal

# תיקיית העבודה
WORKDIR /app

# התקנת דרישות
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# קוד האפליקציה
COPY app/ ./app/

# נקודת כניסה
CMD [ "python", "app/hand]()
